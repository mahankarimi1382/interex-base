<?php

namespace Tests\Feature\Api;

use Illuminate\Routing\Route;
use Illuminate\Routing\RouteCollectionInterface;

/**
 * Shared helpers for asserting the correctness of API route definitions.
 *
 * These helpers inspect the registered route table (without sending real
 * HTTP requests) so that the route files can be validated even when no
 * database or external payment gateway is available in the test environment.
 */
trait ApiRouteTestHelpers
{
    /**
     * Find a registered route by HTTP method and exact URI.
     */
    protected function findRoute(string $method, string $uri): ?Route
    {
        /** @var RouteCollectionInterface $routes */
        $routes = $this->app['router']->getRoutes();

        foreach ($routes as $route) {
            if ($route->uri() === $uri && in_array(strtoupper($method), $route->methods(), true)) {
                return $route;
            }
        }

        return null;
    }

    /**
     * Assert a route exists for the given method/uri and (optionally) maps to
     * the expected "Controller@method" action and contains the expected
     * middleware.
     */
    protected function assertRoute(
        string $method,
        string $uri,
        ?string $action = null,
        array $middleware = []
    ): Route {
        $route = $this->findRoute($method, $uri);

        $this->assertNotNull(
            $route,
            "Expected route [{$method} {$uri}] to be registered, but it was not found."
        );

        if ($action !== null) {
            $this->assertSame(
                $action,
                $route->getActionName(),
                "Route [{$method} {$uri}] should map to [{$action}]."
            );
        }

        if ($middleware !== []) {
            // Use the route's own (group + route) middleware list instead of
            // gatherMiddleware(): the latter instantiates the controller to
            // collect controller middleware, which would trigger database
            // access in some controller constructors.
            $assigned = $this->routeMiddleware($route);
            foreach ($middleware as $expected) {
                $this->assertContains(
                    $expected,
                    $assigned,
                    "Route [{$method} {$uri}] should use middleware [{$expected}]."
                );
            }
        }

        return $route;
    }

    /**
     * Return the middleware assigned to a route via groups/route definitions
     * (without instantiating the controller).
     */
    protected function routeMiddleware(Route $route): array
    {
        return (array) ($route->getAction('middleware') ?? []);
    }

    /**
     * Assert that a route explicitly opts out of a middleware via
     * withoutMiddleware().
     */
    protected function assertRouteExcludesMiddleware(Route $route, string $middleware): void
    {
        $this->assertContains(
            $middleware,
            $route->excludedMiddleware(),
            "Route [{$route->uri()}] should exclude middleware [{$middleware}]."
        );
    }

    /**
     * Assert that NO route is registered for the given method/uri.
     */
    protected function assertRouteMissing(string $method, string $uri): void
    {
        $this->assertNull(
            $this->findRoute($method, $uri),
            "Expected route [{$method} {$uri}] to NOT be registered, but it exists."
        );
    }

    /**
     * Count how many registered routes start with the given URI prefix.
     */
    protected function countRoutesWithPrefix(string $prefix): int
    {
        $count = 0;

        foreach ($this->app['router']->getRoutes() as $route) {
            if (str_starts_with($route->uri(), $prefix)) {
                $count++;
            }
        }

        return $count;
    }
}
