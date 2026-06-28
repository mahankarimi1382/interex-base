<?php

namespace App\Traits\PaymentGateway;

use Exception;
use Carbon\Carbon;
use App\Models\Transaction;
use Illuminate\Support\Str;
use Jenssegers\Agent\Agent;
use App\Models\TemporaryData;
use App\Models\UserNotification;
use App\Traits\TransactionAgent;
use Illuminate\Support\Facades\DB;
use App\Constants\NotificationConst;
use App\Http\Helpers\PaymentGateway;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use App\Constants\PaymentGatewayConst;
use App\Traits\PayLink\TransactionTrait;
use App\Models\Admin\PaymentGateway as PaymentGatewayModel;
use App\Http\Helpers\PushNotificationHelper;
use App\Models\Admin\PaymentGatewayCurrency;
use App\Providers\Admin\BasicSettingsProvider;

/**
 * Alipay+ (Cashier Payment) integration — Sandbox & Production.
 *
 * Auth: RSA256 request signing (NO OAuth token). Each request carries
 *   client-id, Request-Time and a signature header. Responses are signed too.
 *
 * Flow:
 *  1. POST /aps/api/v1/payments/pay  (signed)  -> result + normalUrl
 *  2. Redirect user to normalUrl (web cashier / QR)
 *  3a. Webhook  : Alipay+ POST -> paymentNotifyUrl with paymentResult.resultStatus (S/F)
 *  3b. Redirect : user returns to paymentRedirectUrl -> we run inquiryPayment to confirm
 *
 * NOTE: requires real sandbox credentials from the Alipay+ developer dashboard
 *       (Client ID, merchant RSA private key, Alipay+ public key, gateway domain)
 *       and an HTTPS-reachable paymentNotifyUrl for the webhook path.
 */
trait Alipayplus
{
    use TransactionAgent, TransactionTrait;

    const ALIPAYPLUS_PAY_PATH     = '/aps/api/v1/payments/pay';
    const ALIPAYPLUS_INQUIRY_PATH = '/aps/api/v1/payments/inquiryPayment';

    /**
     * Web entry point dispatched by gatewayDistribute() => "alipayPlusInit"
     */
    public function alipayPlusInit($output = null)
    {
        if (!$output) $output = $this->output;

        if ($output['type'] !== PaymentGatewayConst::TYPEADDMONEY) {
            throw new Exception(__("Alipay+ gateway currently supports Add Money only."));
        }

        $credentials = $this->getAlipayplusCredentials($output);
        $result      = $this->alipayplusPay($output, $credentials);

        return redirect()->away($result['redirect_url']);
    }

    /**
     * Mobile API entry point dispatched as "alipayPlusInitApi"
     */
    public function alipayPlusInitApi($output = null)
    {
        if (!$output) $output = $this->output;

        if ($output['type'] !== PaymentGatewayConst::TYPEADDMONEY) {
            throw new Exception(__("Alipay+ gateway currently supports Add Money only."));
        }

        $credentials = $this->getAlipayplusCredentials($output);
        $result      = $this->alipayplusPay($output, $credentials);

        return [
            'link' => $result['redirect_url'],
            'trx'  => $result['identifier'],
        ];
    }

