<?php

namespace App\Http\Middleware\Api;

use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\App;

class HandleLocalization
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response|RedirectResponse)  $next
     * @return Response|RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        if (request()->get('lang')) {
            App::setLocale(request()->get('lang'));
        }

        return $next($request);
    }
}
