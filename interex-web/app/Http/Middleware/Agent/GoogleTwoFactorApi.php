<?php

namespace App\Http\Middleware\Agent;

use App\Http\Helpers\Api\Helpers;
use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class GoogleTwoFactorApi
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response|RedirectResponse)  $next
     * @return Response|RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $user = auth()->user();
        if ($user->two_factor_status && $user->two_factor_verified == false) {
            $error = ['errors' => [__('2fa verification is required')]];

            return Helpers::error($error);
        }

        return $next($request);
    }
}
