import 'package:qrpay/extentions/custom_extentions.dart';

class ApiEndpoint {
  static const String host = "api.habel.ir";
  static const String mainDomain = "https://$host";
  static const String baseUrl = "$mainDomain/agent-api";

  //! auth
  static String loginURL = '/agent/login'.addBaseURl();
  static String logOutURL = '/agent/logout'.addBaseURl();
  static String sendOTPSmsURL = '/agent/send/code/phone'.addBaseURl();
  static String sendOTPEmailURL = '/agent/send-code'.addBaseURl();
  static String verifyPhoneOTPURL = '/agent/phone-verify'.addBaseURl();
  static String sendForgotOTPEmailURL = '/agent/forget/password'.addBaseURl();
  static String verifyForgotOTPEmailURL = '/agent/forget/verify/otp'
      .addBaseURl();
  static String verifyEmailURL = '/agent/email-verify'.addBaseURl();
  static String checkingUserURL = '/agent/forget/password/check/agent'
      .addBaseURl();
  static String resetPasswordURL = '/agent/forget/reset/password'.addBaseURl();
  static String resetPasswordSmsURL = '/user/forget/sms/reset/password'
      .addBaseURl();
  static String verifyEmailBeforeRegisterOTPURL =
      '/agent/register/email/verify/otp'.addBaseURl(); 

  //! register
  static String checkRegisterURL = '/agent/register/check/exist'.addBaseURl();
  static String basicDataURL = '/agent/get/basic/data'.addBaseURl();
  static String userKycURL = '/agent/kyc'.addBaseURl();
  static String registerURL = '/agent/register'.addBaseURl();
  static String sendRegisterEmailOTPURL = '/agent/register/send/otp'
      .addBaseURl();
  static String verifyRegisterEmailOTPURL = '/agent/register/verify/otp'
      .addBaseURl();
  // phone verification
  static String verifyRegisterPhoneOTPURL = '/agent/register/sms/verify/otp'
      .addBaseURl();
  static String resendRegisterPhoneOTPURL = '/agent/register/sms/resend/otp'
      .addBaseURl();

  // Forgot password using phone otp
  static String resendForgotPhoneOTPURL = '/agent/forget/sms/resend'
      .addBaseURl();
  static String verifyForgotPhoneOTPURL = '/agent/forget/sms/verify/otp'
      .addBaseURl();
  //! navbar
  static String dashboardURL = '/agent/dashboard'.addBaseURl();
  static String notificationsURL = '/agent/notifications'.addBaseURl();

  //! Pin Code
  static String setupPinURL = '/agent/setup/pin/store'.addBaseURl();
  static String upDatePinURL = '/agent/setup/pin/update'.addBaseURl();
  static String verifyPinURL = '/agent/verify/pin'.addBaseURl();

  //! profile
  static String profileURL = '/agent/profile'.addBaseURl();
  static String updateProfileApi = '/agent/profile/update'.addBaseURl();
  static String updateKYCApi = '/agent/kyc/submit'.addBaseURl();

  //! categories
  static String addMoneyInfoURL = '/agent/add-money/information'.addBaseURl();

  //! drawer
  static String passwordUpdate = '/agent/password/update'.addBaseURl();
  static String logout = '/agent/logout'.addBaseURl();

  //! send money
  static String addMoneyInsertURL = '/agent/add-money/submit-data'.addBaseURl();
  static String addMoneyAuthorizeConfirmURL =
      '/agent/add-money/authorize-payment-submit'.addBaseURl();
  static String addMoneyManualConfirmURL =
      '/agent/add-money/manual/payment/confirmed'.addBaseURl();

  ///flutterwave virtual card
  static String cardInfoURL = '/agent/my-card'.addBaseURl();
  static String cardDetailsURL = '/agent/my-card/details?card_id='.addBaseURl();
  static String cardBlockURL = '/agent/my-card/block'.addBaseURl();
  static String cardUnBlockURL = '/agent/my-card/unblock'.addBaseURl();
  static String cardAddFundURL = '/agent/my-card/fund'.addBaseURl();
  static String createCardURL = '/agent/my-card/create'.addBaseURl();
  static String cardTransactionURL = '/agent/my-card/transaction?card_id='
      .addBaseURl();
  static String flutterWaveCardMakeOrRemoveDefaultFundURL =
      '/agent/my-card/make-remove/default'.addBaseURl();

  ///sudo virtual card
  static String sudoCardInfoURL = '/agent/my-card/sudo'.addBaseURl();
  static String sudoCardDetailsURL = '/agent/my-card/sudo/details?card_id='
      .addBaseURl();
  static String sudoCardBlockURL = '/agent/my-card/sudo/block'.addBaseURl();
  static String sudoCardUnBlockURL = '/agent/my-card/sudo/unblock'.addBaseURl();
  static String sudoCardMakeOrRemoveDefaultFundURL =
      '/agent/my-card/sudo/make-remove/default'.addBaseURl();
  static String sudoCreateCardURL = '/agent/my-card/sudo/create'.addBaseURl();
  static String sudoCardTransactionURL = '/agent/my-card/transaction?card_id='
      .addBaseURl();

