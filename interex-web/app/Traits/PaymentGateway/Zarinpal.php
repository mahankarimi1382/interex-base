<?php

namespace App\Traits\PaymentGateway;

use Exception;
use Carbon\Carbon;
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
use App\Http\Helpers\PushNotificationHelper;
use App\Providers\Admin\BasicSettingsProvider;

/**
 * Zarinpal payment gateway integration (supports Sandbox & Production).
 *
 * Flow:
 *  1. Payment Request  -> POST {base}/request.json  => returns "authority"
 *  2. Redirect user    -> {base}/StartPay/{authority}
 *  3. Callback (return) -> callback_url?Authority=...&Status=OK|NOK
 *  4. Verify           -> POST {base}/verify.json    => code 100 (or 101 already verified)
 *
 * Docs: https://docs.zarinpal.com  (Sandbox host: sandbox.zarinpal.com)
 */
trait Zarinpal
{
    use TransactionAgent, TransactionTrait;

    /**
     * Entry point dispatched by gatewayDistribute() => "zarinpalInit"
     */
    public function zarinpalInit($output = null)
    {
        if (!$output) $output = $this->output;

        if ($output['type'] !== PaymentGatewayConst::TYPEADDMONEY) {
            throw new Exception(__("Zarinpal gateway currently supports Add Money only."));
        }

        $credentials = $this->getZarinpalCredentials($output);
        $token       = $this->zarinpalRequest($output, $credentials);

        return redirect()->away($credentials->startpay_url . $token['authority']);
    }

    /**
     * Entry point for the mobile API dispatched as "zarinpalInitApi"
     */
    public function zarinpalInitApi($output = null)
    {
        if (!$output) $output = $this->output;

        if ($output['type'] !== PaymentGatewayConst::TYPEADDMONEY) {
            throw new Exception(__("Zarinpal gateway currently supports Add Money only."));
        }

        $credentials = $this->getZarinpalCredentials($output);
        $token       = $this->zarinpalRequest($output, $credentials);

        return [
            'link' => $credentials->startpay_url . $token['authority'],
            'trx'  => $token['identifier'],
        ];
    }

    /**
     * Send the payment request to Zarinpal and store the temporary record.
     * Returns ['authority' => ..., 'identifier' => ...]
     */
    public function zarinpalRequest($output, $credentials)
    {
        $basic_settings = BasicSettingsProvider::get();

        // Zarinpal expects the amount as an integer in the gateway currency (IRR/Rial).
        $amount = (int) round($output['amount']->total_amount ?? 0);
        if ($amount <= 0) {
            throw new Exception(__("Invalid payment amount."));
        }

        $temp_identifier = generate_unique_string('temporary_datas', 'identifier', 60);
        $this->setUrlParams("token=" . $temp_identifier); // identify the transaction when the user returns

        $redirection   = $this->getRedirection();
        $url_parameter = $this->getUrlParams();
        $callback_url  = $this->setGatewayRoute($redirection['return_url'], PaymentGatewayConst::ZARINPAL, $url_parameter);

        $user_email = null;
        if (auth()->guard(get_auth_guard())->check()) {
            $user_email = auth()->guard(get_auth_guard())->user()->email ?? null;
        } elseif (authGuardApi()['user'] ?? false) {
            $user_email = authGuardApi()['user']->email ?? null;
        }

        $payload = [
            'merchant_id'  => $credentials->merchant_id,
            'amount'       => $amount,
            'callback_url' => $callback_url,
            'description'  => __("Add Money") . " - " . ($basic_settings->site_name ?? config('app.name')),
        ];
        if ($user_email) {
            $payload['metadata'] = ['email' => $user_email];
        }

        $response = Http::withoutVerifying()->acceptJson()->asJson()->post($credentials->request_url, $payload)->json();

        $code      = $response['data']['code'] ?? null;
        $authority = $response['data']['authority'] ?? null;

        if ($code != 100 || empty($authority)) {
            $error_message = $this->zarinpalErrorMessage($response);
            throw new Exception($error_message);
        }

        $this->zarinpalJunkInsert($authority, $amount, $temp_identifier);

        return [
            'authority'  => $authority,
            'identifier' => $temp_identifier,
        ];
    }

    /**
     * Extract a human readable error message from a Zarinpal response.
     */
    public function zarinpalErrorMessage($response)
    {
        if (isset($response['errors']) && is_array($response['errors'])) {
            if (isset($response['errors']['message'])) {
                return $response['errors']['message'];
            }
            $first = reset($response['errors']);
            if (is_array($first) && isset($first['message'])) {
                return $first['message'];
            }
        }
        return __("Something went wrong while contacting Zarinpal. Please try again.");
    }

    /**
     * Resolve Zarinpal credentials & the proper environment URLs.
     */
    public function getZarinpalCredentials($output)
    {
        $gateway = $output['gateway'] ?? null;
        if (!$gateway) throw new Exception(__("Payment gateway not available"));

        $merchant_id_sample = ['merchant_id', 'merchant id', 'merchant code', 'merchantcode', 'merchant'];
        $merchant_id = PaymentGateway::getValueFromGatewayCredentials($gateway, $merchant_id_sample);

        $mode = ($gateway->env == PaymentGatewayConst::ENV_PRODUCTION) ? 'production' : 'sandbox';

        if ($mode == 'production') {
            $base     = 'https://payment.zarinpal.com/pg/v4/payment';
            $startpay = 'https://payment.zarinpal.com/pg/StartPay/';
        } else {
            $base     = 'https://sandbox.zarinpal.com/pg/v4/payment';
            $startpay = 'https://sandbox.zarinpal.com/pg/StartPay/';
        }

        return (object) [
            'merchant_id'  => $merchant_id,
            'mode'         => $mode,
            'request_url'  => $base . '/request.json',
            'verify_url'   => $base . '/verify.json',
            'startpay_url' => $startpay,
        ];
    }

