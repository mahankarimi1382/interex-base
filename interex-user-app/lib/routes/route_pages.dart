import 'package:get/get.dart';
import 'package:qrpaypro/backend/services/api_endpoint.dart';
import 'package:qrpaypro/routes/routes.dart';
import 'package:qrpaypro/views/auth/kyc_from/wait_for_approval_screen.dart';
import 'package:qrpaypro/views/auth/login/otp_verification_screen.dart';
import 'package:qrpaypro/views/auth/registration/email_otp_screen.dart';
import 'package:qrpaypro/views/auth/registration/registration_screen.dart';
import 'package:qrpaypro/views/categories/add_money/add_money_preview_screen.dart';
import 'package:qrpaypro/views/categories/bill_pay/bill_pay_screen.dart';
import 'package:qrpaypro/views/categories/make_counter_offer/view/make_counter_screen.dart';
import 'package:qrpaypro/views/categories/mobile_topup/mobile_topup_screen.dart';
import 'package:qrpaypro/views/categories/remittance/remitance_preview_screen.dart';
import 'package:qrpaypro/views/categories/send_money/qr_code_screen.dart';
import 'package:qrpaypro/views/categories/send_money/send_money_preview_screen.dart';
import 'package:qrpaypro/views/categories/send_money/send_money_screen.dart';
import 'package:qrpaypro/views/categories/virtual_card/flutter_wave_virtual_card/add_fund_screen.dart';
import 'package:qrpaypro/views/categories/virtual_card/flutter_wave_virtual_card/card_details_screen.dart';
import 'package:qrpaypro/views/categories/virtual_card/flutter_wave_virtual_card/fund_preview_screen.dart';
import 'package:qrpaypro/views/categories/withdraw/withdraw_preview_screen.dart';
import 'package:qrpaypro/views/drawer/bill_payment_log_screen.dart';
import 'package:qrpaypro/views/drawer/change_password_screen.dart';
import 'package:qrpaypro/views/drawer/mobile_log_screen.dart';
import 'package:qrpaypro/views/drawer/saved_recipient_screen.dart';
import 'package:qrpaypro/views/drawer/setting_screen.dart';
import 'package:qrpaypro/views/drawer/transaction_logs_screen.dart';
import 'package:qrpaypro/views/navbar/bottom_navbar_screen.dart';
import 'package:qrpaypro/views/navbar/dashboard_screen.dart';
import 'package:qrpaypro/views/navbar/notification_screen.dart';
import 'package:qrpaypro/views/onboard/onboard_screen.dart';
import 'package:qrpaypro/views/profile/2fa/enable_2fa_screen.dart';
import 'package:qrpaypro/views/profile/2fa/two_fa_otp_screen.dart';
import 'package:qrpaypro/views/profile/my_wallet_screen.dart';
import 'package:qrpaypro/views/profile/profile_screen.dart';
import 'package:qrpaypro/views/profile/update_kyc_screen.dart';
import 'package:qrpaypro/views/profile/update_profile_screen.dart';