  static String receiveMoneyURL = '/agent/receive-money'.addBaseURl();
  static String sendMoneyInfoURL = '/agent/send-money/info'.addBaseURl();
  static String checkUserExistURL = '/agent/send-money/exist'.addBaseURl();
  static String checkUserWithQeCodeURL = '/agent/send-money/qr/scan'
      .addBaseURl();
  static String sendMoneyURL = '/agent/send-money/confirmed'.addBaseURl();

  // money_out
  static String withdrawInfoURL = '/agent/withdraw/info'.addBaseURl();
  static String flutterWaveBanksURL =
      '/agent/withdraw/get/flutterwave/banks?trx='.addBaseURlDefault();
  static String withdrawInsertURL = '/agent/withdraw/insert'.addBaseURl();
  static String manualWithdrawConfirmURL = '/agent/withdraw/manual/confirmed'
      .addBaseURl();
  static String checkFlutterwaveAccountURL =
      '/agent/withdraw/check/flutterwave/bank'.addBaseURlDefault();
  static String automaticWithdrawConfirmURL =
      '/agent/withdraw/automatic/confirmed'.addBaseURl();
  static String flutterWaveBanksBranchURL =
      '/agent/withdraw/get/flutterwave/bank/branches'.addBaseURlDefault();

  static String billPayInfoURL = '/agent/bill-pay/info'.addBaseURl();
  static String billPayConfirmedURL = '/agent/bill-pay/confirmed'.addBaseURl();

  static String topupInfoURL = '/agent/mobile-topup/info'.addBaseURl();
  static String topupConfirmedURL = '/agent/mobile-topup/confirmed'
      .addBaseURl();

  /// remittance
  static String remittanceInfoURL = '/agent/remittance/info'.addBaseURl();
  static String remittanceGetRecipientSenderURL =
      '/agent/remittance/get/recipient/sender'.addBaseURl();
  static String remittanceGetRecipientReceiverURL =
      '/agent/remittance/get/recipient/receiver'.addBaseURl();
  static String remittanceConfirmedURL = '/agent/remittance/confirmed'
      .addBaseURl();
  static String remittanceGetRecipientURL = '/agent/remittance/get/recipient'
      .addBaseURl();

  /// transactions
  static String transactionLogURL = '/agent/transactions'.addBaseURl();

  //app settings
  static String appSettingsURL = '/app-settings'.addBaseURl();

  // 2 fa security
  static String twoFAInfoURL = '/agent/security/google-2fa'.addBaseURl();
  static String twoFAVerifyURL = '/agent/google-2fa/otp/verify'.addBaseURl();
  static String twoFaSubmitURL = '/agent/security/google-2fa/status/update'
      .addBaseURl();

  static String makePaymentInfoURL = '/agent/make-payment/info'.addBaseURl();
  static String checkMerchantExistURL = '/agent/make-payment/check/merchant'
      .addBaseURl();
  static String checkMerchantWithQeCodeURL =
      '/agent/make-payment/merchants/scan'.addBaseURl();
  static String makePaymentURL = '/agent/make-payment/confirmed'.addBaseURl();

  static String smsVerifyURL = '/agent/sms/verify'.addBaseURl();
  static String deleteAccountURL = '/agent/delete/account'.addBaseURl();

  // language
  static String languagesURL = '/app-settings/languages'.addBaseURl();

  ///  =>>>>>>>>>> stripe virtual card
  static String stripeCardInfoURL = '/agent/my-card/stripe'.addBaseURl();
  static String stripeCardDetailsURL = '/agent/my-card/stripe/details?card_id='
      .addBaseURl();
  static String stripeCardTransactionURL =
      '/agent/my-card/stripe/transaction?card_id='.addBaseURl();
  static String stripeSensitiveURl = '/agent/my-card/stripe/get/sensitive/data'
      .addBaseURl();
  static String stripeInactiveURl = '/agent/my-card/stripe/inactive'
      .addBaseURl();
  static String stripeActiveURl = '/agent/my-card/stripe/active'.addBaseURl();

  static String stripeBuyCardURl = '/agent/my-card/stripe/create'.addBaseURl();

  //-> payments
  static String paymentLinkGetURL = '/agent/payment-links'.addBaseURl();
  static String paymentLinkEditGetURL = '/agent/payment-links/edit?target='
      .addBaseURl();
  static String paymentLinkStoreURL = '/agent/payment-links/store'.addBaseURl();
  static String paymentLinkUpdateURL = '/agent/payment-links/update'
      .addBaseURl();
  static String statusURL = '/agent/payment-links/status'.addBaseURl();

