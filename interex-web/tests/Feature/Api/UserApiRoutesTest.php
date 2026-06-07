<?php

namespace Tests\Feature\Api;

use Tests\TestCase;

/**
 * Validates the route definitions in routes/api/api.php.
 *
 * This file is registered under the "api" prefix by the RouteServiceProvider,
 * so every endpoint below is expected to live under "api/...".
 */
class UserApiRoutesTest extends TestCase
{
    use ApiRouteTestHelpers;

    private const PREFIX = 'api';

    public function test_user_api_routes_are_registered(): void
    {
        $this->assertGreaterThan(
            0,
            $this->countRoutesWithPrefix(self::PREFIX.'/'),
            'No routes were registered under the "api" prefix.'
        );
    }

    public function test_public_utility_routes(): void
    {
        $this->assertRoute('GET', self::PREFIX.'/clear-cache');
        $this->assertRoute('GET', self::PREFIX.'/get/basic/data');
        $this->assertRoute(
            'GET',
            self::PREFIX.'/app-settings',
            'App\Http\Controllers\Api\AppSettingsController@appSettings'
        );
        // languages endpoint must opt out of the maintenance middleware.
        $languages = $this->assertRoute(
            'GET',
            self::PREFIX.'/app-settings/languages',
            'App\Http\Controllers\Api\AppSettingsController@languages'
        );
        $this->assertRouteExcludesMiddleware($languages, 'system.maintenance.api');
    }

    public function test_registration_routes(): void
    {
        $base = 'App\Http\Controllers\Api\User\AuthorizationController@';

        $this->assertRoute('POST', self::PREFIX.'/user/register/check/exist', $base.'checkExist', ['user.registration.permission']);
        $this->assertRoute('POST', self::PREFIX.'/user/register/send/otp', $base.'sendOtp', ['user.registration.permission']);
        $this->assertRoute('POST', self::PREFIX.'/user/register/email/verify/otp', $base.'verifyEmailOtp');
        $this->assertRoute('POST', self::PREFIX.'/user/register/email/resend/otp', $base.'resendEmailOtp');
        $this->assertRoute('POST', self::PREFIX.'/user/register/sms/verify/otp', $base.'verifySmsOtp');
        $this->assertRoute('POST', self::PREFIX.'/user/register/sms/resend/otp', $base.'resendSmsOtp');
    }

    public function test_auth_routes(): void
    {
        $this->assertRoute(
            'POST',
            self::PREFIX.'/user/register',
            'App\Http\Controllers\Api\User\Auth\LoginController@register',
            ['user.registration.permission']
        );
        $this->assertRoute(
            'POST',
            self::PREFIX.'/user/login',
            'App\Http\Controllers\Api\User\Auth\LoginController@login'
        );
        $this->assertRoute(
            'GET',
            self::PREFIX.'/user/logout',
            'App\Http\Controllers\Api\User\Auth\LoginController@logout',
            ['auth.api', 'verification.guard.api']
        );
    }

    public function test_forget_password_routes(): void
    {
        $base = 'App\Http\Controllers\Api\User\Auth\ForgotPasswordController@';

        $this->assertRoute('POST', self::PREFIX.'/user/forget/password', $base.'sendCode');
        $this->assertRoute('POST', self::PREFIX.'/user/forget/verify/otp', $base.'verifyCode');
        $this->assertRoute('POST', self::PREFIX.'/user/forget/email/resend', $base.'emailResend');
        $this->assertRoute('POST', self::PREFIX.'/user/forget/reset/password', $base.'resetPassword');
        $this->assertRoute('POST', self::PREFIX.'/user/forget/sms/verify/otp', $base.'verifyCodeSms');
        $this->assertRoute('POST', self::PREFIX.'/user/forget/sms/resend', $base.'smsResend');
        $this->assertRoute('POST', self::PREFIX.'/user/forget/sms/reset/password', $base.'resetPasswordSms');
    }

