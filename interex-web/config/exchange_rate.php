<?php

return [

    /*
    |--------------------------------------------------------------------------
    | BrsApi (brsapi.ir) upstream source
    |--------------------------------------------------------------------------
    | The real, valid exchange-rate provider.
    | Endpoint: https://api.brsapi.ir/Market/Gold_Currency.php?key=...
    |
    | These are only fallbacks. The live values actually used come from the
    | CURRENCY-LAYER provider configured in the admin panel (value->base_url and
    | value->access_key), which is what BrsApi receives at call time.
    */
    'brsapi' => [
        'key'       => env('BRSAPI_KEY', 'Bu9w7hheMZiUl5mlfPBTNdIXsdylEmPG'),
        'url'       => env('BRSAPI_URL', 'https://api.brsapi.ir/Market/Gold_Currency.php'),
        'timeout'   => (int) env('BRSAPI_TIMEOUT', 20),
        // Cache the upstream payload for a few seconds so several calls in the
        // same minute don't each burn an upstream request. Keep < 60 so the
        // every-minute cron always gets a fresh value.
        'cache_ttl' => (int) env('BRSAPI_CACHE_TTL', 50),
    ],

    /*
    |--------------------------------------------------------------------------
    | Currency map (modular)
    |--------------------------------------------------------------------------
    | System currency code => how to read its price (in Toman) from BrsApi.
    |
    |   source: 'currency' | 'gold'  -> price is read from that BrsApi group
    |                                    (these are denominated in تومان / Toman).
    |           'constant'           -> fixed Toman value (use for IRR: 1 Rial = 0.1 Toman).
    |   symbol: the BrsApi "symbol" to look up inside that group.
    |   value : Toman value when source = 'constant'.
    |   name  : human label (used by the admin currency list).
    |
    | To add a new currency later, just add one line here.
    */
    'currencies' => [
        'USD'  => ['name' => 'US Dollar',    'source' => 'currency', 'symbol' => 'USD'],
        'USDT' => ['name' => 'Tether',       'source' => 'currency', 'symbol' => 'USDT_IRT'],
        'CNY'  => ['name' => 'Chinese Yuan', 'source' => 'currency', 'symbol' => 'CNY'],
        'IRR'  => ['name' => 'Iranian Rial', 'source' => 'constant', 'value'  => 0.1],
    ],

];
