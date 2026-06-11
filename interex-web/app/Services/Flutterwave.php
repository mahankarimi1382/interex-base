<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

/**
 * Lightweight Flutterwave v3 REST client.
 *
 * Drop-in replacement for the previously used kingflamez/laravelrave package
 * (KingFlamez\Rave\Facades\Rave). It exposes the same statically-called method
 * names and behaviour, reading the secret key from config('flutterwave.secretKey')
 * which is populated at runtime from the gateway credentials via
 * FlutterwaveTrait::flutterwaveSetSecreteKey().
 */
class Flutterwave
{
    /**
     * Flutterwave API base url.
     */
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
     * @return array
     */
    public static function initializePayment(array $data)
    {
        return Http::withToken(config('flutterwave.secretKey'))
            ->post(static::baseUrl() . '/payments', $data)
            ->json();
    }

    /**
     * Gets a transaction ID depending on the redirect structure.
     *
     * @return mixed
     */
    public static function getTransactionIDFromCallback()
    {
        $transactionID = request()->transaction_id;

        if (!$transactionID) {
            $transactionID = json_decode(request()->resp)->data->id;
        }

        return $transactionID;
    }

    /**
     * Reaches out to Flutterwave to verify a transaction.
     *
     * @return array
     */
    public static function verifyTransaction($id)
    {
        return Http::withToken(config('flutterwave.secretKey'))
            ->get(static::baseUrl() . '/transactions/' . $id . '/verify')
            ->json();
    }

    /**
     * Confirms webhook `verif-hash` matches the configured secret hash.
     */
    public static function verifyWebhook(): bool
    {
        if (request()->header('verif-hash')) {
            $flutterwaveSignature = request()->header('verif-hash');

            if ($flutterwaveSignature == config('flutterwave.secretHash')) {
                return true;
            }
        }

        return false;
    }
}