import '../bindings/initial_binding.dart';
import '../bindings/splash_screen_binding.dart';
import '../language/english.dart';
import '../views/categories/virtual_card/cardyfie_card/cardyfie_add_fund/cardyfie_add_fund_screen.dart';
import '../views/categories/virtual_card/cardyfie_card/cardyfie_transaction/cardyfie_transaction_screen.dart';
import '../views/categories/virtual_card/cardyfie_card/cardyfie_withdraw/cardyfie_withdraw_screen.dart';
import '../views/referral/refer_status_screen.dart';
import '../views/auth/kyc_from/kyc_from_screen.dart';
import '../views/auth/login/email_verification_screen.dart';
import '../views/auth/login/phone_verification_screen.dart';
import '../views/auth/login/reset_password_screen.dart';
import '../views/auth/login/signin_screen.dart';
import '../views/auth/registration/sms_otp_screen.dart';
import '../views/categories/add_money/add_money_manual_payment_screen.dart';
import '../views/categories/add_money/add_money_screen.dart';
import '../views/categories/add_money/authorized_payment_screen.dart';
import '../views/categories/add_money/coingate_payment_screen.dart';
import '../views/categories/add_money/flutterwave_web_payment_screen.dart';
import '../views/categories/add_money/pagadito_web_payment_screen.dart';
import '../views/categories/add_money/pay_stack_payment_screen.dart';
import '../views/categories/add_money/paypal_web_payment_screen.dart';
import '../views/categories/add_money/perfect_money_payment_screen.dart';
import '../views/categories/add_money/razor_pay_web_screen.dart';
import '../views/categories/add_money/ssl_web_payment_screen.dart';
import '../views/categories/add_money/stripe_web_payment_screen.dart';
import '../views/categories/add_money/tatum/tatum_payment_screen.dart';
import '../views/categories/agent_moneyout/agent_money_screen.dart';
import '../views/categories/agent_moneyout/agent_moneyout_preview_screen.dart';
import '../views/categories/agent_moneyout/qr_code_screen.dart';
import '../views/categories/bill_pay/billpay_preview_screen.dart';
import '../views/categories/exchange_money/exchange_money_preview_screen.dart';
import '../views/categories/exchange_money/exchange_money_screen.dart';
import '../views/categories/get_offer/view/get_offer_screen.dart';
import '../views/categories/make_an_offer/view/make_an_offer_buying_preview_screen.dart';
import '../views/categories/make_payment/make_payment_qr_code_screen.dart';
import '../views/categories/make_payment/make_payment_screen.dart';
import '../views/categories/market_place/view/marketplace_buying_preview_screen.dart';
import '../views/categories/market_place/view/marketplace_evidence_submit_screen.dart';
import '../views/categories/market_place/view/marketplace_screen.dart';
import '../views/categories/mobile_topup/mobile_preview_screen.dart';
import '../views/categories/my_chat/view/chat_screen.dart';
import '../views/categories/my_chat/view/my_chat_screen.dart';
import '../views/categories/offer_buy/view/offer_buy_preview_screen.dart';
import '../views/categories/offer_buy/view/offer_evidence_submit_screen.dart';
import '../views/categories/payments_screen/payment_log/payment_log_screen.dart';
import '../views/categories/payments_screen/payments_edit/payments_edit_screen.dart';
import '../views/categories/payments_screen/payments_screen.dart';
import '../views/categories/received_money/money_received_screen.dart';
import '../views/categories/remittance/add_recipient_screen.dart';
import '../views/categories/remittance/edit_recipient_screen.dart';
import '../views/categories/remittance/remittance_screen.dart';
import '../views/categories/request_money/request_money_log.dart';
import '../views/categories/request_money/request_money_preview_screen.dart';
import '../views/categories/request_money/request_money_qr_code_screen.dart';
import '../views/categories/request_money/request_money_screen.dart';
import '../views/categories/trade/view/trade_qr_screen.dart';
import '../views/categories/trade/view/trade_screen.dart';
import '../views/categories/trade/view/trade_submit_preview_screen.dart';
import '../views/categories/trade/view/trade_submit_screen.dart';
import '../views/categories/trade/view/trade_update_screen.dart';
import '../views/categories/virtual_card/cardyfie_card/cardyfie_create_card_screen/cardyfie_create_card_screen.dart';
import '../views/categories/virtual_card/cardyfie_card/cardyfie_details/cardyfie_details_screen.dart';
import '../views/categories/virtual_card/cardyfie_card/cardyfie_update_customer_screen.dart/update_customer_screen.dart';
import '../views/categories/virtual_card/flutter_wave_virtual_card/transaction_history_screen.dart';
import '../views/categories/virtual_card/strowallet_card/adfund_strowallet_screen.dart';
import '../views/categories/virtual_card/strowallet_card/strowallet_details_screen.dart';
import '../views/categories/virtual_card/strowallet_card/strowallet_new_card_screen.dart';
import '../views/categories/virtual_card/strowallet_card/strowallet_transacton.dart';
import '../views/categories/virtual_card/strowallet_card/strowallet_webhook_screen.dart';
import '../views/categories/virtual_card/strowallet_card/update_customer_screen.dart';
import '../views/categories/virtual_card/sudo_virtual_card/sudo_add_fund_screen.dart';
import '../views/categories/virtual_card/sudo_virtual_card/sudo_card_details_screen.dart';
import '../views/categories/virtual_card/virtual_card_screen.dart';
import '../views/categories/withdraw/withdraw_flutterwave_screen.dart';
import '../views/categories/withdraw/withdraw_manual_payment_screen.dart';
import '../views/categories/withdraw/withdraw_screen.dart';
import '../views/drawer/giftcard_log_screen.dart';
import '../views/drawer/web_view.dart';
import '../views/gift_card/all_gift_card_screen.dart';
import '../views/gift_card/create_gift_card_screen.dart';
import '../views/gift_card/gift_card_screen.dart';
import '../views/navbar/wallets_screen.dart';
import '../views/set_up_pin/view/pin_setup_screen.dart';
import '../views/splash_screen/splash_screen.dart';

