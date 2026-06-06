<?php

namespace Database\Seeders\User;

use App\Models\Trade;
use App\Models\Transaction;
use Illuminate\Database\Seeder;

class TradeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {

        $trades = [
            ['id' => '6', 'user_id' => '1', 'currency_id' => '2', 'amount' => '50.0000000000000000', 'rate' => '40.0000000000000000', 'rate_currency_id' => '3', 'comment' => null, 'status' => '1', 'created_at' => '2025-03-25 22:51:47', 'updated_at' => '2025-03-25 22:57:17'],
            ['id' => '7', 'user_id' => '1', 'currency_id' => '5', 'amount' => '60.0000000000000000', 'rate' => '70.0000000000000000', 'rate_currency_id' => '4', 'comment' => null, 'status' => '1', 'created_at' => '2025-03-25 22:59:57', 'updated_at' => '2025-03-25 23:01:02'],
        ];

        Trade::insert($trades);

        $transactions = [
            ['id' => '29', 'admin_id' => null, 'user_id' => '1', 'user_wallet_id' => '2', 'merchant_id' => null, 'merchant_wallet_id' => null, 'agent_id' => null, 'agent_wallet_id' => null, 'sandbox_wallet_id' => null, 'payment_gateway_currency_id' => null, 'payment_link_id' => null, 'trade_id' => '6', 'type' => 'TRADE', 'trx_id' => 'MT62898379', 'request_amount' => '50.00000000', 'payable' => '50.00000000', 'available_balance' => '813.73733800', 'remark' => 'TRADE', 'details' => '"Balance Payment"', 'reject_reason' => null, 'status' => '1', 'attribute' => 'SEND', 'created_at' => '2025-03-25 22:51:47', 'updated_at' => null, 'callback_ref' => null],
            ['id' => '32', 'admin_id' => null, 'user_id' => '1', 'user_wallet_id' => '5', 'merchant_id' => null, 'merchant_wallet_id' => null, 'agent_id' => null, 'agent_wallet_id' => null, 'sandbox_wallet_id' => null, 'payment_gateway_currency_id' => null, 'payment_link_id' => null, 'trade_id' => '7', 'type' => 'TRADE', 'trx_id' => 'MT65294444', 'request_amount' => '60.00000000', 'payable' => '60.00000000', 'available_balance' => '879.02620750', 'remark' => 'TRADE', 'details' => '"Balance Payment"', 'reject_reason' => null, 'status' => '1', 'attribute' => 'SEND', 'created_at' => '2025-03-25 22:59:57', 'updated_at' => null, 'callback_ref' => null],
        ];

        Transaction::insert($transactions);
    }
}
