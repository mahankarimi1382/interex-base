<?php

namespace App\Http\Resources\Agent;

use Illuminate\Contracts\Support\Arrayable;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AgentProfitLogs extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  Request  $request
     * @return array|Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'trx' => $this->transactions->trx_id,
            'transaction_type' => $this->transactions->type,
            'profit_amount' => get_amount($this->total_charge, $this->transactions->creator_wallet->currency->code, get_wallet_precision($this->transactions->creator_wallet->currency)),
            'created_at' => $this->created_at,
        ];
    }
}
