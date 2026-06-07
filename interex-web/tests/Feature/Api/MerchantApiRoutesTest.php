<?php

namespace Tests\Feature\Api;

use Tests\TestCase;

/**
 * Validates the route definitions in routes/api/merchant_api.php.
 *
 * This file is registered under the "merchant-api" prefix by the
 * RouteServiceProvider, and almost every endpoint additionally lives under
 * the "merchant/" group prefix.
 */
class MerchantApiRoutesTest extends TestCase
{
    use ApiRouteTestHelpers;

    private const PREFIX = 'merchant-api';

    public function test_merchant_api_routes_are_registered(): void
    {
        $this->assertGreaterThan(
            0,
            $this->countRoutesWithPrefix(self::PREFIX.'/'),
            'No routes were registered under the "merchant-api" prefix.'
        );
    }

    public function test_public_utility_routes(): void
    {
        $this->assertRoute('GET', self::PREFIX.'/clear-cache');
        $this->assertRoute('GET', self::PREFIX.'/merchant/get/basic/data');
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
        $base = 'App\Http\Controllers\Api\Merchant\AuthorizationController@';

        $this->assertRoute('POST', self::PREFIX.'/merchant/register/check/exist', $base.'checkExist', ['merchant.registration.permission']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/register/send/otp', $base.'sendOtp', ['merchant.registration.permission']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/register/email/verify/otp', $base.'verifyEmailOtp');
        $this->assertRoute('POST', self::PREFIX.'/merchant/register/email/resend/otp', $base.'resendEmailOtp');
        $this->assertRoute('POST', self::PREFIX.'/merchant/register/sms/verify/otp', $base.'verifySmsOtp');
        $this->assertRoute('POST', self::PREFIX.'/merchant/register/sms/resend/otp', $base.'resendSmsOtp');
    }

    public function test_auth_routes(): void
    {
        $this->assertRoute(
            'POST',
            self::PREFIX.'/merchant/login',
            'App\Http\Controllers\Api\Merchant\Auth\LoginController@login'
        );
        $this->assertRoute(
            'POST',
            self::PREFIX.'/merchant/register',
            'App\Http\Controllers\Api\Merchant\Auth\LoginController@register',
            ['merchant.registration.permission']
        );
        $this->assertRoute(
            'GET',
            self::PREFIX.'/merchant/logout',
            'App\Http\Controllers\Api\Merchant\Auth\LoginController@logout',
            ['merchant.api']
        );
    }

    public function test_forget_password_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Merchant\Auth\ForgotPasswordController@';

