<?php

use Carbon\Carbon;
use Hekmatinasser\Verta\Verta;

/*
|--------------------------------------------------------------------------
| Jalali (Shamsi) date helpers
|--------------------------------------------------------------------------
|
| These helpers render dates in the Jalali calendar ONLY when the active
| application locale is Persian ("fa"); otherwise they fall back to the
| regular Gregorian output, so non-Persian deployments are unaffected.
|
*/

if (! function_exists('is_jalali')) {
    /**
     * Whether the current locale should use the Jalali calendar.
     */
    function is_jalali(): bool
    {
        return app()->getLocale() === 'fa';
    }
}

if (! function_exists('to_carbon')) {
    /**
     * Safely turn a mixed date value into a Carbon instance (or null).
     *
     * @param  mixed  $date
     */
    function to_carbon($date): ?Carbon
    {
        if ($date === null || $date === '') {
            return null;
        }

        if ($date instanceof DateTimeInterface) {
            return Carbon::instance($date);
        }

        try {
            return Carbon::parse($date);
        } catch (\Throwable $e) {
            $timestamp = is_numeric($date) ? (int) $date : strtotime((string) $date);

            return $timestamp ? Carbon::createFromTimestamp($timestamp) : null;
        }
    }
}

if (! function_exists('jdate')) {
    /**
     * Locale-aware date formatter.
     *
     * When the locale is "fa" the date is rendered in the Jalali calendar,
     * otherwise the regular Gregorian representation is returned. The format
     * uses the same tokens as PHP's date()/Carbon's format().
     *
     * @param  mixed  $date
     */
    function jdate($date = null, string $format = 'Y-m-d H:i:s', bool $persianNumbers = false): string
    {
        $carbon = $date === null ? Carbon::now() : to_carbon($date);

        if ($carbon === null) {
            return '';
        }

        if (! is_jalali()) {
            return $carbon->format($format);
        }

        $output = Verta::instance($carbon)->format($format);

        return $persianNumbers ? en_to_fa_numbers($output) : $output;
    }
}

if (! function_exists('en_to_fa_numbers')) {
    /**
     * Convert latin digits in a string to Persian digits.
     */
    function en_to_fa_numbers(string $string): string
    {
        return str_replace(
            ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
            ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'],
            $string
        );
    }
}

if (! function_exists('to_gregorian')) {
    /**
     * Convert a Jalali date string (e.g. coming from a Jalali date picker)
     * back to a Gregorian "Y-m-d" string for storage. If the value is not a
     * valid Jalali date it is returned unchanged so existing flows keep working.
     *
     * @param  mixed  $jalaliDate
     */
    function to_gregorian($jalaliDate, string $format = 'Y-m-d'): ?string
    {
        if ($jalaliDate === null || $jalaliDate === '') {
            return null;
        }

        // Normalise Persian/Arabic digits to latin first.
        $normalized = strtr((string) $jalaliDate, [
            '۰' => '0', '۱' => '1', '۲' => '2', '۳' => '3', '۴' => '4',
            '۵' => '5', '۶' => '6', '۷' => '7', '۸' => '8', '۹' => '9',
            '٠' => '0', '١' => '1', '٢' => '2', '٣' => '3', '٤' => '4',
            '٥' => '5', '٦' => '6', '٧' => '7', '٨' => '8', '٩' => '9',
        ]);

        if (preg_match('/^(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})/', $normalized, $m)) {
            try {
                return Verta::createJalali((int) $m[1], (int) $m[2], (int) $m[3], 0, 0, 0)
                    ->datetime()
                    ->format($format);
            } catch (\Throwable $e) {
                return $normalized;
            }
        }

        return $normalized;
    }
}
