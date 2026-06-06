<?php

namespace App\Http\Middleware\Merchant;

use App\Models\Admin\BasicSettings;
use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class SMSVerificationGuard
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
        $basic_settings = BasicSettings::first();
        if ($basic_settings->merchant_sms_verification == true) {
            if ($user->sms_verified == false && $user->full_mobile != null) {
                return merchantSmsVerificationTemplate($user);
            }
        }

        return $next($request);
    }
}