        $this->assertRoute('POST', self::PREFIX.'/merchant/forget/password', $base.'sendCode');
        $this->assertRoute('POST', self::PREFIX.'/merchant/forget/verify/otp', $base.'verifyCode');
        $this->assertRoute('POST', self::PREFIX.'/merchant/forget/email/resend', $base.'emailResend');
        $this->assertRoute('POST', self::PREFIX.'/merchant/forget/reset/password', $base.'resetPassword');
        $this->assertRoute('POST', self::PREFIX.'/merchant/forget/sms/verify/otp', $base.'verifyCodeSms');
        $this->assertRoute('POST', self::PREFIX.'/merchant/forget/sms/resend', $base.'smsResend');
        $this->assertRoute('POST', self::PREFIX.'/merchant/forget/sms/reset/password', $base.'resetPasswordSms');
    }

    public function test_account_verification_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Merchant\AuthorizationController@';

        $this->assertRoute('POST', self::PREFIX.'/merchant/send-code', $base.'sendMailCode', ['merchant.api']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/email-verify', $base.'mailVerify', ['merchant.api']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/send/code/phone', $base.'sendPhoneCode', ['merchant.api']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/phone-verify', $base.'phoneVerify', ['merchant.api']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/google-2fa/otp/verify', $base.'verify2FACode', ['merchant.api']);
    }

    public function test_authenticated_account_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Merchant\UserController@';

        $this->assertRoute('GET', self::PREFIX.'/merchant/dashboard', $base.'home', ['merchant.api']);
        $this->assertRoute('GET', self::PREFIX.'/merchant/profile', $base.'profile');
        $this->assertRoute('POST', self::PREFIX.'/merchant/profile/update', $base.'profileUpdate', ['app.mode.api']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/password/update', $base.'passwordUpdate', ['app.mode.api']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/delete/account', $base.'deleteAccount', ['app.mode.api']);
        $this->assertRoute('GET', self::PREFIX.'/merchant/wallets', $base.'getWallets');
        $this->assertRoute('GET', self::PREFIX.'/merchant/get-remaining', $base.'getRemainingBalance');
        $this->assertRoute('GET', self::PREFIX.'/merchant/notifications', $base.'notifications');
        $this->assertRoute('POST', self::PREFIX.'/merchant/verify/pin', $base.'pinVerify', ['merchant.pin.setup.guard']);
    }

    public function test_receive_money_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Merchant\ReceiveMoneyController@';

        $this->assertRoute('GET', self::PREFIX.'/merchant/receive-money', $base.'index');
        $this->assertRoute('POST', self::PREFIX.'/merchant/receive-money/refund-balance-make-payment', $base.'refundBalanceForMakePayment', ['api.kyc']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/receive-money/refund-balance-payment-gateway', $base.'refundBalanceForPaymentGateway', ['api.kyc']);
    }

    public function test_money_feature_routes(): void
    {
        $this->assertRoute('GET', self::PREFIX.'/merchant/money-exchange', 'App\Http\Controllers\Api\Merchant\MoneyExchangeController@index');
        $this->assertRoute('POST', self::PREFIX.'/merchant/money-exchange/submit', 'App\Http\Controllers\Api\Merchant\MoneyExchangeController@moneyExchangeSubmit', ['api.kyc']);
        $this->assertRoute('GET', self::PREFIX.'/merchant/withdraw/info', 'App\Http\Controllers\Api\Merchant\MoneyOutController@moneyOutInfo');
        $this->assertRoute('POST', self::PREFIX.'/merchant/withdraw/insert', 'App\Http\Controllers\Api\Merchant\MoneyOutController@moneyOutInsert');
        $this->assertRoute('POST', self::PREFIX.'/merchant/withdraw/manual/confirmed', 'App\Http\Controllers\Api\Merchant\MoneyOutController@moneyOutConfirmed', ['api.kyc']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/withdraw/automatic/confirmed', 'App\Http\Controllers\Api\Merchant\MoneyOutController@confirmMoneyOutAutomatic', ['api.kyc']);
    }

    public function test_payment_link_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Merchant\PaymentLinkController@';

        $this->assertRoute('GET', self::PREFIX.'/merchant/payment-links', $base.'index');
        $this->assertRoute('POST', self::PREFIX.'/merchant/payment-links/store', $base.'store', ['api.kyc']);
        $this->assertRoute('GET', self::PREFIX.'/merchant/payment-links/edit', $base.'edit');
        $this->assertRoute('POST', self::PREFIX.'/merchant/payment-links/update', $base.'update', ['api.kyc']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/payment-links/status', $base.'status', ['api.kyc']);
    }

    public function test_developer_api_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Merchant\DeveloperApiController@';

        $this->assertRoute('GET', self::PREFIX.'/merchant/developer/api', $base.'index');
        $this->assertRoute('POST', self::PREFIX.'/merchant/developer/api/key/generate', $base.'generateApiKeys', ['app.mode.api', 'api.kyc']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/developer/api/mode/update', $base.'updateMode', ['app.mode.api', 'api.kyc']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/developer/api/key/delete', $base.'deleteKys', ['app.mode.api', 'api.kyc']);
    }

    public function test_gateway_settings_routes(): void
    {
        $base = 'App\Http\Controllers\Api\Merchant\GatewaySettingController@';

        $this->assertRoute('GET', self::PREFIX.'/merchant/gateway-settings', $base.'index');
        $this->assertRoute('POST', self::PREFIX.'/merchant/gateway-settings/update/wallet/status', $base.'updateWalletStatus', ['app.mode.api']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/gateway-settings/update/virtual/card/status', $base.'updateVirtualCardStatus', ['app.mode.api']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/gateway-settings/update/master/card/status', $base.'updateMasterCardStatus', ['app.mode.api']);
        $this->assertRoute('POST', self::PREFIX.'/merchant/gateway-settings/update/master/card/credentials', $base.'updateMasterCardCredentials', ['app.mode.api']);
    }

    public function test_security_and_transactions_routes(): void
    {
        $this->assertRoute('POST', self::PREFIX.'/merchant/google/2fa/verify', 'App\Http\Controllers\Api\Merchant\SecurityController@verifyGoogle2Fa');
        $this->assertRoute('GET', self::PREFIX.'/merchant/security/google-2fa', 'App\Http\Controllers\Api\Merchant\SecurityController@google2FA');
        $this->assertRoute('POST', self::PREFIX.'/merchant/security/google-2fa/status/update', 'App\Http\Controllers\Api\Merchant\SecurityController@google2FAStatusUpdate', ['app.mode.api']);

        $route = $this->assertRoute('GET', self::PREFIX.'/merchant/transactions/{slug?}', 'App\Http\Controllers\Api\Merchant\TransactionController@index');
        $this->assertContains('slug', $route->parameterNames());
    }

    public function test_unknown_route_is_not_registered(): void
    {
        $this->assertRouteMissing('GET', self::PREFIX.'/merchant/this-endpoint-does-not-exist');
    }
}
