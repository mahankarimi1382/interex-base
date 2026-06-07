<?php

namespace Tests\Feature\Api;

use Tests\TestCase;

/**
 * Validates the route definitions in routes/api/agent_api.php.
 *
 * This file is registered under the "agent-api" prefix by the
 * RouteServiceProvider, and almost every endpoint additionally lives under
 * the "agent/" group prefix.
 */
class AgentApiRoutesTest extends TestCase
{
    use ApiRouteTestHelpers;

    private const PREFIX = 'agent-api';

    public function test_agent_api_routes_are_registered(): void
    {
        $this->assertGreaterThan(
            0,
            $this->countRoutesWithPrefix(self::PREFIX.'/'),
            'No routes were registered under the "agent-api" prefix.'
        );
    }

    public function test_public_utility_routes(): void
    {
        $this->assertRoute('GET', self::PREFIX.'/clear-cache');
        $this->assertRoute('GET', self::PREFIX.'/agent/get/basic/data');
        $this->assertRoute(
            'GET',
            self::PREFIX.'/app-settings',
            'App\Http\Controllers\Api\AppSettingsController@appSettings'
        );
        $languages = $this->assertRoute(
            'GET',
            self::PREFIX.'/app-settings/languages',
            'App\Http\Controllers\Api\AppSettingsController@languages'
        );
        $this->assertRouteExcludesMiddleware($languages, 'system.maintenance.api');
    }

    public function test_registration_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Agent\AuthorizationController@';

