<?php

namespace App\Http\Middleware\Admin;

use App\Providers\Admin\BasicSettingsProvider;
use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class MailGuard
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response|RedirectResponse)  $next
     * @return Response|RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $basic_settings = BasicSettingsProvider::get();
        if ($basic_settings->mail_config == null) {
            return back()->withInput()->with(['warning' => [__('You have to configure your system mail first.')]]);
        }

        return $next($request);
    }
}
