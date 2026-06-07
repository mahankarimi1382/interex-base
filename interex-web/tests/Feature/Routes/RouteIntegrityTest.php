<?php

namespace Tests\Feature\Routes;

use Illuminate\Contracts\Http\Kernel as KernelContract;
use Illuminate\Routing\Route;
use Tests\TestCase;

/**
 * Whole-application route integrity checks.
 *
 * Instead of hand-listing every endpoint, these tests sweep the entire
 * registered route table and verify, for ALL routes (web + api), that:
 *   - each controller action points to a class/method that actually exists;
 *   - every middleware referenced by a route is a registered alias, a known
 *     middleware group, or an existing middleware class.
 *
 * This catches typos, renamed/removed controller methods and dangling
 * middleware references across every route file at once.
 */
class RouteIntegrityTest extends TestCase
{
    /**
     * Pre-existing routes that point at a controller method which does not
     * exist. Calling any of these endpoints fails at runtime — they are real
     * defects in the application, captured here as a baseline so that:
     *   - the suite stays green on the current code, and
     *   - any NEWLY broken route makes the test fail (regression guard), and
     *   - fixing one of these (so it is no longer broken) ALSO fails the test,
     *     forcing this list to be kept honest / trimmed.
     *
     * Each entry is "Controller@method". See the test report for the URIs.
     */
    private const KNOWN_BROKEN_ACTIONS = [
        'App\Http\Controllers\Api\User\TradeController@confirm',
        'App\Http\Controllers\Api\User\MarketplaceController@transactions',
        'App\Http\Controllers\Api\User\TradeOfferController@counterSubmit',
        'App\Http\Controllers\Api\Merchant\SecurityController@verifyGoogle2Fa',
        'App\Http\Controllers\User\PaymentLinkController@delete',
        'App\Http\Controllers\User\ChatController@chatFileUpload',
        'App\Http\Controllers\User\MarketplaceController@offerSubmit',
        'App\Http\Controllers\Merchant\PaymentLinkController@delete',
        'App\Http\Controllers\Agent\SenderRecipientController@checkUser',
        'App\Http\Controllers\Agent\ReceiverRecipientController@checkUser',
    ];

    /**
     * @return Route[]
     */
    private function allRoutes(): array
    {
        return $this->app['router']->getRoutes()->getRoutes();
    }

    public function test_route_table_is_not_empty(): void
    {
        $this->assertGreaterThan(
            100,
            count($this->allRoutes()),
            'The application route table looks suspiciously small; route files may have failed to load.'
        );
    }

    public function test_every_controller_action_targets_an_existing_method(): void
    {
        $brokenActions = [];
        $details = [];

        foreach ($this->allRoutes() as $route) {
            $action = $route->getActionName();

            // Closure-based routes have no controller to validate.
            if ($action === null || $action === 'Closure') {
                continue;
            }

            $signature = strtoupper(implode('|', $route->methods())).' '.$route->uri();

            if (str_contains($action, '@')) {
                [$class, $method] = explode('@', $action, 2);

                if (! class_exists($class)) {
                    $brokenActions[] = $action;
                    $details[$action] = "[{$signature}] controller class not found: {$class}";
                } elseif (! method_exists($class, $method)) {
                    $brokenActions[] = $action;
                    $details[$action] = "[{$signature}] missing action method: {$class}@{$method}";
                }

                continue;
            }

            // Invokable single-action controller.
            if (! class_exists($action)) {
                $brokenActions[] = $action;
                $details[$action] = "[{$signature}] invokable controller class not found: {$action}";
            } elseif (! method_exists($action, '__invoke')) {
                $brokenActions[] = $action;
                $details[$action] = "[{$signature}] invokable controller has no __invoke(): {$action}";
            }
        }

        $brokenActions = array_values(array_unique($brokenActions));

        $newlyBroken = array_diff($brokenActions, self::KNOWN_BROKEN_ACTIONS);
        $unexpectedlyFixed = array_diff(self::KNOWN_BROKEN_ACTIONS, $brokenActions);

        $this->assertSame(
            [],
            array_values($newlyBroken),
            "New routes point at a non-existent controller action:\n"
                .implode("\n", array_map(fn ($a) => $details[$a] ?? $a, $newlyBroken))
        );

        $this->assertSame(
            [],
            array_values($unexpectedlyFixed),
            "These actions are no longer broken — remove them from KNOWN_BROKEN_ACTIONS:\n"
                .implode("\n", $unexpectedlyFixed)
        );
    }

    public function test_every_route_middleware_is_resolvable(): void
    {
        $kernel = $this->app[KernelContract::class];

        $aliases = method_exists($kernel, 'getMiddlewareAliases')
            ? $kernel->getMiddlewareAliases()
            : $kernel->getRouteMiddleware();

        $known = array_merge(
            array_keys($aliases),
            array_keys($kernel->getMiddlewareGroups())
        );

        $errors = [];

        foreach ($this->allRoutes() as $route) {
            foreach ((array) $route->getAction('middleware') as $middleware) {
                // Closure middleware are valid but cannot be name-checked.
                if (! is_string($middleware)) {
                    continue;
                }

                // Strip parameters, e.g. "throttle:api" or "virtual_card_method:sudo".
                $name = explode(':', $middleware, 2)[0];

                if (in_array($name, $known, true) || class_exists($name)) {
                    continue;
                }

                $signature = strtoupper(implode('|', $route->methods())).' '.$route->uri();
                $errors[] = "[{$signature}] unknown middleware: {$middleware}";
            }
        }

        $this->assertSame(
            [],
            array_values(array_unique($errors)),
            "Found routes referencing unregistered middleware:\n".implode("\n", array_unique($errors))
        );
    }

    public function test_named_routes_can_be_resolved_to_a_url(): void
    {
        $errors = [];

        foreach ($this->allRoutes() as $route) {
            $name = $route->getName();

            if ($name === null) {
                continue;
            }

            try {
                // Fill any required parameters with a placeholder so URL
                // generation does not throw for parameterised routes.
                $parameters = collect($route->parameterNames())
                    ->mapWithKeys(fn ($param) => [$param => 1])
                    ->all();

                route($name, $parameters);
            } catch (\Throwable $e) {
                $errors[] = "[{$name}] could not generate URL: ".$e->getMessage();
            }
        }

        $this->assertSame(
            [],
            $errors,
            "Found named routes whose URL could not be generated:\n".implode("\n", $errors)
        );
    }
}
