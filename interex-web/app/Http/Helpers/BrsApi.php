<?php

namespace App\Http\Helpers;

use Exception;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;

/**
 * BrsApi
 * -------
 * Thin, modular wrapper around brsapi.ir (Gold_Currency.php).
 *
 * It converts the upstream payload into USD-based exchange quotes, in the exact
 * shape the existing CurrencyLayer helper already understands, so the rest of
 * the application keeps working untouched.
 *
 * All fiat/gold prices from BrsApi are denominated in تومان (Toman). We build a
 * single "Toman price per 1 unit" index for every currency configured in
 * config/exchange_rate.php and derive cross rates from it:
 *
 *      1 SOURCE = ( tomanPerUnit[SOURCE] / tomanPerUnit[TARGET] ) TARGET
 */
class BrsApi
{
    protected array $config;

    /**
     * @param string|null $url  Override the BrsApi base URL (e.g. value coming from the admin panel).
     * @param string|null $key  Override the BrsApi access key (e.g. value coming from the admin panel).
     */
    public function __construct(?string $url = null, ?string $key = null)
    {
        $this->config = config('exchange_rate');

        if (! empty($url)) {
            $this->config['brsapi']['url'] = $url;
        }
        if (! empty($key)) {
            $this->config['brsapi']['key'] = $key;
        }
    }

    /**
     * Fetch the raw BrsApi payload (briefly cached to protect the upstream quota).
     */
    public function fetchRaw(): array
    {
        $ttl = (int) ($this->config['brsapi']['cache_ttl'] ?? 50);

        return Cache::remember('brsapi_gold_currency', $ttl, function () {
            $response = Http::timeout((int) ($this->config['brsapi']['timeout'] ?? 20))
                ->get($this->config['brsapi']['url'], [
                    'key' => $this->config['brsapi']['key'],
                ]);

            if (! $response->ok()) {
                throw new Exception('BrsApi request failed with HTTP status ' . $response->status());
            }

            $json = $response->json();
            if (! is_array($json) || ! isset($json['currency'])) {
                throw new Exception('BrsApi returned an unexpected payload');
            }

            return $json;
        });
    }

    /**
     * Build "Toman price per 1 unit" for every currency in the config map.
     *
     * @return array<string,float> e.g. ['USD'=>155995, 'USDT'=>158172, 'CNY'=>23090, 'IRR'=>0.1]
     */
    public function tomanPriceIndex(): array
    {
        $raw = $this->fetchRaw();

        // Index upstream items by symbol within each group.
        $bySymbol = [];
        foreach (['currency', 'gold'] as $group) {
            foreach ($raw[$group] ?? [] as $item) {
                if (isset($item['symbol'])) {
                    $bySymbol[$group][$item['symbol']] = $item;
                }
            }
        }

        $index = [];
        foreach (($this->config['currencies'] ?? []) as $code => $rule) {
            $source = $rule['source'] ?? 'currency';

            if ($source === 'constant') {
                $index[$code] = (float) ($rule['value'] ?? 0);
                continue;
            }

            $symbol = $rule['symbol'] ?? $code;
            $item = $bySymbol[$source][$symbol] ?? null;
            if ($item === null) {
                continue; // symbol not present upstream; skip rather than poison the map
            }

            $price = (float) str_replace(',', '', (string) ($item['price'] ?? 0));
            if ($price > 0) {
                $index[$code] = $price; // already Toman for 'currency'/'gold'
            }
        }

        return $index;
    }

    /**
     * CurrencyLayer-style quotes keyed as SOURCE.TARGET (e.g. "USDIRR").
     *
     * @return array<string,float>
     */
    public function quotes(string $source = 'USD'): array
    {
        $index  = $this->tomanPriceIndex();
        $source = strtoupper($source);

        if (! isset($index[$source]) || $index[$source] <= 0) {
            throw new Exception("Base currency [{$source}] is not available from BrsApi");
        }

        $sourceToman = $index[$source];
        $quotes = [];
        foreach ($index as $code => $toman) {
            if ($toman <= 0) {
                continue;
            }
            $quotes[$source . $code] = $sourceToman / $toman;
        }

        return $quotes;
    }

    /**
     * Supported currencies for the /list endpoint: ['USD' => 'US Dollar', ...].
     *
     * @return array<string,string>
     */
    public function supportedCurrencies(): array
    {
        $out = [];
        foreach (($this->config['currencies'] ?? []) as $code => $rule) {
            $out[$code] = $rule['name'] ?? $code;
        }

        return $out;
    }
}
