<?php

namespace App\Http\Middleware;

use App\Models\Admin\Language;
use Closure;
use Illuminate\Http\Request;

class LanguageMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  Request  $request
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        session()->put('lang', $this->getCode());
        app()->setLocale(session('lang', $this->getCode()));

        return $next($request);
    }

    public function getCode()
    {
        if (session()->has('lang')) {
            return session('lang');
        }
        $language = Language::where('status', 1)->first();

        return $language ? $language->code : 'en';
    }
}
