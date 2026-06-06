<?php

namespace App\Http\Middleware\Admin;

use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class PageSetup
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response|RedirectResponse)  $next
     * @return Response|RedirectResponse
     */
    public function handle(Request $request, Closure $next, $access)
    {
        $permission = page_access($access);
        if ($permission == false) {
            abort(404);
        }

        return $next($request);
    }
}
