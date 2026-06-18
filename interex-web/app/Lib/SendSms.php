<?php

namespace App\Lib;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Textmagic\Services\TextmagicRestClient;
use Twilio\Rest\Client;

class SendSms
{
	/**
	 * Send SMS through the Iranian SMS panel (sendSms_ManyToMany_v2).
	 * Credentials expected in sms_config: iran_sms_username, iran_sms_password,
	 * iran_sms_from and (optionally) iran_sms_url.
	 */
	public function iranSms($to, $fromName, $message, $credentials)
	{
		$url = $credentials->iran_sms_url ?? 'http://185.4.30.32/class/sms/restful/sendSms_ManyToMany_v2.php';

		// Normalize the receiver number to the local 09xxxxxxxxx format expected by the panel.
		// This is an Iranian SMS gateway, so every recipient is an Iranian mobile whose
		// national part is 10 digits (9xxxxxxxxx). Reduce any incoming format (+98, 0098,
		// 98, a wrong country-code prefix, or an already-local number) to the canonical
		// local form by keeping the last 10 national digits and prefixing a single 0.
		$digits = preg_replace('/\D/', '', (string) $to);
		$national = strlen($digits) >= 10 ? substr($digits, -10) : $digits;
		$to = '0' . $national;

		$payload = [
			'op'      => 'sendSms',
			'uname'   => $credentials->iran_sms_username,
			'pass'    => $credentials->iran_sms_password,
			'from'    => $credentials->iran_sms_from,
			'content' => [
				[
					'to'  => $to,
					'msg' => $message,
				],
			],
		];

		Log::info('iranSms: sending request', [
			'url'  => $url,
			'to'   => $to,
			'from' => $credentials->iran_sms_from,
			'msg'  => $message,
		]);

		try {
			$response = Http::asJson()->post($url, $payload);
			Log::info('iranSms: response received', [
				'status' => $response->status(),
				'body'   => $response->body(),
			]);
			return $response->body();
		} catch (\Throwable $e) {
			Log::error('iranSms: request failed', [
				'message' => $e->getMessage(),
			]);
			throw $e;
		}
	}

	public function nexmo($to,$fromName = 'admin',$message,$credentials){

		$basic  = new \Vonage\Client\Credentials\Basic($credentials->nexmo_api_key, $credentials->nexmo_api_secret);
		$client = new \Vonage\Client($basic);
		$response = $client->sms()->send(
            new \Vonage\SMS\Message\SMS($to, $fromName, $message)
        );
		$message = $response->current();
	}
	public function twilio($to,$fromName,$message,$credentials){

		$account_sid = $credentials->account_sid;
		$auth_token = $credentials->auth_token;
		$twilio_number = $credentials->from;

		$client = new Client($account_sid, $auth_token);
		$client->messages->create(
		    '+'.$to,
		    array(
		        'from' => $twilio_number,
		        'body' => $message
		    )
		);
	}

	// public function textMagic($to,$fromName,$message,$credentials){
	// 	$client = new TextmagicRestClient($credentials->text_magic_username, $credentials->apiv2_key);
	//     $result = $client->messages->create(
	//         array(
	//             'text' => $message,
	//             'phones' => $to
	//         )
	//     );
	// }

}
