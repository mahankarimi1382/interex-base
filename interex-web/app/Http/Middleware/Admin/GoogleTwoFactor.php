<?php

namespace App\Http\Middleware\Admin;

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
            return redirect()->route('admin.authorize.google.2fa')->with(['warning' => [__('Please Verify 2FA Authentication')]]);
        }

        return $next($request);
    }
}