    /**
     * Persist the temporary record while the user is on the gateway page.
     */
    public function zarinpalJunkInsert($authority, $amount_sent, $temp_identifier)
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
            'amount_sent'   => $amount_sent,
            'response'      => ['authority' => $authority],
            'wallet_table'  => $wallet_table,
            'wallet_id'     => $wallet_id,
            'creator_table' => $creator_table,
            'creator_id'    => $creator_id,
            'creator_guard' => $creator_guard,
        ];

        return TemporaryData::create([
            'user_id'    => Auth::id(),
            'type'       => PaymentGatewayConst::ZARINPAL,
            'identifier' => $temp_identifier,
            'data'       => $data,
        ]);
    }

    /**
     * Handle the user returning from Zarinpal (verify + create transaction).
     * Dispatched by responseReceive('zarinpal') => "zarinpalSuccess".
     */
    public function zarinpalSuccess($output = null)
    {
        if (!$output) $output = $this->output;

        $temp_data     = $output['tempData'];
        $callback_data = $temp_data['data']->callback_data ?? null;

        $status    = $callback_data->Status ?? $callback_data->status ?? null;
        $authority = $callback_data->Authority
            ?? $callback_data->authority
            ?? ($temp_data['data']->response->authority ?? null);
        $amount    = (int) round($temp_data['data']->amount_sent ?? ($output['amount']->total_amount ?? 0));

        $output['callback_ref'] = $authority;

        // already processed (e.g. duplicate return) -> nothing to do
        if ($authority && $this->searchWithReferenceInTransaction($authority)) {
            return;
        }

        // user cancelled / failed at the gateway
        if ($status !== 'OK') {
            $output['capture'] = ['status' => $status];
            return $this->zarinpalStoreTransaction($output, PaymentGatewayConst::STATUSREJECTED);
        }

        $credentials = $this->getZarinpalCredentials($output);

        $verify = Http::withoutVerifying()->acceptJson()->asJson()->post($credentials->verify_url, [
            'merchant_id' => $credentials->merchant_id,
            'amount'      => $amount,
            'authority'   => $authority,
        ])->json();

        $code = $verify['data']['code'] ?? null;

        // 100 = verified, 101 = already verified
        if ($code == 100 || $code == 101) {
            $transaction_status = PaymentGatewayConst::STATUSSUCCESS;
        } else {
            $transaction_status = PaymentGatewayConst::STATUSREJECTED;
        }

        $output['capture'] = $verify;

        return $this->zarinpalStoreTransaction($output, $transaction_status);
    }

    /**
     * Route the transaction creation to the right owner (user / agent).
     */
    public function zarinpalStoreTransaction($output, $status)
    {
        if ($output['type'] === PaymentGatewayConst::TYPEADDMONEY) {
            $user_guard = request()->expectsJson() ? authGuardApi()['type'] : userGuard()['type'];
            if ($user_guard == "USER") {
                return $this->createTransactionZarinpal($output, $status);
            }
            return $this->createTransactionChildRecords($output, $status);
        }
        throw new Exception(__("Zarinpal gateway currently supports Add Money only."));
    }

    public function createTransactionZarinpal($output, $status)
    {
        $trx_id      = 'AM' . getTrxNum();
        $inserted_id = $this->insertRecordZarinpal($output, $trx_id, $status);
        $this->insertChargesZarinpal($output, $inserted_id);
        $this->adminNotification($trx_id, $output, $status);
        $this->insertDeviceZarinpal($output, $inserted_id);

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

    public function insertRecordZarinpal($output, $trx_id, $status)
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
                $this->updateWalletBalanceZarinpal($output);
            }
            DB::commit();
        } catch (Exception $e) {
            DB::rollBack();
            throw new Exception(__("Something went wrong! Please try again."));
        }
        return $id;
    }

    public function updateWalletBalanceZarinpal($output)
    {
        $update_amount = $output['wallet']->balance + $output['amount']->requested_amount;
        $output['wallet']->update([
            'balance' => $update_amount,
        ]);
    }

    public function insertChargesZarinpal($output, $id)
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

    public function insertDeviceZarinpal($output, $id)
    {
        $client_ip = request()->ip() ?? false;
        $location  = geoip()->getLocation($client_ip);
        $agent     = new Agent();
        $mac       = "";

        DB::beginTransaction();
        try {
            DB::table("transaction_devices")->insert([
                'transaction_id' => $id,
                'ip'             => $client_ip,
                'mac'            => $mac,
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

    public function removeTempDataZarinpal($output)
    {
        TemporaryData::where("identifier", $output['tempData']['identifier'])->delete();
    }

    /**
     * Gateway recognition helper (used by getCallbackResponseMethod).
     */
    public function isZarinpal($gateway)
    {
        $search_keyword = ['zarinpal', 'zarin pal', 'zarin-pal', 'zarinpal gateway', 'zarinpal payment gateway'];
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
