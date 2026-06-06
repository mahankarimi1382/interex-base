<?php

namespace App\Http\Middleware\Admin;

use App\Constants\AdminRoleConst;
use App\Models\Admin\AdminRole;
use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class RoleDeleteGuard
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
            'target' => 'required|numeric',
        ]);

        $role = AdminRole::find($request->target);
        if (! $role) {
            return back()->with(['error' => [__('Target role not found!')]]);
        }
        if ($role->name == AdminRoleConst::SUPER_ADMIN) {
            return back()->with(['error' => [__("Super admin role can't deletable.")]]);
        }

        return $next($request);
    }
}
