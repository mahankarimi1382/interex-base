<?php

namespace App\Providers;

use App\Constants\ExtensionConst;
use App\Providers\Admin\ExtensionProvider;
use Carbon\Carbon;
use Illuminate\Pagination\Paginator;
use Illuminate\Support\Facades\Blade;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\ServiceProvider;

ini_set('memory_limit', '-1');
ini_set('serialize_precision', '-1');
class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Paginator::useBootstrapFive();
        Schema::defaultStringLength(191);
        if ($this->app->environment('production')) {
            \URL::forceScheme('https');
        }

        // register locale-aware Jalali (Shamsi) date helpers for Blade & Carbon
        $this->registerJalaliDates();

        // laravel extend validation rules
        $this->extendValidationRule();
    }

    /**
     * Register locale-aware Jalali date utilities.
     *
     * A @jdate(...) Blade directive and a Carbon ->jdate() macro that render
     * dates in the Jalali calendar when the locale is Persian ("fa") and fall
     * back to Gregorian otherwise.
     */
    public function registerJalaliDates()
    {
        Blade::directive('jdate', function ($expression) {
            return "<?php echo e(jdate($expression)); ?>";
        });

        Carbon::macro('jdate', function ($format = 'Y-m-d H:i:s', $persianNumbers = false) {
            /** @var Carbon $this */
            return jdate($this, $format, $persianNumbers);
        });
    }

    /**
     * extend laravel validation rules
     */
    public function extendValidationRule()
    {
        Validator::extend('g_recaptcha_verify', function ($attribute, $value, $parameters, $validator) {

            // logger("WORKING-CAPTCH");

            $extension = ExtensionProvider::get()->where('slug', ExtensionConst::GOOGLE_RECAPTCHA_SLUG)->first();
            if (! $extension) {
                return false;
            }
            $secret_key = $extension->shortcode->secret_key->value ?? '';

            $response = Http::asForm()->post('https://www.google.com/recaptcha/api/siteverify', [
                'secret' => $secret_key,
                'response' => $value,
            ])->json();
            if (isset($response['success']) && $response['success'] == false) {
                logger('google recaptcha verification failed!', [$response]);

                return false;
            }

            return true;

        }, ':message');
    }
}
