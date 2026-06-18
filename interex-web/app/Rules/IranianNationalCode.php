<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

/**
 * Validates an Iranian National Code (کد ملی).
 *
 * Rules:
 *  - exactly 10 digits
 *  - not all identical digits (e.g. 0000000000)
 *  - the 10th digit must match the official check-digit algorithm
 */
class IranianNationalCode implements ValidationRule
{
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        $code = is_string($value) || is_numeric($value) ? (string) $value : '';
        // Allow Persian/Arabic digits by normalizing first.
        $code = $this->normalizeDigits($code);
        $code = trim($code);

        if (!preg_match('/^\d{10}$/', $code)) {
            $fail(__('The national code must be exactly 10 digits.'));
            return;
        }

        // Reject sequences of identical digits which pass the checksum but are invalid.
        if (preg_match('/^(\d)\1{9}$/', $code)) {
            $fail(__('The national code is invalid.'));
            return;
        }

        $sum = 0;
        for ($i = 0; $i < 9; $i++) {
            $sum += ((int) $code[$i]) * (10 - $i);
        }
        $remainder = $sum % 11;
        $check = (int) $code[9];

        $valid = ($remainder < 2) ? ($check === $remainder) : ($check === 11 - $remainder);

        if (!$valid) {
            $fail(__('The national code is invalid.'));
        }
    }

    /**
     * Convert Persian/Arabic digit characters to ASCII digits.
     */
    private function normalizeDigits(string $value): string
    {
        $persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
        $arabic  = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
        $english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

        return str_replace($arabic, $english, str_replace($persian, $english, $value));
    }
}
