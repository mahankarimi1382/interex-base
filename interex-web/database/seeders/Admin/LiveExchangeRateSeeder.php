<?php

namespace Database\Seeders\Admin;

use App\Models\LiveExchangeRateApiSetting;
use Illuminate\Database\Seeder;

class LiveExchangeRateSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {

        // Default to brsapi.ir (real free-market rates). These values are also
        // editable from the admin panel (Setup Live Exchange Rate API).
        $value = json_encode([
            'access_key'  => config('exchange_rate.brsapi.key', ''),
            'base_url'    => config('exchange_rate.brsapi.url', 'https://api.brsapi.ir/Market/Gold_Currency.php'),
            'multiply_by' => '1',
        ]);

        $live_exchange_rate_api_settings = array(
            array('slug' => 'CURRENCY-LAYER','provider' => 'Currency Layer','value' => $value,'multiply_by' => '1.00000000','currency_module' => '1','payment_gateway_module' => '1','status' => '1','created_at' => now(),'updated_at' => now())
        );

        LiveExchangeRateApiSetting::insert($live_exchange_rate_api_settings);
    }
}
