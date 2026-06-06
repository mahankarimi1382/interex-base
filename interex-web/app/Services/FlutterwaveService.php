<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

/**
 * Lightweight, in-app replacement for the kingflamez/laravelrave package
 * (which has no Laravel 13 compatible release).
 *
 * It preserves the exact behavior of the previously used Rave facade methods:
 * credentials are still read from config('flutterwave.*') (set at runtime via
 * FlutterwaveTrait::flutterwaveSetSecreteKey) and all endpoints, payloads and
 * return shapes match the original package.
 */
class FlutterwaveService
{
    protected static function secretKey(): ?string
    {
        return config('flutterwave.secretKey');
    }

    protected static function baseUrl(): string
    {
        return 'https://api.flutterwave.com/v3';
    }

    /**
     * Generates a unique transaction reference.
     */
    public static function generateReference(?string $transactionPrefix = null): string
    {
        if ($transactionPrefix) {
            return $transactionPrefix . '_' . uniqid(time());
        }

        return 'flw_' . uniqid(time());
    }

    /**
     * Reaches out to Flutterwave to initialize a payment.
     *
     * @return array|mixed
     */
    public static function initializePayment(array $data)
    {
        return Http::withToken(static::secretKey())
            ->post(static::baseUrl() . '/payments', $data)
            ->json();
    }

    /**
     * Gets a transaction ID depending on the redirect structure.
     */
    public static function getTransactionIDFromCallback()
    {
        $transactionID = request()->transaction_id;

        if (! $transactionID) {
            $transactionID = json_decode(request()->resp)->data->id;
        }

        return $transactionID;
    }

    /**
     * Reaches out to Flutterwave to verify a transaction.
     *
     * @return array|mixed
     */
    public static function verifyTransaction($id)
    {
        return Http::withToken(static::secretKey())
            ->get(static::baseUrl() . '/transactions/' . $id . '/verify')
            ->json();
    }
}
