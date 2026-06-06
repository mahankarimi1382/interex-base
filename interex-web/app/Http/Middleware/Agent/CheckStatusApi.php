<?php

namespace App\Http\Middleware\Agent;

use App\Http\Helpers\Api\Helpers;
use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;

class CheckStatusApi
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
        if ((Auth::user()->email_verified == 1) &&
         (Auth::user()->sms_verified == 1) &&
         (Auth::user()->status == 1)
        ) {
            return $next($request);
        } else {
            if (Auth::user()->status == 0) {
                $error = ['errors' => [__('Account Is Deactivated')]];

                return Helpers::error($error);
            } elseif ($user->email_verified == 0) {
                return agentMailVerificationTemplateApi($user);
            } elseif ($user->sms_verified == 0) {
                $error = ['errors' => [__('Sms verification is required')]];

                return Helpers::error($error);
            }
        }
    }
}
