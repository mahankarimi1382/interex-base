<?php

namespace App\Http\Middleware\Merchant;

use App\Http\Helpers\Api\Helpers;
use Closure;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Auth\Middleware\Authenticate;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\UnauthorizedException;

class ApiAuthenticator extends Authenticate
{
    /**
     * Determine if the user is authenticated and authorized to access the requested resource.
     *
     * @param  Request  $request
     * @return void
     *
     * @throws AuthenticationException
     * @throws UnauthorizedException
     */
    protected function authenticate($request, array $guards)
    {
        if ($this->auth->guard('merchant_api')->check()) {
            return $this->auth->shouldUse('merchant_api');
        }

        throw new UnauthorizedException('sorry');
    }

    /**
     * Handle an unauthenticated user.
     *
     * @param  Request  $request
     * @param  array  $guards
     * @return JsonResponse
     *
     * @throws UnauthorizedException
     */
    public function handle($request, Closure $next, ...$guards)
    {
        try {
            $this->authenticate($request, $guards);
        } catch (UnauthorizedException $e) {
            $message = ['error' => [__('Sorry, You are unauthorized merchant user')]];

            return Helpers::unauthorized($data = null, $message);
        }

        return $next($request);
    }
}
