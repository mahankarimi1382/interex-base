import 'package:get/get.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/views/auth/kyc_from/wait_for_approval_screen.dart';
import 'package:qrpay/views/auth/login/otp_verification_screen.dart';
import 'package:qrpay/views/auth/registration/email_otp_screen.dart';
import 'package:qrpay/views/auth/registration/registration_screen.dart';
import 'package:qrpay/views/categories/withdraw/withdraw_preview_screen.dart';
import 'package:qrpay/views/drawer/change_password_screen.dart';
import 'package:qrpay/views/drawer/setting_screen.dart';
import 'package:qrpay/views/drawer/transaction_logs_screen.dart';
import 'package:qrpay/views/navbar/bottom_navbar_screen.dart';
import 'package:qrpay/views/navbar/dashboard_screen.dart';
import 'package:qrpay/views/navbar/notification_screen.dart';
import 'package:qrpay/views/profile/2fa/enable_2fa_screen.dart';
import 'package:qrpay/views/profile/profile_screen.dart';
import 'package:qrpay/views/profile/update_kyc_screen.dart';
import 'package:qrpay/views/profile/update_profile_screen.dart';

import '../backend/services/api_endpoint.dart';
import '../bindings/btm_screen_binding.dart';
import '../bindings/splash_screen_binding.dart';
import '../utils/strings.dart';
import '../views/auth/kyc_from/kyc_from_screen.dart';
import '../views/auth/login/email_verification_screen.dart';
import '../views/auth/login/phone_verification_screen.dart';
import '../views/auth/login/reset_password_phone_screen.dart';
import '../views/auth/login/reset_password_screen.dart';
import '../views/auth/login/reset_phone_otp_screen.dart';
import '../views/auth/login/signin_screen.dart';
import '../views/auth/registration/sms_otp_screen.dart';
import '../views/categories/exchange_money/exchange_money_preview_screen.dart';
import '../views/categories/exchange_money/exchange_money_screen.dart';
import '../views/categories/pay_link/payment_log/payment_log_screen.dart';
import '../views/categories/pay_link/payments_edit/payments_edit_screen.dart';
import '../views/categories/pay_link/payments_screen.dart';
import '../views/categories/received_money/money_received_screen.dart';
import '../views/categories/withdraw/withdraw_flutterwave_screen.dart';
import '../views/categories/withdraw/withdraw_manual_payment_screen.dart';
import '../views/categories/withdraw/withdraw_screen.dart';
import '../views/drawer/api_key_screen.dart';
import '../views/drawer/gateway_settings_screen.dart';
import '../views/drawer/web_view.dart';
import '../views/navbar/wallets_screen.dart';
import '../views/onboard/onboard_screen.dart';
import '../views/profile/2fa/two_fa_otp_screen.dart';
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
      binding: NavBarBinding(),
    ),
    GetPage(name: Routes.dashboardScreen, page: () => DashboardScreen()),
    GetPage(name: Routes.notificationScreen, page: () => NotificationScreen()),

    GetPage(name: Routes.pinSetupScreen, page: () => PinSetupScreen()),

    GetPage(name: Routes.moneyReceiveScreen, page: () => MoneyReceiveScreen()),

    GetPage(name: Routes.withdrawScreen, page: () => WithdrawScreen()),
    GetPage(
      name: Routes.withdrawPreviewScreen,
      page: () => WithdrawPreviewScreen(),
    ),

    GetPage(
      name: Routes.withdrawFlutterwaveScreen,
      page: () => WithdrawFlutterWaveScreen(),
    ),

    GetPage(
      name: Routes.transactionLogScreen,
      page: () => TransactionLogScreen(),
    ),

    GetPage(name: Routes.settingScreen, page: () => SettingScreen()),
    GetPage(
      name: Routes.changePasswordScreen,
      page: () => ChangePasswordScreen(),
    ),
    GetPage(name: Routes.otp2FaScreen, page: () => Otp2FaScreen()),

    //!profile screen
    GetPage(name: Routes.profileScreen, page: () => ProfileScreen()),

    GetPage(
      name: Routes.updateProfileScreen,
      page: () => UpdateProfileScreen(),
    ),
    GetPage(name: Routes.updateKycScreen, page: () => UpdateKycScreen()),
    GetPage(name: Routes.enable2FaScreen, page: () => Enable2FaScreen()),

    GetPage(
      name: Routes.withdrawManualPaymentScreen,
      page: () => WithdrawManualPaymentScreen(),
    ),

    GetPage(
      name: Routes.emailVerificationScreen,
      page: () => EmailVerificationScreen(),
    ),
    GetPage(name: Routes.aPIKeyScreen, page: () => APIKeyScreen()),

    /// Paylink
    GetPage(name: Routes.paymentsScreen, page: () => const PaymentsScreen()),
    GetPage(
      name: Routes.paymentsEditScreen,
      page: () => const PaymentsEditScreen(),
    ),
    GetPage(
      name: Routes.paymentLogScreen,
      page: () => const PaymentLogScreen(),
    ),

    GetPage(
      name: Routes.gatewaySettingsScreen,
      page: () => GatewaySettingsScreen(),
    ),
    GetPage(name: Routes.onboardScreen, page: () => OnboardScreen()),
    GetPage(
      name: Routes.exchangeMoneyScreen,
      page: () => ExchangeMoneyScreen(),
    ),
    GetPage(name: Routes.walletsScreen, page: () => WalletsScreen()),
    GetPage(
      name: Routes.exchangeMoneyPreviewScreen,
      page: () => ExchangeMoneyPreviewScreen(),
    ),

    GetPage(
      name: Routes.helpCenterScreen,
      page: () => const WebScreen(
        title: Strings.helpCenter,
        url: "${ApiEndpoint.mainDomain}/contact",
      ),
    ),

    GetPage(
      name: Routes.privacyScreen,
      page: () => const WebScreen(
        title: Strings.privacyPolicy,
        url: "${ApiEndpoint.mainDomain}/page/privacy-policy",
      ),
    ),
    GetPage(
      name: Routes.aboutUsScreen,
      page: () => const WebScreen(
        title: Strings.aboutUs,
        url: "${ApiEndpoint.mainDomain}/about",
      ),
    ),

    GetPage(name: Routes.smsOtpScreen, page: () => SmsOtpScreen()),
    GetPage(
      name: Routes.phoneVerificationScreen,
      page: () => PhoneVerificationScreen(),
    ),
    GetPage(
      name: Routes.resetPhoneOtpScreen,
      page: () => ResetPhoneOtpScreen(),
    ),
    GetPage(
      name: Routes.resetPasswordPhoneScreen,
      page: () => ResetPasswordPhoneScreen(),
    ),
  ];
}
