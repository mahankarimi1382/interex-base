<?php

namespace App\Http\Middleware\Merchant;

use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class VerificationGuard
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response|RedirectResponse)  $next
     * @return Response|RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $merchant = auth()->user();
        if ($merchant->email_verified == false) {
            return mailVerificationTemplateMerchant($merchant);
        }

        return $next($request);
    }
}
