<?php

namespace App\Mail\Transport;

use Symfony\Component\Mailer\SentMessage;
use Symfony\Component\Mailer\Transport\AbstractTransport;
use Symfony\Component\Mime\Email;
use Illuminate\Support\Facades\Http;
use Psr\Log\LoggerInterface;

class MailtrapTransport extends AbstractTransport
{
    protected $apiKey;
    protected $fromEmail;
    protected $fromName;

    public function __construct($apiKey, $fromEmail, $fromName, ?LoggerInterface $logger = null)
    {
        parent::__construct(null, $logger);
        $this->apiKey = $apiKey;
        $this->fromEmail = $fromEmail;
        $this->fromName = $fromName;
    }

    protected function doSend(SentMessage $message): void
    {
        $message = $message->getOriginalMessage();

        $to = [];
        foreach ($message->getTo() as $address) {
            $to[] = [
                'email' => $address->getAddress(),
                'name' => $address->getName() ?: $address->getAddress(),
            ];
        }

        $cc = [];
        foreach ($message->getCc() as $address) {
            $cc[] = [
                'email' => $address->getAddress(),
                'name' => $address->getName() ?: $address->getAddress(),
            ];
        }

        $bcc = [];
        foreach ($message->getBcc() as $address) {
            $bcc[] = [
                'email' => $address->getAddress(),
                'name' => $address->getName() ?: $address->getAddress(),
            ];
        }

        $payload = [
            'from' => [
                'email' => $this->fromEmail,
                'name' => $this->fromName,
            ],
            'to' => $to,
            'subject' => $message->getSubject(),
        ];

        if (!empty($cc)) {
            $payload['cc'] = $cc;
        }

        if (!empty($bcc)) {
            $payload['bcc'] = $bcc;
        }

        $textContent = '';
        $htmlContent = '';

        if ($message instanceof Email) {
            $textContent = $message->getTextBody() ?? '';
            $htmlContent = $message->getHtmlBody() ?? '';
        }

        if ($textContent) {
            $payload['text'] = $textContent;
        }
        if ($htmlContent) {
            $payload['html'] = $htmlContent;
        } elseif ($textContent) {
            $payload['html'] = '<p>' . nl2br($textContent) . '</p>';
        }

        $response = Http::withoutVerifying()->withHeaders([
            'Api-Token' => $this->apiKey,
            'Content-Type' => 'application/json',
        ])->post('https://send.api.mailtrap.io/api/send', $payload);

        if (!$response->successful()) {
            throw new \Exception('Mailtrap API Error: ' . $response->body());
        }
    }

    public function __toString(): string
    {
        return 'mailtrap';
    }
}