  //-> Request Money
  static String requestMoneyInfoURL = '/agent/request-money'.addBaseURl();
  static String requestMoneySubmitURL = '/agent/request-money/submit'
      .addBaseURl();
  static String requestMoneyQrScanURL = '/agent/request-money/qr/scan'
      .addBaseURl();
  static String requestMoneyCheckUserURL = '/agent/request-money/check/agent'
      .addBaseURl();
  static String requestMoneyLogsRejectURL = '/agent/request-money/logs/reject'
      .addBaseURl();
  static String requestMoneyLogsApproveURL = '/agent/request-money/logs/approve'
      .addBaseURl();
  static String requestMoneyLogsURL = '/agent/request-money/logs'.addBaseURl();
  static String addMoneySubmitData = '/agent/add-money/submit-data'
      .addBaseURl();

  /// Strowallet
  static String strowalletCardURL = '/agent/strowallet-card'.addBaseURl();
  static String strowalletCardChargeURL = '/agent/strowallet-card/charges'
      .addBaseURl();
  static String strowalletCardDetailsURL =
      '/agent/strowallet-card/details?card_id='.addBaseURl();
  static String strowalletCardTransactionURL =
      '/agent/strowallet-card/transaction?card_id='.addBaseURl();
  static String strowalletCardBLockURL = '/agent/strowallet-card/block'
      .addBaseURl();
  static String strowalletCardUnBlockURL = '/agent/strowallet-card/unblock'
      .addBaseURl();
  static String strowalletBuyCardURL = '/agent/strowallet-card/create'
      .addBaseURl();
  static String strowalletCardFundURL = '/agent/strowallet-card/fund'
      .addBaseURl();
  static String strowalletCardMakeOrRemoveDefaultFundURL =
      '/agent/strowallet-card/make-remove/default'.addBaseURl();

  /// Money in endpoint
  static String moneyInInfoURL = '/agent/money-in/info'.addBaseURl();
  static String checkMoneyInUserExistURL = '/agent/money-in/exist'.addBaseURl();
  static String checkMoneyInUserWithQeCodeURL = '/agent/money-in/qr/scan'
      .addBaseURl();
  static String moneyInURL = '/agent/money-in/confirmed'.addBaseURl();

  /// Recipient ENDPOINT
  //->common
  static String senderRecipientInfoURL = '/agent/recipient/save/info'
      .addBaseURl();
  static String recipientCheckUserURL = '/agent/recipient/check/user'
      .addBaseURl();
  static String recipientDynamicInputURL = '/agent/recipient/dynamic/fields'
      .addBaseURl();

  // My sender endpoint
  static String senderRecipientListURL = '/agent/recipient/sender/list'
      .addBaseURl();
  static String senderRecipientStoreURL = '/agent/recipient/sender/store'
      .addBaseURl();
  static String senderRecipientUpdateURL = '/agent/recipient/sender/update'
      .addBaseURl();
  static String senderRecipientDeleteURL = '/agent/recipient/sender/delete'
      .addBaseURl();
  static String senderRecipientEditURL = '/agent/recipient/sender/edit?id='
      .addBaseURlDefault();

  // My receiver endpoint
  static String receiverRecipientListURL = '/agent/recipient/receiver/list'
      .addBaseURl();
  static String receiverRecipientStoreURL = '/agent/recipient/receiver/store'
      .addBaseURl();
  static String receiverRecipientUpdateURL = '/agent/recipient/receiver/update'
      .addBaseURl();
  static String receiverRecipientDeleteURL = '/agent/recipient/receiver/delete'
      .addBaseURl();
  static String receiverRecipientEditURL = '/agent/recipient/receiver/edit?id='
      .addBaseURlDefault();

  static String topUpAutomaticConfirmedURL = '/agent/mobile-topup/automatic/pay'
      .addBaseURl();
  static String checkOperatorURL =
      '/agent/mobile-topup/automatic/check-operator?'.addBaseURlDefault();

  // Pusher
  static String pusherBeamsAuthURL = '/agent/pusher/beams-auth?user_id='
      .addBaseURlDefault();
  static String pusherBeamsAuthMain = '/agent/pusher/beams-auth'
      .addBaseURlDefault();

  ///wallet
  static String walletsURL = '/agent/wallets'.addBaseURl();

  ///money exchange
  static String moneyExchangeInfoURL = '/agent/money-exchange'.addBaseURl();
  static String moneyExchangeSubmitURL = '/agent/money-exchange/submit'
      .addBaseURl();
  static String getBankInfoURL = '/agent/remittance/get/bank/charges?alias='
      .addBaseURlDefault();
  static String remainingBalanceURL = '/agent/get-remaining?transaction_type='
      .addBaseURlDefault();
}