    /**
     * Build & send the signed /payments/pay request, store the temp record.
     * Returns ['redirect_url' => ..., 'identifier' => ...]
     */
    public function alipayplusPay($output, $credentials)
    {
        $basic_settings = BasicSettingsProvider::get();

        $currency = $output['currency']->currency_code ?? 'USD';
        $amount   = $output['amount']->total_amount ?? 0;
        if ($amount <= 0) {
            throw new Exception(__("Invalid payment amount."));
        }
        // Alipay+ expects the value in the smallest currency unit (e.g. cents) as a string.
        $minor_value = (string) ((int) round($amount * 100));

        $payment_request_id = generate_unique_string('temporary_datas', 'identifier', 60);
        $this->setUrlParams("token=" . $payment_request_id);

        $redirection   = $this->getRedirection();
        $url_parameter = $this->getUrlParams();
        $redirect_url  = $this->setGatewayRoute($redirection['return_url'], PaymentGatewayConst::ALIPAY_PLUS, $url_parameter);
        $notify_url     = $this->setGatewayRoute($redirection['callback_url'], PaymentGatewayConst::ALIPAY_PLUS, $url_parameter);

        $body = [
            'productCode'        => 'CASHIER_PAYMENT',
            'paymentRequestId'   => $payment_request_id,
            'paymentAmount'      => [
                'currency' => $currency,
                'value'    => $minor_value,
            ],
            'paymentMethod'      => [
                'paymentMethodType' => $credentials->payment_method_type,
            ],
            'paymentRedirectUrl' => $redirect_url,
            'paymentNotifyUrl'   => $notify_url,
            'order'              => [
                'referenceOrderId' => $payment_request_id,
                'orderDescription' => __("Add Money") . " - " . ($basic_settings->site_name ?? config('app.name')),
                'orderAmount'      => [
                    'currency' => $currency,
                    'value'    => $minor_value,
                ],
                'env'              => [
                    'terminalType' => request()->expectsJson() ? 'APP' : 'WEB',
                ],
            ],
            'settlementStrategy' => [
                'settlementCurrency' => $currency,
            ],
        ];

        if (!empty($credentials->acquirer_id)) {
            $body['acquirerId'] = $credentials->acquirer_id;
        }

        $response = $this->alipayplusApiRequest($credentials, self::ALIPAYPLUS_PAY_PATH, $body);

        $result_status = $response['result']['resultStatus'] ?? null;
        $redirect      = $response['normalUrl']
            ?? $response['paymentData']
            ?? ($response['redirectActionForm']['redirectUrl'] ?? null);

        // S = success, U = unknown/in-process (cashier page still required)
        if (!in_array($result_status, ['S', 'U']) || empty($redirect)) {
            throw new Exception($this->alipayplusErrorMessage($response));
        }

        $this->alipayplusJunkInsert($response, $payment_request_id);

        return [
            'redirect_url' => $redirect,
            'identifier'   => $payment_request_id,
        ];
    }

