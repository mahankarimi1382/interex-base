<?php

namespace Database\Seeders\Admin;

use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use App\Constants\PaymentGatewayConst;
use App\Models\Admin\PaymentGateway;
use App\Models\Admin\PaymentGatewayCurrency;

class AlipayplusGatewaySeeder extends Seeder
{
    /**
     * Seed the Alipay+ automatic add-money gateway (Sandbox by default).
     *
     * The gateway alias MUST be "alipayplus" so PaymentGatewayConst::register()
     * resolves it to the alipayPlusInit() trait method and the callback method
     * name "alipayplusCallbackResponse" is valid (no hyphen).
     *
     * Credential values are left blank — fill them from the Alipay+ developer
     * dashboard (Sandbox section) on the gateway edit page in admin.
     */
    public function run()
    {
        $alias = PaymentGatewayConst::ALIPAY_PLUS; // "alipayplus"

        $gateway = PaymentGateway::where('alias', $alias)
            ->where('slug', PaymentGatewayConst::add_money_slug())
            ->where('type', PaymentGatewayConst::AUTOMATIC)
            ->first();

        $credentials = [
            ['label' => 'Client ID',           'placeholder' => 'Enter Client ID',           'name' => 'client_id',           'value' => ''],
            ['label' => 'Gateway Domain',       'placeholder' => 'https://open-na.alipayplus.com', 'name' => 'gateway_domain', 'value' => 'https://open-na.alipayplus.com'],
            ['label' => 'Merchant Private Key', 'placeholder' => 'Enter Merchant RSA Private Key', 'name' => 'private_key',     'value' => ''],
            ['label' => 'Alipay Public Key',    'placeholder' => 'Enter Alipay+ Public Key',  'name' => 'public_key',          'value' => ''],
            ['label' => 'Key Version',          'placeholder' => 'Enter Key Version',         'name' => 'key_version',         'value' => '1'],
            ['label' => 'Test ACQ ID',          'placeholder' => 'Enter Acquirer ID',         'name' => 'acquirer_id',         'value' => ''],
            ['label' => 'Payment Method Type',  'placeholder' => 'e.g. CONNECT_WALLET',       'name' => 'payment_method_type', 'value' => 'CONNECT_WALLET'],
        ];

        if (!$gateway) {
            $code = (PaymentGateway::max('code') ?? 100);
            $code = function_exists('set_payment_gateway_code') ? set_payment_gateway_code($code) : $code + 1;

            $gateway = PaymentGateway::create([
                'name'                 => 'Alipayplus',
                'alias'                => $alias,
                'slug'                 => PaymentGatewayConst::add_money_slug(),
                'title'                => 'Alipay+',
                'type'                 => PaymentGatewayConst::AUTOMATIC,
                'code'                 => $code,
                'credentials'          => $credentials,
                'supported_currencies' => ['USD'],
                'env'                  => PaymentGatewayConst::ENV_SANDBOX,
                'crypto'               => 0,
                'status'               => 1,
                'last_edit_by'         => optional(\App\Models\Admin\Admin::first())->id ?? 1,
            ]);
        }

        // Gateway currency (USD = default currency, rate 1).
        PaymentGatewayCurrency::updateOrCreate(
            ['alias' => Str::slug('Alipayplus USD ' . PaymentGatewayConst::AUTOMATIC)],
            [
                'payment_gateway_id' => $gateway->id,
                'name'               => 'Alipayplus USD',
                'currency_code'      => 'USD',
                'currency_symbol'    => '$',
                'min_limit'          => 1,
                'max_limit'          => 100000,
                'percent_charge'     => 0,
                'fixed_charge'       => 0,
                'daily_limit'        => 0,
                'monthly_limit'      => 0,
                'rate'               => 1,
                'image'              => null,
            ]
        );
    }
}
