<?php

namespace App\Http\Middleware\Admin;

use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;

class RoleGuard
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response|RedirectResponse)  $next
     * @return Response|RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        if (auth_has_no_role()) {
            Auth::logout();

            return back()->with(['error' => ['Sorry! You don\'t have permission to access admin dashboard.']]);
            exit;
        }
        $request_route = $request->route()->getName();

        if (auth_is_super_admin() === false) {

            if (! in_array($request_route, permission_skip()) && auth_admin_incomming_permission() === false) {
                abort(404);
            }
        }

        return $next($request);
    }
}
