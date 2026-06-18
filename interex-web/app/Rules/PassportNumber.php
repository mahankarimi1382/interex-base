<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

/**
 * Validates an international passport number.
 *
 * Most passports are 6 to 9 alphanumeric characters (letters + digits).
 */
class PassportNumber implements ValidationRule
{
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        $passport = is_string($value) ? trim($value) : '';

        if (!preg_match('/^[A-Za-z0-9]{6,9}$/', $passport)) {
            $fail(__('The passport number is invalid. It must be 6 to 9 letters or digits.'));
        }
    }
}
