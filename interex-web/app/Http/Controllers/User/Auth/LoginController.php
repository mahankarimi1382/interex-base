<?php

namespace App\Http\Controllers\User\Auth;

use App\Constants\ExtensionConst;
use App\Http\Controllers\Controller;
use App\Providers\Admin\ExtensionProvider;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Auth;
use App\Traits\User\LoggedInUsers;


class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    protected $request_data;

    use AuthenticatesUsers, LoggedInUsers;

    public function showLoginForm() {
        $page_title =__("User Login");
        return view('user.auth.login',compact(
            'page_title',
        ));
    }


    /**
     * Validate the user login request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return void
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    protected function validateLogin(Request $request)
    {
        if($request->login_type == global_const()::PHONE){
            $mobile_code = 'required';
        }else{
            $mobile_code = 'nullable';
        }
        $this->request_data = $request;

        $extension = ExtensionProvider::get()->where('slug', ExtensionConst::GOOGLE_RECAPTCHA_SLUG)->first();
        $captcha_rules = "nullable";
        if($extension && $extension->status == true) {
            $captcha_rules = 'required|string|g_recaptcha_verify';
        }
        $request->validate([
            'login_type' => 'required|in:'.global_const()::PHONE.','.global_const()::EMAIL,
            'credentials' => ['required', function ($attribute, $value, $fail) use ($request) {
                if ($request->type == global_const()::PHONE && !preg_match('/^0?[0-9]{9,14}$/', $value)) {
                    $fail('The ' . $attribute . ' must be a valid phone number.');
                }
                if ($request->login_type == global_const()::EMAIL && !filter_var($value, FILTER_VALIDATE_EMAIL)) {
                    $fail('The ' . $attribute . ' must be a valid email address.');
                }
            }],
            'mobile_code'           =>  $mobile_code,
            'password'      => 'required|string|min:6',
            'g-recaptcha-response'  => $captcha_rules
        ]);
    }


    /**
     * Get the needed authorization credentials from the request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    protected function credentials(Request $request)
    {
        if($request->login_type == global_const()::PHONE){
            $mobile_code = remove_special_char($request->mobile_code);
            $raw_mobile  = $request->mobile_code == '880' ? (int)$request->credentials :  $request->credentials;
            // Normalize the national number (drop any leading zero, e.g. 0919... -> 919...).
            $national    = ltrim((string) $raw_mobile, '0');
            $full_mobile = $mobile_code.$national;

            // Tolerant resolve: find the stored account by the fully-qualified number or by the
            // national mobile number, then authenticate against its actual full_mobile. This keeps
            // password verification intact while avoiding false "credentials don't match" errors
            // caused by country-code / leading-zero formatting differences.
            $user = \App\Models\User::where('full_mobile', $full_mobile)
                        ->orWhere('full_mobile', $mobile_code.'0'.$national)
                        ->orWhere('mobile', $national)
                        ->orWhere('mobile', '0'.$national)
                        ->first();
            $credentials = $user->full_mobile ?? $full_mobile;
        }else{
            $credentials = $request->credentials;
        }
        $request->merge(['status' => true]);
        $request->merge([$this->username() =>  $credentials]);
        return $request->only($this->username(), 'password','status');

    }


    /**
     * Get the login username to be used by the controller.
     *
     * @return string
     */
    public function username()
    {
        $request = $this->request_data->all();
        $credentials = $request['credentials'];
        if(filter_var($credentials,FILTER_VALIDATE_EMAIL)) {
            return "email";
        }
        return "full_mobile";
    }

    /**
     * Get the failed login response instance.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Symfony\Component\HttpFoundation\Response
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    protected function sendFailedLoginResponse(Request $request)
    {
        throw ValidationException::withMessages([
            "credentials" => [trans('auth.failed')],
        ]);
    }


    /**
     * Get the guard to be used during authentication.
     *
     * @return \Illuminate\Contracts\Auth\StatefulGuard
     */
    protected function guard()
    {
        return Auth::guard("web");
    }


    /**
     * The user has been authenticated.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  mixed  $user
     * @return mixed
     */
    protected function authenticated(Request $request, $user)
    {
        $user->update([
            'two_factor_verified'   => false,
        ]);
        $user->createQr();
        $this->refreshUserWallets($user);
        $this->createLoginLog($user);
        return redirect()->intended(route('user.dashboard'));
    }
}