class RoutePageList {
  static var list = [
    //!auth
    GetPage(
      name: Routes.splashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),

    GetPage(name: Routes.onboardScreen, page: () => OnboardScreen()),

    GetPage(name: Routes.signInScreen, page: () => const SignInScreen()),

    GetPage(name: Routes.resetOtpScreen, page: () => ResetOtpScreen()),

    GetPage(
      name: Routes.resetPasswordScreen,
      page: () => ResetPasswordScreen(),
    ),
    GetPage(name: Routes.registrationScreen, page: () => RegistrationScreen()),
    GetPage(name: Routes.emailOtpScreen, page: () => EmailOtpScreen()),

    GetPage(name: Routes.kycFromScreen, page: () => KycFromScreen()),
    GetPage(
      name: Routes.waitForApprovalScreen,
      page: () => const WaitForApprovalScreen(),
    ),

    //!categories
    GetPage(
      name: Routes.bottomNavBarScreen,
      page: () => BottomNavBarScreen(),
      binding: InitialScreenBindings(),
    ),
    GetPage(name: Routes.dashboardScreen, page: () => DashboardScreen()),
    GetPage(name: Routes.notificationScreen, page: () => NotificationScreen()),

    GetPage(name: Routes.qRCodeScreen, page: () => const QRCodeScreen()),
    GetPage(
      name: Routes.moneyTransferScreen,
      page: () => MoneyTransferScreen(),
    ),
    GetPage(
      name: Routes.sendMoneyPreviewScreen,
      page: () => SendMoneyPreviewScreen(),
    ),
    GetPage(name: Routes.moneyReceiveScreen, page: () => MoneyReceiveScreen()),
    GetPage(name: Routes.remittanceScreen, page: () => RemittanceScreen()),
    GetPage(
      name: Routes.remittancePreviewScreen,
      page: () => RemittancePreviewScreen(),
    ),
    GetPage(name: Routes.addRecipientScreen, page: () => AddRecipientScreen()),
    GetPage(
      name: Routes.editRecipientScreen,
      page: () => EditRecipientScreen(),
    ),
    //todo_virtual card
    GetPage(name: Routes.virtualCardScreen, page: () => VirtualCardScreen()),
    GetPage(name: Routes.cardDetailsScreen, page: () => CardDetailsScreen()),
    GetPage(
      name: Routes.addFundScreen,
      page: () => AddFundScreen(appBarTitle: Strings.addFund),
    ),
    GetPage(
      name: Routes.buyCardScreen,
      page: () => AddFundScreen(appBarTitle: Strings.createCard),
    ),
    GetPage(
      name: Routes.sudoCreateCardScreen,
      page: () => SudoAddFundScreen(appBarTitle: Strings.createCard),
    ),
    GetPage(
      name: Routes.sudoAddFuncCardScreen,
      page: () => SudoAddFundScreen(appBarTitle: Strings.addFund),
    ),
    GetPage(
      name: Routes.addFundPreviewScreen,
      page: () => const AddFundPreviewScreen(),
    ),
    GetPage(
      name: Routes.transactionHistoryScreen,
      page: () => TransactionHistoryScreen(),
    ),

    //deposti,withdraw,mobile,billpay
    GetPage(name: Routes.addMoneyScreen, page: () => DepositScreen()),
    GetPage(
      name: Routes.depositPreviewScreen,
      page: () => DepositPreviewScreen(),
    ),
    GetPage(name: Routes.withdrawScreen, page: () => WithdrawScreen()),
    GetPage(
      name: Routes.withdrawPreviewScreen,
      page: () => WithdrawPreviewScreen(),
    ),
    GetPage(name: Routes.mobileToUpScreen, page: () => MobileTopUpScreen()),
    GetPage(
      name: Routes.mobilePreviewScreen,
      page: () => const MobilePreviewScreen(),
    ),
    GetPage(name: Routes.billPayScreen, page: () => BillPayScreen()),
    GetPage(
      name: Routes.billPayPreviewScreen,
      page: () => BillPayPreviewScreen(),
    ),
    GetPage(
      name: Routes.makePaymentQRCodeScreen,
      page: () => const MakePaymentQRCodeScreen(),
    ),
    GetPage(name: Routes.makePaymentScreen, page: () => MakePaymentScreen()),
    GetPage(
      name: Routes.makePaymentPreviewScreen,
      page: () => SendMoneyPreviewScreen(),
    ),

    //!drawer screens
    GetPage(
      name: Routes.saveRecipientScreen,
      page: () => SaveRecipientScreen(),
    ),

    GetPage(
      name: Routes.transactionLogScreen,
      page: () => TransactionLogScreen(),
    ),
    GetPage(
      name: Routes.giftCardLogScreen,
      page: () => const GiftCardLogScreen(),
    ),
    GetPage(
      name: Routes.billPaymentLogScreen,
      page: () => BillPaymentLogScreen(),
    ),
    GetPage(name: Routes.mobileLogScreen, page: () => MobileLogScreen()),
    GetPage(name: Routes.settingScreen, page: () => SettingScreen()),
    GetPage(
      name: Routes.changePasswordScreen,
      page: () => ChangePasswordScreen(),
    ),

    //!profile screen
    GetPage(name: Routes.profileScreen, page: () => ProfileScreen()),
    GetPage(name: Routes.myWalletScreen, page: () => const MyWalletScreen()),
    GetPage(
      name: Routes.updateProfileScreen,
      page: () => UpdateProfileScreen(),
    ),
    GetPage(name: Routes.updateKycScreen, page: () => UpdateKycScreen()),
    GetPage(name: Routes.enable2FaScreen, page: () => Enable2FaScreen()),
    GetPage(name: Routes.otp2FaScreen, page: () => Otp2FaScreen()),
    GetPage(
      name: Routes.paypalWebPaymentScreen,
      page: () => PaypalWebPaymentScreen(),
    ),
    GetPage(
      name: Routes.flutterWaveWebPaymentScreen,
      page: () => FlutterWaveWebPaymentScreen(),
    ),
    GetPage(
      name: Routes.perfectMoneyWebPaymentScreen,
      page: () => PerfectMoneyWebPaymentScreen(),
    ),

    GetPage(
      name: Routes.sendMoneyManualPaymentScreen,
      page: () => AddMoneyManualPaymentScreen(),
    ),
    GetPage(
      name: Routes.withdrawManualPaymentScreen,
      page: () => WithdrawManualPaymentScreen(),
    ),
    GetPage(
      name: Routes.withdrawFlutterwaveScreen,
      page: () => WithdrawFlutterWaveScreen(),
    ),

    GetPage(
      name: Routes.emailVerificationScreen,
      page: () => EmailVerificationScreen(),
    ),
    GetPage(
      name: Routes.sudoCardDetailsScreen,
      page: () => SudoCardDetailsScreen(),
    ),

    GetPage(
      name: Routes.razorPayScreen,
      page: () => RazorPayWebPaymentScreen(),
    ),

    GetPage(
      name: Routes.pagaditoWebPaymentScreen,
      page: () => PagaditoWebPaymentScreen(),
    ),

    //agent
    GetPage(
      name: Routes.agentMoneyOutScreen,
      page: () => AgentMoneyOutScreen(),
    ),

    GetPage(
      name: Routes.agentMoneyScreenPreviewScreen,
      page: () => AgentMoneyScreenPreviewScreen(),
    ),

    GetPage(
      name: Routes.qRCodeAgentMoneyOutScreen,
      page: () => const QRCodeAgentMoneyOutScreen(),
    ),
    GetPage(
      name: Routes.helpCenterScreen,
      page: () => WebScreen(
        title: Strings.helpCenter,
        url: "${ApiEndpoint.mainDomain}/contact",
      ),
    ),

    GetPage(
      name: Routes.privacyScreen,
      page: () => WebScreen(
        title: Strings.privacyPolicy,
        url: "${ApiEndpoint.mainDomain}/page/privacy-policy",
      ),
    ),
    GetPage(
      name: Routes.aboutUsScreen,
      page: () => WebScreen(
        title: Strings.aboutUs,
        url: "${ApiEndpoint.mainDomain}/about",
      ),
    ),
    GetPage(
      name: Routes.stripeWebPaymentScreen,
      page: () => StripeWebPaymentScreen(),
    ),
    GetPage(
      name: Routes.sslWebPaymentScreen,
      page: () => SslWebPaymentScreen(),
    ),
    GetPage(
      name: Routes.coinGatePaymentScreen,
      page: () => CoinGateWebPaymentScreen(),
    ),

    GetPage(name: Routes.paymentsScreen, page: () => const PaymentsScreen()),
    GetPage(
      name: Routes.paymentsEditScreen,
      page: () => const PaymentsEditScreen(),
    ),
    GetPage(
      name: Routes.paymentLogScreen,
      page: () => const PaymentLogScreen(),
    ),
    GetPage(name: Routes.requestMoneyScreen, page: () => RequestMoneyScreen()),
    GetPage(
      name: Routes.requestMoneyPreviewScreen,
      page: () => RequestMoneyPreviewScreen(),
    ),
    GetPage(
      name: Routes.requestMoneyQRCodeScreen,
      page: () => const RequestMoneyQRCodeScreen(),
    ),
    GetPage(
      name: Routes.requestMoneyLogScreen,
      page: () => RequestMoneyLogScreen(),
    ),
    GetPage(name: Routes.tatumPaymentScreen, page: () => TatumPaymentScreen()),

    //>>> gift card
    GetPage(name: Routes.giftCardScreen, page: () => GiftCardScreen()),
    GetPage(name: Routes.allGiftCardScreen, page: () => AllGiftCardScreen()),
    GetPage(
      name: Routes.createGiftCardScreen,
      page: () => CreateGiftCardScreen(),
    ),
    GetPage(
      name: Routes.strowalletCardDetailsScreen,
      page: () => StrowalletCardDetailsScreen(),
    ),
    GetPage(
      name: Routes.strowalletTransactionHistoryScreen,
      page: () => StrowalletTransactionHistoryScreen(),
    ),
    GetPage(
      name: Routes.strowalletAddFundScreen,
      page: () => const StrowalletAddFundScreen(),
    ),
    GetPage(
      name: Routes.crateStrowalletScreen,
      page: () => CrateStrowalletScreen(),
    ),

    // Exchange money screen
    GetPage(name: Routes.moneyExchange, page: () => ExchangeMoneyScreen()),

    // Exchange money screen
    GetPage(
      name: Routes.exchangeMoneyPreviewScreen,
      page: () => ExchangeMoneyPreviewScreen(),
    ),
    GetPage(name: Routes.walletsScreen, page: () => WalletsScreen()),

    GetPage(
      name: Routes.paystackScreen,
      page: () => PaystackWebPaymentScreen(),
    ),

    GetPage(
      name: Routes.updateCustomerKycScreen,
      page: () => UpdateCustomerKycScreen(),
    ),

    GetPage(name: Routes.smsOtpScreen, page: () => SmsOtpScreen()),

    GetPage(
      name: Routes.phoneVerificationScreen,
      page: () => PhoneVerificationScreen(),
    ),
    GetPage(
      name: Routes.referralStatusScreen,
      page: () => const ReferralStatusScreen(),
    ),
    GetPage(name: Routes.webhookLogsScreen, page: () => WebhookLogsScreen()),

    GetPage(name: Routes.pinSetupScreen, page: () => PinSetupScreen()),

    GetPage(name: Routes.myChatScreen, page: () => MyChatScreen()),
    GetPage(name: Routes.chatScreen, page: () => ChatScreen()),
    GetPage(name: Routes.tradeScreen, page: () => TradeScreen()),
    GetPage(name: Routes.tradeSubmitScreen, page: () => TradeSubmitScreen()),
    GetPage(
      name: Routes.tradeSubmitPreviewScreen,
      page: () => TradeSubmitPreviewScreen(),
    ),
    GetPage(name: Routes.tradeUpdateScreen, page: () => TradeUpdateScreen()),
    GetPage(name: Routes.tradeQrScreen, page: () => TradeQrScreen()),

    GetPage(
      name: Routes.makeCounterOfferScreen,
      page: () => MakeCounterOfferScreen(),
    ),
    GetPage(
      name: Routes.marketplaceEvidenceSubmitScreen,
      page: () => MarketplaceEvidenceSubmitScreen(),
    ),
    GetPage(
      name: Routes.marketplaceBuyingPreviewScreen,
      page: () => MarketplaceBuyingPreviewScreen(),
    ),
    GetPage(
      name: Routes.offerBuyPreviewScreen,
      page: () => OfferBuyPreviewScreen(),
    ),
    GetPage(
      name: Routes.offerEvidenceSubmitScreen,
      page: () => OfferEvidenceSubmitScreen(),
    ),
    GetPage(
      name: Routes.makeAnOfferBuyingPreviewScreen,
      page: () => MakeAnOfferBuyingPreviewScreen(),
    ),
    GetPage(name: Routes.getOfferScreen, page: () => GetOfferScreen()),
    GetPage(name: Routes.marketplaceScreen, page: () => MarketplaceScreen()),

    GetPage(
      name: Routes.addMoneyAuthorizedPaymentScreen,
      page: () => AddMoneyAuthorizedPaymentScreen(),
    ),

    GetPage(
      name: Routes.cardyfieDetailsScreen,
      page: () => CardyfieDetailsScreen(),
    ),

    GetPage(
      name: Routes.crateCardyfieScreen,
      page: () => CrateCardyfieScreen(),
    ),
    GetPage(
      name: Routes.cardyfieUpdateCustomerScreen,
      page: () => UpdateCustomerScreen(),
    ),

    GetPage(
      name: Routes.cardyfieAddFundScreen,
      page: () => CardyfieDepositScreen(),
    ),
    GetPage(
      name: Routes.cardyfieWithdrawScreen,
      page: () => CardyfieWithdrawScreen(),
    ),
    GetPage(
      name: Routes.cardyfieTransactionHistoryScreen,
      page: () => CardyfieTransactionLogScreen(),
    ),
  ];
}
