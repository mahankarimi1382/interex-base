<?php

namespace App\Http\Middleware\Agent;

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
        $agent = auth()->user();
        if ($agent->email_verified == false) {
            return mailVerificationTemplateAgent($agent);
        }

        return $next($request);
    }
}
