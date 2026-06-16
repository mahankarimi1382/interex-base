<?php

namespace App\Http\Helpers;

use App\Models\LiveExchangeRateApiSetting;
use Exception;
use Illuminate\Http\Client\RequestException;
use Illuminate\Http\Client\Response;
use Illuminate\Support\Facades\Http;
use App\Http\Helpers\BrsApi;

class CurrencyLayer{

    /**
     * Active API
     */
    public $api;

    /**
     * Store access token
     */
    protected $access_token;

    /**
     * store configuration
     */
    protected array $config;


    public function __construct()
    {
        $this->api = LiveExchangeRateApiSetting::active()->first();
        $this->setConfig();
    }
    /**
     * Set configuration
     */
    public function setConfig()
    {
        $api = $this->api;

        if(!$api) throw new Exception("Exchange Rate Provider Not Found!");

        $config['access_key']       = $api->value?->access_key;
        $config['request_url']      = $api->value?->base_url;
        $config['multiply_by']      = $api->multiply_by;

        $this->config = $config;

        return $this;
    }
    /**
     * Retrieve live exchange rates.
     *
     * Backed by brsapi.ir. The base URL + access key are taken from the provider
     * configured in the admin panel (value->base_url, value->access_key), e.g.
     *   base_url:    https://api.brsapi.ir/Market/Gold_Currency.php
     *   access_key:  <brsapi key>
     * The brsapi payload is transformed into the same {code => rate} shape the
     * rest of the application already consumes (base = default currency / USD).
     */
    public function getLiveExchangeRates()
    {
        if(!$this->config) $this->setConfig();

        $admin_addition_rate = $this->config['multiply_by'] ?? 1;
        $source = get_default_currency_code() ?: 'USD';

        try{
            $brs = new BrsApi($this->config['request_url'] ?? null, $this->config['access_key'] ?? null);
            $quotes = $brs->quotes($source); // ['USDUSD'=>1,'USDIRR'=>...,'USDUSDT'=>...,'USDCNY'=>...]
        }catch(\Throwable $e){
            return [
                'status'    => false,
                'message'   => $e->getMessage() ?: 'something went wrong in brsapi',
                'data'      => [],
            ];
        }

        $formattedQuotes = [];
        foreach ($quotes as $currency => $value) {
            $formattedValue = get_amount(($value * $admin_addition_rate), null, 12);
            if (strpos($currency, $source) === 0) {
                $currency = substr($currency, strlen($source)); // strip source prefix -> target code
            }
            $formattedQuotes[$currency] = $formattedValue;
        }

        return [
            'status'    => true,
            'message'   => "Successfully Get Exchange Rate",
            'data'      => $formattedQuotes,
        ];
    }
    public function apiCurrencyList()
    {
        if(!$this->config) $this->setConfig();

        try{
            $brs = new BrsApi($this->config['request_url'] ?? null, $this->config['access_key'] ?? null);
            $currencies = $brs->supportedCurrencies();
        }catch(\Throwable $e){
            return [
                'status'    => false,
                'message'   => $e->getMessage() ?: 'something went wrong in brsapi',
                'data'      => [],
            ];
        }

        return [
            'status'    => true,
            'message'   => "Successfully Get All Currency List",
            'data'      => $currencies,
        ];
    }

}