    /**
     * Sign + send a request to Alipay+ and verify the response signature.
     */
    public function alipayplusApiRequest($credentials, $path, array $body)
    {
        $request_time = now()->format('Y-m-d\TH:i:sP'); // ISO8601 e.g. 2026-06-27T12:00:00+03:30
        $body_str     = json_encode($body, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

        $sign_content = "POST " . $path . "\n" . $credentials->client_id . "." . $request_time . "." . $body_str;
        $signature    = $this->alipayplusSign($sign_content, $credentials->private_key);

        $url = rtrim($credentials->gateway_domain, '/') . $path;

        $http_response = Http::withoutVerifying()->withHeaders([
            'Content-Type'  => 'application/json; charset=UTF-8',
            'client-id'     => $credentials->client_id,
            'Request-Time'  => $request_time,
            'Signature'     => 'algorithm=RSA256,keyVersion=' . $credentials->key_version . ',signature=' . rawurlencode($signature),
        ])->withBody($body_str, 'application/json')->post($url);

        // Best-effort response signature verification (only when a public key is configured).
        $this->alipayplusVerifyResponse($credentials, $path, $http_response);

        return $http_response->json() ?? [];
    }

    /**
     * Resolve Alipay+ credentials & environment.
     */
    public function getAlipayplusCredentials($output)
    {
        $gateway = $output['gateway'] ?? null;
        if (!$gateway) throw new Exception(__("Payment gateway not available"));

        $client_id      = PaymentGateway::getValueFromGatewayCredentials($gateway, ['client id', 'clientid', 'client-id']);
        $gateway_domain = PaymentGateway::getValueFromGatewayCredentials($gateway, ['gateway domain', 'gateway endpoint', 'endpoint', 'domain']);
        $private_key    = PaymentGateway::getValueFromGatewayCredentials($gateway, ['merchant private key', 'private key', 'privatekey']);
        $public_key     = PaymentGateway::getValueFromGatewayCredentials($gateway, ['alipay public key', 'alipay+ public key', 'alipayplus public key', 'public key']);
        $key_version    = PaymentGateway::getValueFromGatewayCredentials($gateway, ['key version', 'keyversion']);
        $acquirer_id    = PaymentGateway::getValueFromGatewayCredentials($gateway, ['acq id', 'acquirer id', 'test acq id', 'acquirerid']);
        $method_type    = PaymentGateway::getValueFromGatewayCredentials($gateway, ['payment method type', 'wallet', 'payment method']);

        if (empty($client_id) || empty($private_key) || empty($gateway_domain)) {
            throw new Exception(__("Alipay+ gateway is not properly configured. Please set Client ID, Gateway Domain and Private Key."));
        }

        return (object) [
            'client_id'           => trim($client_id),
            'gateway_domain'      => trim($gateway_domain),
            'private_key'         => $private_key,
            'public_key'          => $public_key,
            'key_version'         => trim($key_version) ?: '1',
            'acquirer_id'         => trim($acquirer_id),
            'payment_method_type' => trim($method_type) ?: 'CONNECT_WALLET',
            'mode'                => ($gateway->env == PaymentGatewayConst::ENV_PRODUCTION) ? 'production' : 'sandbox',
        ];
    }

    /**
     * RSA-SHA256 sign a string with the merchant private key, return Base64.
     */
    public function alipayplusSign($content, $private_key)
    {
        $pem  = $this->alipayplusFormatKey($private_key, 'PRIVATE');
        $pkey = openssl_pkey_get_private($pem);
        if ($pkey === false) {
            throw new Exception(__("Alipay+ private key is invalid."));
        }
        $signature = '';
        openssl_sign($content, $signature, $pkey, OPENSSL_ALGO_SHA256);
        return base64_encode($signature);
    }

    /**
     * Verify the Alipay+ response signature (no-op if public key not configured).
     */
    public function alipayplusVerifyResponse($credentials, $path, $http_response)
    {
        if (empty($credentials->public_key)) return true;

        try {
            $response_time = $http_response->header('response-time') ?: $http_response->header('Response-Time');
            $signature_hdr = $http_response->header('signature') ?: $http_response->header('Signature');
            if (!$response_time || !$signature_hdr) return true; // nothing to verify against

            parse_str(str_replace(',', '&', $signature_hdr), $parts);
            $signature = isset($parts['signature']) ? rawurldecode($parts['signature']) : null;
            if (!$signature) return true;

            $content = "POST " . $path . "\n" . $credentials->client_id . "." . $response_time . "." . $http_response->body();
            $pem     = $this->alipayplusFormatKey($credentials->public_key, 'PUBLIC');
            $pub     = openssl_pkey_get_public($pem);
            if ($pub === false) return true;

            if (openssl_verify($content, base64_decode($signature), $pub, OPENSSL_ALGO_SHA256) !== 1) {
                logger("Alipay+ response signature verification failed", ['path' => $path]);
            }
        } catch (Exception $e) {
            logger("Alipay+ response verification error: " . $e->getMessage());
        }
        return true;
    }

    /**
     * Wrap a raw base64 key into PEM format if it is not already.
     */
    public function alipayplusFormatKey($key, $type)
    {
        $key = trim($key);
        if (strpos($key, '-----BEGIN') !== false) {
            return $key;
        }
        $key     = preg_replace('/\s+/', '', $key);
        $wrapped = chunk_split($key, 64, "\n");
        return "-----BEGIN {$type} KEY-----\n{$wrapped}-----END {$type} KEY-----\n";
    }

    public function alipayplusErrorMessage($response)
    {
        return $response['result']['resultMessage']
            ?? $response['result']['resultCode']
            ?? __("Something went wrong while contacting Alipay+. Please try again.");
    }

    /**
     * Persist the temporary record while the user is on the gateway page.
     */
    public function alipayplusJunkInsert($response, $payment_request_id)
    {
        $output = $this->output;
        $creator_table = $creator_id = $wallet_table = $wallet_id = null;

        if (authGuardApi()['type'] == "AGENT") {
            $creator_table = authGuardApi()['user']->getTable();
            $creator_id    = authGuardApi()['user']->id;
            $creator_guard = authGuardApi()['guard'];
            $wallet_table  = $output['wallet']->getTable();
            $wallet_id     = $output['wallet']->id;
        } else {
            $creator_table = auth()->guard(get_auth_guard())->user()->getTable();
            $creator_id    = auth()->guard(get_auth_guard())->user()->id;
            $creator_guard = get_auth_guard();
            $wallet_table  = $output['wallet']->getTable();
            $wallet_id     = $output['wallet']->id;
        }

        $data = [
            'gateway'       => $output['gateway']->id,
            'currency'      => $output['currency']->id,
            'amount'        => json_decode(json_encode($output['amount']), true),
            'response'      => $response,
            'payment_id'    => $response['paymentId'] ?? null,
            'wallet_table'  => $wallet_table,
            'wallet_id'     => $wallet_id,
            'creator_table' => $creator_table,
            'creator_id'    => $creator_id,
            'creator_guard' => $creator_guard,
        ];

        return TemporaryData::create([
            'user_id'    => Auth::id(),
            'type'       => PaymentGatewayConst::ALIPAY_PLUS,
            'identifier' => $payment_request_id,
            'data'       => $data,
        ]);
    }

    /**
     * Redirect-return path: dispatched by responseReceive('alipayplus') => "alipayplusSuccess".
     * Confirms the payment via inquiryPayment then credits the wallet.
     */
    public function alipayplusSuccess($output = null)
    {
        if (!$output) $output = $this->output;

        $temp_data          = $output['tempData'];
        $payment_request_id = $temp_data['identifier'] ?? null;
        $output['callback_ref'] = $payment_request_id;

        if ($payment_request_id && $this->searchWithReferenceInTransaction($payment_request_id)) {
            return; // already handled (webhook or duplicate return)
        }

        $credentials = $this->getAlipayplusCredentials($output);
        $inquiry     = $this->alipayplusApiRequest($credentials, self::ALIPAYPLUS_INQUIRY_PATH, [
            'paymentRequestId' => $payment_request_id,
        ]);

        $output['capture'] = $inquiry;
        $status = $this->alipayplusResolveStatus($inquiry);

        return $this->alipayplusStoreTransaction($output, $status);
    }

    /**
     * Webhook path: dispatched by handleCallback => "alipayplusCallbackResponse".
     */
    public function alipayplusCallbackResponse($reference, $callback_data, $output = null)
    {
        if (!$output) $output = $this->output;

        $output['callback_ref'] = $reference;
        $output['capture']      = $callback_data;

        if ($reference && $this->searchWithReferenceInTransaction($reference)) {
            return; // already processed via redirect/inquiry
        }

        $status = $this->alipayplusResolveStatus($callback_data);

        // Transaction may already exist (e.g. created as pending) -> just update.
        if (isset($output['transaction']) && $output['transaction'] != null
            && $output['transaction']->status != PaymentGatewayConst::STATUSSUCCESS) {

            $details = json_decode(json_encode($output['transaction']->details), true) ?? [];
            $details['gateway_response'] = $callback_data;

            DB::table($output['transaction']->getTable())->where('id', $output['transaction']->id)->update([
                'status'       => $status,
                'details'      => json_encode($details),
                'callback_ref' => $reference,
            ]);

            if ($status == PaymentGatewayConst::STATUSSUCCESS) {
                if (($output['tempData']->data->creator_guard ?? null) == 'agent' || ($output['tempData']->data->creator_guard ?? null) == 'agent_api') {
                    $this->updateWalletBalanceAgent($output);
                } else {
                    $this->updateWalletBalanceAlipayplus($output);
                }
            }
            logger("Alipay+ transaction updated via webhook. ref: " . $reference);
            return;
        }

        return $this->alipayplusStoreTransaction($output, $status);
    }

    /**
     * Resolve the unified transaction status from a notify/inquiry payload.
     */
    public function alipayplusResolveStatus($payload)
    {
        $payload = json_decode(json_encode($payload), true);

        $payment_result_status = $payload['paymentResult']['resultStatus'] ?? null; // S / F (webhook)
        $payment_status        = $payload['paymentStatus'] ?? null;                  // SUCCESS / FAIL / PROCESSING (inquiry)
        $result_status         = $payload['result']['resultStatus'] ?? null;
        $result_code           = $payload['result']['resultCode'] ?? null;

        if ($payment_result_status === 'S' || $payment_status === 'SUCCESS'
            || ($result_status === 'S' && in_array($result_code, ['SUCCESS', 'PAYMENT_SUCCESS']))) {
            return PaymentGatewayConst::STATUSSUCCESS;
        }

        if ($payment_result_status === 'F' || $payment_status === 'FAIL') {
            return PaymentGatewayConst::STATUSREJECTED;
        }

        return PaymentGatewayConst::STATUSPENDING;
    }

    public function alipayplusStoreTransaction($output, $status)
    {
        if ($output['type'] !== PaymentGatewayConst::TYPEADDMONEY) {
            throw new Exception(__("Alipay+ gateway currently supports Add Money only."));
        }
        $user_guard = request()->expectsJson() ? authGuardApi()['type'] : userGuard()['type'];
        if ($user_guard == "USER") {
            return $this->createTransactionAlipayplus($output, $status);
        }
        return $this->createTransactionChildRecords($output, $status);
    }

    public function createTransactionAlipayplus($output, $status)
    {
        $trx_id      = 'AM' . getTrxNum();
        $inserted_id = $this->insertRecordAlipayplus($output, $trx_id, $status);
        $this->insertChargesAlipayplus($output, $inserted_id);
        $this->adminNotification($trx_id, $output, $status);
        $this->insertDeviceAlipayplus($output, $inserted_id);

        try {
            $this->sendNotifications($output, $trx_id);
        } catch (Exception $e) {
        }

        if ($this->requestIsApiUser()) {
            $api_user_login_guard = $this->output['api_login_guard'] ?? null;
            if ($api_user_login_guard != null) {
                auth()->guard($api_user_login_guard)->logout();
            }
        }
    }

    public function insertRecordAlipayplus($output, $trx_id, $status)
    {
        DB::beginTransaction();
        try {
            if ($this->predefined_user) {
                $user = $this->predefined_user;
            } elseif (Auth::guard(get_auth_guard())->check()) {
                $user = auth()->guard(get_auth_guard())->user();
            }
            $user_id = $user->id;

            if ($status == PaymentGatewayConst::STATUSSUCCESS) {
                $available_balance = $output['wallet']->balance + $output['amount']->requested_amount;
            } else {
                $available_balance = $output['wallet']->balance;
            }

            $details = [
                'amount'           => $output['amount'],
                'gateway_response' => $output['capture'] ?? null,
            ];

            $id = DB::table("transactions")->insertGetId([
                'user_id'                       => $user_id,
                'user_wallet_id'                => $output['wallet']->id,
                'payment_gateway_currency_id'   => $output['currency']->id,
                'type'                          => $output['type'],
                'trx_id'                        => $trx_id,
                'request_amount'                => $output['amount']->requested_amount,
                'payable'                       => $output['amount']->total_amount,
                'available_balance'             => $available_balance,
                'remark'                        => ucwords(remove_speacial_char(PaymentGatewayConst::TYPEADDMONEY, " ")) . " With " . $output['gateway']->name,
                'details'                       => json_encode($details),
                'status'                        => $status,
                'attribute'                     => PaymentGatewayConst::SEND,
                'callback_ref'                  => $output['callback_ref'] ?? null,
                'created_at'                    => now(),
            ]);

            if ($status == PaymentGatewayConst::STATUSSUCCESS) {
                $this->updateWalletBalanceAlipayplus($output);
            }
            DB::commit();
        } catch (Exception $e) {
            DB::rollBack();
            throw new Exception(__("Something went wrong! Please try again."));
        }
        return $id;
    }

    public function updateWalletBalanceAlipayplus($output)
    {
        $update_amount = $output['wallet']->balance + $output['amount']->requested_amount;
        $output['wallet']->update([
            'balance' => $update_amount,
        ]);
    }

    public function insertChargesAlipayplus($output, $id)
    {
        if ($this->predefined_user) {
            $user = $this->predefined_user;
        } elseif (Auth::guard(get_auth_guard())->check()) {
            $user = auth()->guard(get_auth_guard())->user();
        }
        DB::beginTransaction();
        try {
            DB::table('transaction_charges')->insert([
                'transaction_id' => $id,
                'percent_charge' => $output['amount']->percent_charge,
                'fixed_charge'   => $output['amount']->fixed_charge,
                'total_charge'   => $output['amount']->total_charge,
                'created_at'     => now(),
            ]);
            DB::commit();

            $notification_content = [
                'title'   => __("Add Money"),
                'message' => __("Your Wallet") . " (" . $output['wallet']->currency->code . ")  " . __("balance  has been added") . " " . $output['amount']->requested_amount . ' ' . $output['wallet']->currency->code,
                'time'    => Carbon::now()->diffForHumans(),
                'image'   => get_image($user->image, 'user-profile'),
            ];

            UserNotification::create([
                'type'    => NotificationConst::BALANCE_ADDED,
                'user_id' => $user->id,
                'message' => $notification_content,
            ]);

            try {
                (new PushNotificationHelper())->prepare([$user->id], [
                    'title'     => $notification_content['title'],
                    'desc'      => $notification_content['message'],
                    'user_type' => 'user',
                ])->send();
            } catch (Exception $e) {
            }
        } catch (Exception $e) {
            DB::rollBack();
            throw new Exception(__("Something went wrong! Please try again."));
        }
    }

    public function insertDeviceAlipayplus($output, $id)
    {
        $client_ip = request()->ip() ?? false;
        $location  = geoip()->getLocation($client_ip);
        $agent     = new Agent();

        DB::beginTransaction();
        try {
            DB::table("transaction_devices")->insert([
                'transaction_id' => $id,
                'ip'             => $client_ip,
                'mac'            => "",
                'city'           => $location['city'] ?? "",
                'country'        => $location['country'] ?? "",
                'longitude'      => $location['lon'] ?? "",
                'latitude'       => $location['lat'] ?? "",
                'timezone'       => $location['timezone'] ?? "",
                'browser'        => $agent->browser() ?? "",
                'os'             => $agent->platform() ?? "",
            ]);
            DB::commit();
        } catch (Exception $e) {
            DB::rollBack();
            throw new Exception(__("Something went wrong! Please try again."));
        }
    }

    /**
     * Gateway recognition helper (used by getCallbackResponseMethod).
     */
    public function isAlipayplus($gateway)
    {
        $search_keyword = ['alipayplus', 'alipay plus', 'alipay+', 'alipay-plus', 'alipayplus gateway'];
        $gateway_name   = $gateway->name;

        $search_text = preg_replace("/[^A-Za-z0-9]/", "", Str::lower($gateway_name));
        foreach ($search_keyword as $keyword) {
            $keyword = preg_replace("/[^A-Za-z0-9]/", "", Str::lower($keyword));
            if ($keyword == $search_text) {
                return true;
            }
        }
        return false;
    }
}