        $this->assertRoute('POST', self::PREFIX.'/agent/register/check/exist', $base.'checkExist', ['agent.registration.permission']);
        $this->assertRoute('POST', self::PREFIX.'/agent/register/send/otp', $base.'sendOtp', ['agent.registration.permission']);
        $this->assertRoute('POST', self::PREFIX.'/agent/register/email/verify/otp', $base.'verifyEmailOtp');
        $this->assertRoute('POST', self::PREFIX.'/agent/register/email/resend/otp', $base.'resendEmailOtp');
        $this->assertRoute('POST', self::PREFIX.'/agent/register/sms/verify/otp', $base.'verifySmsOtp');
        $this->assertRoute('POST', self::PREFIX.'/agent/register/sms/resend/otp', $base.'resendSmsOtp');
    }

    public function test_auth_routes(): void
    {
        $this->assertRoute(
            'POST',
            self::PREFIX.'/agent/login',
            'App\Http\Controllers\Api\Agent\Auth\LoginController@login'
        );
        $this->assertRoute(
            'POST',
            self::PREFIX.'/agent/register',
            'App\Http\Controllers\Api\Agent\Auth\LoginController@register',
            ['agent.registration.permission']
        );
        $this->assertRoute(
            'GET',
            self::PREFIX.'/agent/logout',
            'App\Http\Controllers\Api\Agent\Auth\LoginController@logout',
            ['agent.api']
        );
    }

    public function test_forget_password_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Agent\Auth\ForgotPasswordController@';

        $this->assertRoute('POST', self::PREFIX.'/agent/forget/password', $base.'sendCode');
        $this->assertRoute('POST', self::PREFIX.'/agent/forget/verify/otp', $base.'verifyCode');
        $this->assertRoute('POST', self::PREFIX.'/agent/forget/email/resend', $base.'emailResend');
        $this->assertRoute('POST', self::PREFIX.'/agent/forget/reset/password', $base.'resetPassword');
        $this->assertRoute('POST', self::PREFIX.'/agent/forget/sms/verify/otp', $base.'verifyCodeSms');
        $this->assertRoute('POST', self::PREFIX.'/agent/forget/sms/resend', $base.'smsResend');
        $this->assertRoute('POST', self::PREFIX.'/agent/forget/sms/reset/password', $base.'resetPasswordSms');
    }

    public function test_account_verification_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Agent\AuthorizationController@';

        $this->assertRoute('POST', self::PREFIX.'/agent/send-code', $base.'sendMailCode', ['agent.api']);
        $this->assertRoute('POST', self::PREFIX.'/agent/email-verify', $base.'mailVerify', ['agent.api']);
        $this->assertRoute('POST', self::PREFIX.'/agent/send/code/phone', $base.'sendPhoneCode', ['agent.api']);
        $this->assertRoute('POST', self::PREFIX.'/agent/phone-verify', $base.'phoneVerify', ['agent.api']);
        $this->assertRoute('POST', self::PREFIX.'/agent/google-2fa/otp/verify', $base.'verify2FACode', ['agent.api']);
    }

    public function test_authenticated_account_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Agent\UserController@';

        $this->assertRoute('GET', self::PREFIX.'/agent/dashboard', $base.'home', ['agent.api']);
        $this->assertRoute('GET', self::PREFIX.'/agent/profile', $base.'profile');
        $this->assertRoute('POST', self::PREFIX.'/agent/profile/update', $base.'profileUpdate', ['app.mode.api']);
        $this->assertRoute('POST', self::PREFIX.'/agent/password/update', $base.'passwordUpdate', ['app.mode.api']);
        $this->assertRoute('POST', self::PREFIX.'/agent/delete/account', $base.'deleteAccount', ['app.mode.api']);
        $this->assertRoute('GET', self::PREFIX.'/agent/wallets', $base.'getWallets');
        $this->assertRoute('GET', self::PREFIX.'/agent/get-remaining', $base.'getRemainingBalance');
        $this->assertRoute('GET', self::PREFIX.'/agent/notifications', $base.'notifications');
        $this->assertRoute('POST', self::PREFIX.'/agent/verify/pin', $base.'pinVerify', ['agent.pin.setup.guard']);
    }

    public function test_send_money_and_money_in_routes(): void
    {
        $send = 'App\Http\Controllers\Api\Agent\SendMoneyController@';
        $this->assertRoute('GET', self::PREFIX.'/agent/send-money/info', $send.'sendMoneyInfo');
        $this->assertRoute('POST', self::PREFIX.'/agent/send-money/exist', $send.'checkUser');
        $this->assertRoute('POST', self::PREFIX.'/agent/send-money/qr/scan', $send.'qrScan');
        $this->assertRoute('POST', self::PREFIX.'/agent/send-money/confirmed', $send.'confirmedSendMoney', ['api.kyc']);

        $in = 'App\Http\Controllers\Api\Agent\MoneyInController@';
        $this->assertRoute('GET', self::PREFIX.'/agent/money-in/info', $in.'MoneyInInfo');
        $this->assertRoute('POST', self::PREFIX.'/agent/money-in/exist', $in.'checkUser');
        $this->assertRoute('POST', self::PREFIX.'/agent/money-in/confirmed', $in.'confirmedMoneyIn', ['api.kyc']);
    }

    public function test_withdraw_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Agent\WithdrawController@';

        $this->assertRoute('GET', self::PREFIX.'/agent/withdraw/info', $base.'withdrawInfo');
        $this->assertRoute('POST', self::PREFIX.'/agent/withdraw/insert', $base.'withdrawInsert', ['api.kyc']);
        $this->assertRoute('POST', self::PREFIX.'/agent/withdraw/manual/confirmed', $base.'withdrawConfirmed', ['api.kyc']);
        $this->assertRoute('POST', self::PREFIX.'/agent/withdraw/automatic/confirmed', $base.'confirmWithdrawAutomatic', ['api.kyc']);
        $this->assertRoute('GET', self::PREFIX.'/agent/withdraw/get/flutterwave/banks', $base.'getBanks', ['api.kyc']);
        $this->assertRoute('GET', self::PREFIX.'/agent/withdraw/get/flutterwave/bank/branches', $base.'getFlutterWaveBankBranches');
    }

    public function test_money_exchange_and_bill_topup_routes(): void
    {
        $this->assertRoute('GET', self::PREFIX.'/agent/money-exchange', 'App\Http\Controllers\Api\Agent\MoneyExchangeController@index');
        $this->assertRoute('POST', self::PREFIX.'/agent/money-exchange/submit', 'App\Http\Controllers\Api\Agent\MoneyExchangeController@moneyExchangeSubmit', ['api.kyc']);

        $this->assertRoute('GET', self::PREFIX.'/agent/bill-pay/info', 'App\Http\Controllers\Api\Agent\BillPayController@billPayInfo');
        $this->assertRoute('POST', self::PREFIX.'/agent/bill-pay/confirmed', 'App\Http\Controllers\Api\Agent\BillPayController@billPayConfirmed', ['api.kyc']);

        $this->assertRoute('GET', self::PREFIX.'/agent/mobile-topup/info', 'App\Http\Controllers\Api\Agent\MobileTopupController@topUpInfo');
        $this->assertRoute('POST', self::PREFIX.'/agent/mobile-topup/confirmed', 'App\Http\Controllers\Api\Agent\MobileTopupController@topUpConfirmed', ['api.kyc']);
        $this->assertRoute('GET', self::PREFIX.'/agent/mobile-topup/automatic/check-operator', 'App\Http\Controllers\Api\Agent\MobileTopupController@checkOperator');
        $this->assertRoute('POST', self::PREFIX.'/agent/mobile-topup/automatic/pay', 'App\Http\Controllers\Api\Agent\MobileTopupController@payAutomatic', ['api.kyc']);
    }

    public function test_recipient_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Agent\RecipientController@';

        $this->assertRoute('GET', self::PREFIX.'/agent/recipient/dynamic/fields', $base.'dynamicFields');
        $this->assertRoute('GET', self::PREFIX.'/agent/recipient/save/info', $base.'saveRecipientInfo');
        $this->assertRoute('POST', self::PREFIX.'/agent/recipient/check/user', $base.'checkUser');
        // sender recipient group
        $this->assertRoute('GET', self::PREFIX.'/agent/recipient/sender/list', $base.'recipientList');
        $this->assertRoute('POST', self::PREFIX.'/agent/recipient/sender/store', $base.'storeRecipient', ['api.kyc']);
        // receiver recipient group
        $this->assertRoute('GET', self::PREFIX.'/agent/recipient/receiver/list', $base.'recipientListReceiver');
        $this->assertRoute('POST', self::PREFIX.'/agent/recipient/receiver/store', $base.'storeRecipientReceiver', ['api.kyc']);
    }

    public function test_remittance_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Agent\RemittanceController@';

        $this->assertRoute('GET', self::PREFIX.'/agent/remittance/info', $base.'remittanceInfo');
        $this->assertRoute('POST', self::PREFIX.'/agent/remittance/confirmed', $base.'confirmed', ['api.kyc']);
        $this->assertRoute('POST', self::PREFIX.'/agent/remittance/get/recipient/sender', $base.'getRecipientSender', ['api.kyc']);
        $this->assertRoute('POST', self::PREFIX.'/agent/remittance/get/recipient/receiver', $base.'getRecipientReceiver', ['api.kyc']);
    }

    public function test_security_and_transactions_routes(): void
    {
        $this->assertRoute('GET', self::PREFIX.'/agent/security/google-2fa', 'App\Http\Controllers\Api\Agent\SecurityController@google2FA');
        $this->assertRoute('POST', self::PREFIX.'/agent/security/google-2fa/status/update', 'App\Http\Controllers\Api\Agent\SecurityController@google2FAStatusUpdate', ['app.mode.api']);

        $route = $this->assertRoute('GET', self::PREFIX.'/agent/transactions/{slug?}', 'App\Http\Controllers\Api\Agent\TransactionController@index');
        $this->assertContains('slug', $route->parameterNames());
    }

    public function test_add_money_callback_routes_are_public(): void
    {
        $base = 'App\Http\Controllers\Api\Agent\AddMoneyController@';

        $this->assertRoute('GET', self::PREFIX.'/agent/add-money/information', $base.'addMoneyInformation');
        $this->assertRoute('POST', self::PREFIX.'/agent/add-money/submit-data', $base.'submitData');

        // Gateway callbacks must opt out of the agent auth stack.
        $success = $this->assertRoute('GET', self::PREFIX.'/agent/add-money/success/paypal/response/{gateway}', $base.'success');
        $this->assertRouteExcludesMiddleware($success, 'agent.api');

        $stripe = $this->assertRoute('GET', self::PREFIX.'/agent/add-money/stripe/payment/success/{trx}', $base.'stripePaymentSuccess');
        $this->assertRouteExcludesMiddleware($stripe, 'agent.api');
    }

    public function test_unknown_route_is_not_registered(): void
    {
        $this->assertRouteMissing('GET', self::PREFIX.'/agent/this-endpoint-does-not-exist');
    }
}
