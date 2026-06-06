<?php

namespace App\Http\Middleware\Admin;

use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Validation\ValidationException;

class AppModeGuard
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response|RedirectResponse)  $next
     * @return Response|RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        if (in_array($request->method(), ['POST', 'PUT', 'DELETE'])) {
            $ignore_routes = ['logout'];

            $request_path = $request->path();
            $request_path = explode('?', $request_path);
            $request_path = array_shift($request_path);
            $request_path = explode('/', $request_path);
            $request_path = array_pop($request_path);

            if (! in_array($request_path, $ignore_routes)) {
                if (env('APP_MODE') != 'live') {
                    throw ValidationException::withMessages([
                        'unknown' => __("Can't change anything for demo application."),
                    ]);
                }
            }

        }

        return $next($request);
    }
}
