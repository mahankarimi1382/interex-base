<?php

namespace App\Http\Middleware\User;

use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class GoogleTwoFactor
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
            return googleTwoFactorVerificationTemplate($user);
        }

        return $next($request);
    }
}
