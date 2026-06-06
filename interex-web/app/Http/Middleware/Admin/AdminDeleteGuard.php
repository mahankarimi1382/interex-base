<?php

namespace App\Http\Middleware\Admin;

use App\Constants\AdminRoleConst;
use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class AdminDeleteGuard
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response|RedirectResponse)  $next
     * @return Response|RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $request->validate([
            'target' => 'required|string|exists:admins,username',
        ]);
        $admin = get_admin($request->target);
        $roles = $admin->getRolesCollection();

        if (in_array(AdminRoleConst::SUPER_ADMIN, $roles)) {
            return back()->with(['warning' => [__("Can't deletable system super admin")]]);
        } elseif ($admin->username == auth()->user()->username) {
            return back()->with(['warning' => [__("Can't delete account by yourself.")]]);
        }

        return $next($request);
    }
}
