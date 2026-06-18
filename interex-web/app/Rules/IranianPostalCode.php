<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

/**
 * Validates an Iranian Postal Code (کد پستی).
 *
 * Iran postal codes are exactly 10 digits with structural constraints:
 *  - no run of 4 identical digits at the start
 *  - first 4 digits from [1,3-9] (0 and 2 are not used)
 *  - the 5th digit from [1,3,4,6-9]
 *  - the remaining 5 digits from [0,1,3-9]
 */
class IranianPostalCode implements ValidationRule
{
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        $code = is_string($value) || is_numeric($value) ? (string) $value : '';
        $code = trim($this->normalizeDigits($code));

        if (!preg_match('/^\d{10}$/', $code)) {
            $fail(__('The postal code must be exactly 10 digits.'));
            return;
        }

        if (!preg_match('/^(?!(\d)\1{3})[13-9]{4}[1346-9][013-9]{5}$/', $code)) {
            $fail(__('The postal code is invalid.'));
        }
    }

    private function normalizeDigits(string $value): string
    {
        $persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
        $arabic  = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
        $english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

        return str_replace($arabic, $english, str_replace($persian, $english, $value));
    }
}
