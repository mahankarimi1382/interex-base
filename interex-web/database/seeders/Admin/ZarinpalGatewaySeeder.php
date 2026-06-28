<?php

namespace Database\Seeders\Admin;

use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use App\Constants\PaymentGatewayConst;
use App\Models\Admin\PaymentGateway;
use App\Models\Admin\PaymentGatewayCurrency;

class ZarinpalGatewaySeeder extends Seeder
{
    /**
     * Seed the Zarinpal automatic add-money gateway (Sandbox by default).
     *
     * The gateway alias MUST be "zarinpal" so PaymentGatewayConst::register()
     * resolves it to the zarinpalInit() trait method.
     */
    public function run()
    {
        $alias = PaymentGatewayConst::ZARINPAL; // "zarinpal"

        $gateway = PaymentGateway::where('alias', $alias)
            ->where('slug', PaymentGatewayConst::add_money_slug())
            ->where('type', PaymentGatewayConst::AUTOMATIC)
            ->first();

        $credentials = [
            [
                'label'       => 'Merchant ID',
                'placeholder' => 'Enter Merchant ID',
                'name'        => 'merchant_id',
                'value'       => '11111111-1111-1111-1111-111111111111', // sandbox dummy merchant id
            ],
        ];

        if (!$gateway) {
            $code = (PaymentGateway::max('code') ?? 100);
            $code = function_exists('set_payment_gateway_code') ? set_payment_gateway_code($code) : $code + 1;

            $gateway = PaymentGateway::create([
                'name'                 => 'Zarinpal',
                'alias'                => $alias,
                'slug'                 => PaymentGatewayConst::add_money_slug(),
                'title'                => 'Zarinpal',
                'type'                 => PaymentGatewayConst::AUTOMATIC,
                'code'                 => $code,
                'credentials'          => $credentials,
                'supported_currencies' => ['IRR'],
                'env'                  => PaymentGatewayConst::ENV_SANDBOX,
                'crypto'               => 0,
                'status'               => 1,
                'last_edit_by'         => optional(\App\Models\Admin\Admin::first())->id ?? 1,
            ]);
        }

        // Gateway currency (Iranian Rial). Rate matches the IRR currency rate so
        // the amount sent to Zarinpal is correctly converted into Rial.
        PaymentGatewayCurrency::updateOrCreate(
            ['alias' => Str::slug('Zarinpal IRR ' . PaymentGatewayConst::AUTOMATIC)],
            [
                'payment_gateway_id' => $gateway->id,
                'name'               => 'Zarinpal IRR',
                'currency_code'      => 'IRR',
                'currency_symbol'    => 'ریال',
                'min_limit'          => 10000,          // 1,000 Toman
                'max_limit'          => 1000000000,     // 100,000,000 Toman
                'percent_charge'     => 0,
                'fixed_charge'       => 0,
                'daily_limit'        => 0,
                'monthly_limit'      => 0,
                'rate'               => 1554850,        // 1 IRR-currency unit -> default currency rate
                'image'              => null,
            ]
        );
    }
}
