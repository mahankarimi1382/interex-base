<?php

namespace Database\Factories\Admin;

use App\Models\Admin\Currency;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Currency>
 */
class CurrencyFactory extends Factory
{
    protected $model = Currency::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition()
    {
        return [
            'country' => $this->faker->country,
            'name' => '-',
            'code' => $this->faker->currencyCode(),
            'symbol' => '-',
            'admin_id' => 1,
            'type' => 'FIAT',
            'rate' => 1.00,
        ];
    }
}
