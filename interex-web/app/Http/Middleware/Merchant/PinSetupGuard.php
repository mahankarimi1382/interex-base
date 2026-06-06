<?php

namespace App\Http\Middleware\Merchant;

use App\Http\Helpers\Api\Helpers;
use App\Models\Admin\BasicSettings;
use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class PinSetupGuard
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response|RedirectResponse)  $next
     * @return Response|RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $basic_settings = BasicSettings::first();
        if ($basic_settings->merchant_pin_verification == true) {
            $user = authGuardApi()['user'];
            if ($user->pin_status == false) {
                if (authGuardApi()['guard'] == 'merchant_api') {
                    $message = ['error' => [__('Kindly complete your PIN setup before proceeding.')]];
                    $data = [
                        'pin_status' => $user->pin_status,
                    ];

                    return Helpers::error($message, $data);
                } else {
                    return redirect()->route('merchant.setup.pin.index')->with(['warning' => ['Kindly complete your PIN setup before proceeding.']]);
                }
            }
        }

        return $next($request);
    }
}