    public function test_authenticated_account_routes(): void
    {
        $base = 'App\Http\Controllers\Api\User\UserController@';

        $this->assertRoute('GET', self::PREFIX.'/user/dashboard', $base.'home', ['auth.api']);
        $this->assertRoute('GET', self::PREFIX.'/user/profile', $base.'profile', ['auth.api']);
        $this->assertRoute('POST', self::PREFIX.'/user/profile/update', $base.'profileUpdate', ['app.mode.api']);
        $this->assertRoute('POST', self::PREFIX.'/user/password/update', $base.'passwordUpdate', ['app.mode.api']);
        $this->assertRoute('POST', self::PREFIX.'/user/delete/account', $base.'deleteAccount', ['app.mode.api']);
        $this->assertRoute('GET', self::PREFIX.'/user/wallets', $base.'getWallets');
        $this->assertRoute('GET', self::PREFIX.'/user/get-remaining', $base.'getRemainingBalance');
        $this->assertRoute('GET', self::PREFIX.'/user/notifications', $base.'notifications');
        $this->assertRoute('POST', self::PREFIX.'/user/verify/pin', $base.'pinVerify', ['user.pin.setup.guard']);
    }

    public function test_money_feature_routes(): void
    {
        $this->assertRoute('GET', self::PREFIX.'/user/send-money/info', 'App\Http\Controllers\Api\User\SendMoneyController@sendMoneyInfo');
        $this->assertRoute('POST', self::PREFIX.'/user/send-money/confirmed', 'App\Http\Controllers\Api\User\SendMoneyController@confirmedSendMoney', ['api.kyc']);
        $this->assertRoute('GET', self::PREFIX.'/user/withdraw/info', 'App\Http\Controllers\Api\User\MoneyOutController@moneyOutInfo');
        $this->assertRoute('POST', self::PREFIX.'/user/withdraw/insert', 'App\Http\Controllers\Api\User\MoneyOutController@moneyOutInsert', ['api.kyc']);
        $this->assertRoute('GET', self::PREFIX.'/user/add-money/information', 'App\Http\Controllers\Api\User\AddMoneyController@addMoneyInformation');
        $this->assertRoute('POST', self::PREFIX.'/user/add-money/submit-data', 'App\Http\Controllers\Api\User\AddMoneyController@submitData');
        $this->assertRoute('GET', self::PREFIX.'/user/money-exchange', 'App\Http\Controllers\Api\User\MoneyExchangeController@index');
        $this->assertRoute('POST', self::PREFIX.'/user/money-exchange/submit', 'App\Http\Controllers\Api\User\MoneyExchangeController@moneyExchangeSubmit', ['api.kyc']);
    }

    public function test_virtual_card_routes(): void
    {
        $this->assertRoute('GET', self::PREFIX.'/user/my-card', 'App\Http\Controllers\Api\User\VirtualCardController@index');
        $this->assertRoute('POST', self::PREFIX.'/user/my-card/create', 'App\Http\Controllers\Api\User\VirtualCardController@cardBuy', ['api.kyc']);
        $this->assertRoute('GET', self::PREFIX.'/user/my-card/sudo', 'App\Http\Controllers\Api\User\SudoVirtualCardController@index');
        $this->assertRoute('GET', self::PREFIX.'/user/my-card/stripe', 'App\Http\Controllers\Api\User\StripeVirtualController@index');
        $this->assertRoute('GET', self::PREFIX.'/user/strowallet-card', 'App\Http\Controllers\Api\User\StrowalletVirtualCardController@index');
        $this->assertRoute('GET', self::PREFIX.'/user/cardyfie-card', 'App\Http\Controllers\Api\User\CardyFieVirtualCardController@index');
    }

    public function test_transactions_route_supports_optional_slug(): void
    {
        $route = $this->assertRoute(
            'GET',
            self::PREFIX.'/user/transactions/{slug?}',
            'App\Http\Controllers\Api\User\TransactionController@index'
        );

        $this->assertContains('slug', $route->parameterNames());
    }

    public function test_unknown_route_is_not_registered(): void
    {
        $this->assertRouteMissing('GET', self::PREFIX.'/user/this-endpoint-does-not-exist');
    }
}
