<?php

namespace Tests\Feature\Routes;

use Illuminate\Routing\Route;
use Tests\TestCase;

/**
 * Verifies that every route file declared in the RouteServiceProvider actually
 * contributed routes to the application, and spot-checks representative
 * endpoints from each one.
 *
 * Large panel files (admin/user/merchant/agent) are validated by the number of
 * routes registered under their controller namespace / URL prefix, while the
 * smaller fully-reviewed files (web/global/qr_pay/api) also get explicit
 * named-route assertions.
 */
class RouteFilesRegistrationTest extends TestCase
{
    /**
     * @return Route[]
     */
    private function allRoutes(): array
    {
        return $this->app['router']->getRoutes()->getRoutes();
    }

    private function countByActionNamespace(string $namespace): int
    {
        $count = 0;
        foreach ($this->allRoutes() as $route) {
            if (str_starts_with(ltrim($route->getActionName(), '\\'), ltrim($namespace, '\\'))) {
                $count++;
            }
        }

        return $count;
    }

    private function countByUriPrefix(string $prefix): int
    {
        $count = 0;
        foreach ($this->allRoutes() as $route) {
            if (str_starts_with($route->uri(), $prefix)) {
                $count++;
            }
        }

        return $count;
    }

    private function assertNamedRoutesExist(array $names): void
    {
        foreach ($names as $name) {
            $this->assertTrue(
                $this->app['router']->has($name),
                "Expected named route [{$name}] to be registered."
            );
        }
    }

    // ----- routes/web.php -----------------------------------------------------

    public function test_web_landing_routes(): void
    {
        $this->assertNamedRoutesExist([
            'index', 'about', 'service', 'pricing', 'faq', 'blog', 'blog.details',
            'agent', 'merchant', 'contact', 'contact.store', 'lang',
            'useful.link', 'newsletter.submit', 'header.page',
        ]);

        $this->assertGreaterThanOrEqual(
            10,
            $this->countByActionNamespace('App\Http\Controllers\SiteController'),
            'SiteController landing routes (routes/web.php) are missing.'
        );
    }

    public function test_web_developer_docs_routes(): void
    {
        $this->assertNamedRoutesExist([
            'developer.index', 'developer.prerequisites', 'developer.authentication',
            'developer.base.url', 'developer.examples', 'developer.support',
        ]);
    }

    public function test_web_payment_callback_routes(): void
    {
        $this->assertNamedRoutesExist([
            'add.money.ssl.success', 'add.money.ssl.fail', 'add.money.ssl.cancel',
            'add.money.payment.callback', 'api.add.money.ssl.success',
            'agent.add.money.payment.redirect.form',
            'payment-link.share', 'payment-link.submit', 'payment-link.transaction.success',
            'payment-link.gateway.payment.stripe.success',
            'payment-link.gateway.payment.global.success',
            'payment-link.user.wallet.login',
        ]);
    }

    // ----- routes/global.php --------------------------------------------------

    public function test_global_routes(): void
    {
        $this->assertNamedRoutesExist([
            'global.country.states', 'global.country.cities', 'global.countries',
            'global.countries.user', 'global.countries.agent', 'global.countries.merchant',
            'global.timezones', 'global.set.cookie', 'global.user.wallet.balance',
            'global.mobile.topup.webhook',
            'fileholder.upload', 'fileholder.remove', 'file.download', 'webhook.response',
        ]);
    }

    // ----- routes/payment-gateway/qr_pay/v1/routes.php ------------------------

    public function test_qrpay_payment_gateway_routes(): void
    {
        $this->assertNamedRoutesExist([
            'qrpay.pay.sandbox.v1.user.auth.form',
            'qrpay.pay.sandbox.v1.user.auth.form.submit',
            'qrpay.pay.sandbox.v1.user.payment.preview',
            'qrpay.pay.v1.user.auth.form',
            'qrpay.pay.v1.user.payment.preview',
            'qrpay.pay.v1.user.payment.preview.submit',
        ]);

        // The token/payment-create endpoints are unnamed; assert by URI.
        $this->assertGreaterThanOrEqual(
            4,
            $this->countByUriPrefix('pay/'),
            'QR-Pay gateway routes (routes/payment-gateway/qr_pay/v1/routes.php) are missing.'
        );
    }

    // ----- routes/auth.php ----------------------------------------------------

    public function test_web_auth_routes_registered(): void
    {
        // auth.php registers web auth controllers for user, merchant and agent.
        $this->assertGreaterThanOrEqual(
            5,
            $this->countByActionNamespace('App\Http\Controllers\User\Auth\\'),
            'User web auth routes (routes/auth.php) are missing.'
        );
        $this->assertGreaterThanOrEqual(
            5,
            $this->countByActionNamespace('App\Http\Controllers\Merchant\Auth\\'),
            'Merchant web auth routes (routes/auth.php) are missing.'
        );
        $this->assertGreaterThanOrEqual(
            5,
            $this->countByActionNamespace('App\Http\Controllers\Agent\Auth\\'),
            'Agent web auth routes (routes/auth.php) are missing.'
        );
    }

    // ----- routes/admin.php ---------------------------------------------------

    public function test_admin_panel_routes_registered(): void
    {
        $this->assertGreaterThanOrEqual(
            100,
            $this->countByActionNamespace('App\Http\Controllers\Admin\\'),
            'Admin panel routes (routes/admin.php) are missing.'
        );

        $this->assertGreaterThanOrEqual(
            100,
            $this->countByUriPrefix('admin/'),
            'Routes under the "admin/" prefix are missing.'
        );
    }

    // ----- routes/user.php ----------------------------------------------------

    public function test_user_panel_routes_registered(): void
    {
        $this->assertGreaterThanOrEqual(
            20,
            $this->countByActionNamespace('App\Http\Controllers\User\\'),
            'User panel routes (routes/user.php) are missing.'
        );
    }

    // ----- routes/merchant.php ------------------------------------------------

    public function test_merchant_panel_routes_registered(): void
    {
        $this->assertGreaterThanOrEqual(
            10,
            $this->countByActionNamespace('App\Http\Controllers\Merchant\\'),
            'Merchant panel routes (routes/merchant.php) are missing.'
        );
    }

    // ----- routes/agent.php ---------------------------------------------------

    public function test_agent_panel_routes_registered(): void
    {
        $this->assertGreaterThanOrEqual(
            10,
            $this->countByActionNamespace('App\Http\Controllers\Agent\\'),
            'Agent panel routes (routes/agent.php) are missing.'
        );
    }

    // ----- routes/api/*.php ---------------------------------------------------

    public function test_api_route_files_registered(): void
    {
        $this->assertGreaterThanOrEqual(50, $this->countByUriPrefix('api/'), 'routes/api/api.php not loaded.');
        $this->assertGreaterThanOrEqual(20, $this->countByUriPrefix('merchant-api/'), 'routes/api/merchant_api.php not loaded.');
        $this->assertGreaterThanOrEqual(30, $this->countByUriPrefix('agent-api/'), 'routes/api/agent_api.php not loaded.');

        $this->assertGreaterThanOrEqual(
            30,
            $this->countByActionNamespace('App\Http\Controllers\Api\\'),
            'API controller routes are missing.'
        );
    }
}
