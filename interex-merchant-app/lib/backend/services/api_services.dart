import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qrpay/backend/model/api_key/api_key_model.dart';
import 'package:qrpay/backend/model/auth/login/reset_password.dart';
import 'package:qrpay/backend/model/auth/registation/basic_data_model.dart';
import 'package:qrpay/backend/model/categories/receive_money/receive_money_model.dart';
import 'package:qrpay/utils/strings.dart';

import '../model/app_settings/app_settings_model.dart';
import '../model/auth/login/forget_password_model.dart';
import '../model/auth/login/login_model.dart';
import '../model/auth/registation/check_register_user_model.dart';
import '../model/auth/registation/registration_with_kyc_model.dart';
import '../model/bottom_navbar_model/dashboard_model.dart';
import '../model/bottom_navbar_model/notification_model.dart';
import '../model/categories/withdraw/flutter_wave_bank_model.dart';
import '../model/categories/withdraw/flutterwave_account_cheack_model.dart';
import '../model/categories/withdraw/money_out_manual_insert_model.dart';
import '../model/categories/withdraw/money_out_payment_getway_model.dart';
import '../model/categories/withdraw/withdraw_flutterwave_insert_model.dart';
import '../model/common/common_success_model.dart';
import '../model/gateway_settings_mode/gateway_settings_model.dart';
import '../model/profile/profile_model.dart';
import '../model/transaction_log/transaction_log_model.dart';
import '../model/two_fa/two_fa_info_model.dart';
import '../model/update_kyc/update_kyc_model.dart';
import '../model/wallets/remaing_model.dart';
import '../model/wallets/wallets_model.dart';
import '../utils/api_method.dart';
import '../utils/custom_snackbar.dart';
import '../utils/logger.dart';
import 'api_endpoint.dart';

final log = logger(ApiServices);

class ApiServices {
  static var client = http.Client();
  static Future<T?> apiService<T>(
    T Function(Map<String, dynamic>) fromJson,
    String apiEndpoint, {
    Map<String, dynamic>? body,
    String method = 'GET',
    int statusCode = 200,
    bool showResult = false,
    bool isBasic = false,
  }) async {
    try {
      Map<String, dynamic>? mapResponse;

      if (method == 'POST') {
        mapResponse = await ApiMethod(isBasic: isBasic).post(
          apiEndpoint,
          body ?? {},
          code: statusCode,
        );
      } else if (method == 'GET') {
        mapResponse = await ApiMethod(isBasic: isBasic).get(
          apiEndpoint,
          showResult: showResult,
        );
      }
      if (mapResponse != null) {
        T result = fromJson(mapResponse);
        // CommonSuccessModel messages = CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(messages.message.success.first.toString());
        return result;
      } else {
        return null;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from ApiService ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went wrong!');
      return null;
    }
  }

// App Settings Api
  static Future<AppSettingsModel?> appSettingsApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).get(
        ApiEndpoint.appSettingsURL,
        showResult: true,
      );
      if (mapResponse != null) {
        AppSettingsModel appSettingsModel =
            AppSettingsModel.fromJson(mapResponse);

        return appSettingsModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from App Settings Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

//!Login Api method
  static Future<LoginModel?> loginApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        ApiEndpoint.loginURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        LoginModel loginModel = LoginModel.fromJson(mapResponse);
        // CustomSnackBar.success(loginModel.message.success.first.toString());
        return loginModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from login api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //!Logout Api method
  static Future<CommonSuccessModel?> logOut() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.logOutURL,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel logOutModel =
            CommonSuccessModel.fromJson(mapResponse);
        return logOutModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from log out api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // send otp email
  static Future<CommonSuccessModel?> sendOTPEmailApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.sendOTPEmailURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel checkUserModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(checkUserModel.message.success.first.toString());
        return checkUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from send otp email service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // verify Email User Process
  static Future<CommonSuccessModel?> verifyEmailApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.verifyEmailURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel verifyEmailUserModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(
            verifyEmailUserModel.message.success.first.toString());
        return verifyEmailUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from send otp email service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

//! forgot password
  static Future<CheckRegisterUserModel?> checkRegisterApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        ApiEndpoint.checkRegisterURL,
        body,
        code: 200,
        duration: 25,
      );
      if (mapResponse != null) {
        CheckRegisterUserModel checkRegisterModel =
            CheckRegisterUserModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     checkRegisterModel.message.success.first.toString());
        return checkRegisterModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from check register user service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //! reset password api service
  static Future<ResetPasswordModel?> resetPasswordApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        ApiEndpoint.resetPasswordURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        ResetPasswordModel resetPasswordModel =
            ResetPasswordModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     resetPasswordModel.message.success.first.toString());
        return resetPasswordModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from reset Password api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  static Future<ResetPasswordModel?> resetPasswordPhoneApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        ApiEndpoint.resetPasswordSmsURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        ResetPasswordModel resetPasswordModel =
            ResetPasswordModel.fromJson(mapResponse);

        return resetPasswordModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from reset password phone api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }
//!Register Api Service

  // send otp email
  static Future<CommonSuccessModel?> sendRegisterOTPEmailApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        ApiEndpoint.sendRegisterEmailOTPURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel checkUserModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(checkUserModel.message.success.first.toString());
        return checkUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from send register otp email service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // verify
  static Future<CommonSuccessModel?> registerVerifyOTPEmailApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        ApiEndpoint.verifyRegisterEmailOTPURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel checkUserModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(checkUserModel.message.success.first.toString());
        return checkUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from verify register otp email service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

// check register exist
  static Future<CheckUserModel?> checkUserApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        ApiEndpoint.checkingUserURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CheckUserModel checkUserModel = CheckUserModel.fromJson(mapResponse);
        // CustomSnackBar.success(checkUserModel.message.success.first.toString());
        return checkUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from check user  service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // verify register Email User Process
  static Future<CommonSuccessModel?> verifyRegisterEmailApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        ApiEndpoint.verifyBeforeRegisterEmailOTPURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel verifyEmailUserModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(
            verifyEmailUserModel.message.success.first.toString());
        return verifyEmailUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from send otp email service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // basic data get
  static Future<BasicDataModel?> basicData() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).get(
        ApiEndpoint.basicDataURL,
        code: 200,
      );
      if (mapResponse != null) {
        BasicDataModel basicDataModel = BasicDataModel.fromJson(mapResponse);

        return basicDataModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from basic data Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // registration with kyc
  static Future<RegistrationWithKycModel?> registrationApi({
    required Map<String, String> body,
    required List<String> pathList,
    required List<String> fieldList,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).multipartMultiFile(
        ApiEndpoint.registerURL,
        body,
        showResult: true,
        fieldList: fieldList,
        pathList: pathList,
      );
      if (mapResponse != null) {
        RegistrationWithKycModel registrationModel =
            RegistrationWithKycModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     registrationModel.message.success.first.toString());
        return registrationModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from registration api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // verify register Phone User Process
  static Future<CommonSuccessModel?> verifyRegisterPhoneApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        ApiEndpoint.verifyRegisterPhoneOTPURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from send otp Phone service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
          'Something went Wrong! in verify Phone  checkUserModel');
      return null;
    }
    return null;
  }

//!  dashboard Api method

  static Future<DashboardModel?> dashboardApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.dashboardURL,
        code: 200,
      );
      if (mapResponse != null) {
        DashboardModel dashboardModel = DashboardModel.fromJson(mapResponse);

        return dashboardModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Dashboard Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  /// get notification process
  static Future<NotificationModel?> getNotificationAPi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.notificationsURL,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        NotificationModel modelData = NotificationModel.fromJson(mapResponse);

        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from all recipient info api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //! profile section started

  static Future<ProfileModel?> profileAPi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.dashboardURL,
        code: 200,
      );
      if (mapResponse != null) {
        ProfileModel profileModel = ProfileModel.fromJson(mapResponse);

        return profileModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from profile Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //! update profile APi

//  update profile  Api method
  static Future<CommonSuccessModel?> updateProfileWithoutImageApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.updateProfileApi, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel updateProfileModel =
            CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     updateProfileModel.message.success.first.toString());
        return updateProfileModel;
      }
    } catch (e) {
      log.e('err from update profile api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // with img update profile api
  static Future<CommonSuccessModel?> updateProfileWithImageApi(
      {required Map<String, String> body, required String filepath}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).multipart(
          ApiEndpoint.updateProfileApi, body, filepath, 'image',
          code: 200);

      if (mapResponse != null) {
        CommonSuccessModel profileUpdateModel =
            CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     profileUpdateModel.message.success.first.toString());
        return profileUpdateModel;
      }
    } catch (e) {
      log.e('err from profile update api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //!drawer
  static Future<CommonSuccessModel?> passwordUpdateApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.passwordUpdate, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel updateProfileModel =
            CommonSuccessModel.fromJson(mapResponse);

        return updateProfileModel;
      }
    } catch (e) {
      log.e('err from update password api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //manual payment confirm Api method
  static Future<CommonSuccessModel?> manualPaymentConfirmApi({
    required Map<String, String> body,
    required List<String> pathList,
    required List<String> fieldList,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).multipartMultiFile(
          ApiEndpoint.sendMoneyManualConfirmURL, body,
          fieldList: fieldList, pathList: pathList, code: 200);

      if (mapResponse != null) {
        CommonSuccessModel sendMoneyManualConfirmModel =
            CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     sendMoneyManualConfirmModel.message.success.first.toString());
        return sendMoneyManualConfirmModel;
      }
    } catch (e) {
      log.e('err from manual payment Confirm api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // check user api
  static Future<CommonSuccessModel?> checkUserExistApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.checkUserExistURL,
        body,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardUnBlockModel =
            CommonSuccessModel.fromJson(mapResponse);

        return cardUnBlockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from check user exist api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // // check user api
  // static Future<CheckUserWithQrCodeModel?> checkUserWithQrCodeApi(
  //     {required Map<String, dynamic> body}) async {
  //   Map<String, dynamic>? mapResponse;
  //   try {
  //     mapResponse = await ApiMethod(isBasic: false).post(
  //       ApiEndpoint.checkUserWithQeCodeURL,
  //       body,
  //       code: 200,
  //       showResult: false,
  //     );
  //     if (mapResponse != null) {
  //       CheckUserWithQrCodeModel checkUserWithQrCodeModel =
  //           CheckUserWithQrCodeModel.fromJson(mapResponse);
  //
  //       return checkUserWithQrCodeModel;
  //     }
  //   } catch (e) {
  //     log.e(
  //         '🐞🐞🐞 err from check user with qr code api service ==> $e 🐞🐞🐞');
  //     CustomSnackBar.error(Strings.somethingWentWrong);
  //     return null;
  //   }
  //   return null;
  // }

  // check user api

  /// money out all process
  static Future<WithdrawInfoModel?> withdrawInfoAPi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.withdrawInfoURL,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        WithdrawInfoModel addMoneyPaymentGatewayModel =
            WithdrawInfoModel.fromJson(mapResponse);

        return addMoneyPaymentGatewayModel;
      }
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from Money Out Payment Gateway api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //  money out manual insert  Api method
  static Future<WithdrawManualInsertModel?> withdrawManualInsertApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.withdrawInsertURL, body, code: 200);
      if (mapResponse != null) {
        WithdrawManualInsertModel sendMoneyManualInsertModel =
            WithdrawManualInsertModel.fromJson(mapResponse);
        // // CustomSnackBar.success(
        //     sendMoneyManualInsertModel.message.success.first.toString());
        return sendMoneyManualInsertModel;
      }
    } catch (e) {
      log.e('err from money out manual api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //  withdraw automatic flutterwave insert  Api method
  static Future<WithdrawFlutterWaveInsertModel?>
      withdrawAutomaticFluuerwaveInsertApi(
          {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.withdrawInsertURL, body, code: 200);
      if (mapResponse != null) {
        WithdrawFlutterWaveInsertModel sendMoneyManualInsertModel =
            WithdrawFlutterWaveInsertModel.fromJson(mapResponse);
        // // CustomSnackBar.success(
        //     sendMoneyManualInsertModel.message.success.first.toString());
        return sendMoneyManualInsertModel;
      }
    } catch (e) {
      log.e('err from money out manual api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //  withdraw automatic flutterwave insert  Api method
  static Future<CommonSuccessModel?> withdrawFluuerwaveConfirmApiApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.automaticWithdrawConfirmURL, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel sendMoneyManualInsertModel =
            CommonSuccessModel.fromJson(mapResponse);
        // // CustomSnackBar.success(
        //     sendMoneyManualInsertModel.message.success.first.toString());
        return sendMoneyManualInsertModel;
      }
    } catch (e) {
      log.e('err from money out manual api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //  withdraw automatic flutterwave insert  Api method
  static Future<FlutterwaveAccountCheckModel?> flutterwaveAccountCheackerApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.checkFlutterwaveAccountURL, body, code: 200);
      if (mapResponse != null) {
        FlutterwaveAccountCheckModel sendMoneyManualInsertModel =
            FlutterwaveAccountCheckModel.fromJson(mapResponse);
        // // CustomSnackBar.success(
        //     sendMoneyManualInsertModel.message.success.first.toString());
        return sendMoneyManualInsertModel;
      }
    } catch (e) {
      log.e('err from money out manual api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //manual payment confirm Api method
  static Future<CommonSuccessModel?> manualPaymentConfirmApiForWithdraw({
    required Map<String, String> body,
    required List<String> pathList,
    required List<String> fieldList,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).multipartMultiFile(
          ApiEndpoint.manualWithdrawConfirmURL, body,
          fieldList: fieldList, pathList: pathList, code: 200);

      if (mapResponse != null) {
        CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(modelData.message.success.first.toString());
        return modelData;
      }
    } catch (e) {
      log.e('err from manual payment money out Confirm api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  /// transaction
  static Future<TransactionLogModel?> getTransactionLogAPi(
      {String type = ""}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.transactionLogURL + type,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        TransactionLogModel modelData =
            TransactionLogModel.fromJson(mapResponse);

        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from all recipient info api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // refund
  static Future<CommonSuccessModel?> refundApi(
      {required Map<String, dynamic> body, required String endPoint}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(endPoint, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel sendMoneyManualInsertModel =
        CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(
            sendMoneyManualInsertModel.message.success.first.toString());
        return sendMoneyManualInsertModel;
      }
    } catch (e) {
      log.e('err from refund api service ==> $e');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  //
  static Future<UpdateKycModel?> getUserKYCInfo() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.merchantKycURL,
        code: 200,
      );
      if (mapResponse != null) {
        UpdateKycModel basicDataModel = UpdateKycModel.fromJson(mapResponse);

        return basicDataModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from update kyc data Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // with img update profile api
  static Future<CommonSuccessModel?> updateKYCApi({
    required Map<String, String> body,
    required List<String> pathList,
    required List<String> fieldList,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).multipartMultiFile(
        ApiEndpoint.updateKYCApi,
        body,
        showResult: true,
        fieldList: fieldList,
        pathList: pathList,
      );
      if (mapResponse != null) {
        CommonSuccessModel registrationModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(
            registrationModel.message.success.first.toString());
        return registrationModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from update kyc api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  /// two Fa Security Api Process

  static Future<TwoFaInfoModel?> getTwoFAInfoAPi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.twoFAInfoURL,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        TwoFaInfoModel modelData = TwoFaInfoModel.fromJson(mapResponse);

        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from twofa api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  static Future<CommonSuccessModel?> twoFAVerifyAPi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.twoFAVerifyURL, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(modelData.message.success.first.toString());
        return modelData;
      }
    } catch (e) {
      log.e('err from twoFAVerify api service ==> $e');
      // CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // check user sms verify submit
  static Future<CommonSuccessModel?> smsVerifyApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.smsVerifyURL,
        body,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(modelData.message.success.first);
        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from send money api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // delete account
  static Future<CommonSuccessModel?> deleteAccountApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.deleteAccountURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel checkUserModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(checkUserModel.message.success.first.toString());
        return checkUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from delete account service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // send otp email
  static Future<CommonSuccessModel?> sendForgotOTPEmailApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.sendForgotOTPEmailURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel checkUserModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(checkUserModel.message.success.first.toString());
        return checkUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from send otp email service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // verify Email User Process
  static Future<CommonSuccessModel?> verifyForgotEmailApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.verifyForgotOTPEmailURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel verifyEmailUserModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(
            verifyEmailUserModel.message.success.first.toString());
        return verifyEmailUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from send otp email service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // Receive Money api
  static Future<ReceiveMoneyModel?> receiveMoneyApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.receiveMoneyURL,
        code: 200,
        showResult: true,
      );
      if (mapResponse != null) {
        ReceiveMoneyModel receiveMoneyModel =
            ReceiveMoneyModel.fromJson(mapResponse);

        return receiveMoneyModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from receive money api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  static Future<ApiKeyModel?> apiKeyApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.apiKeyURL,
        code: 200,
      );
      if (mapResponse != null) {
        ApiKeyModel apikeyModel = ApiKeyModel.fromJson(mapResponse);

        return apikeyModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from apikey  Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // production mode process
  static Future<CommonSuccessModel?> productionModeApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.apiKeyProductionURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel productionModeModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(
            productionModeModel.message.success.first.toString());
        return productionModeModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from production mode model  service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  static Future<GatewaySettingsModel?> gatewaySettingsApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.gatewaySettingsURL,
        code: 200,
      );
      if (mapResponse != null) {
        GatewaySettingsModel gatewaySettingsModel =
            GatewaySettingsModel.fromJson(mapResponse);

        return gatewaySettingsModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from gateway Settings  Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // update wallet status  process
  static Future<CommonSuccessModel?> walletBalanceStatusApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.walletBalanceStatusURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(modelData.message.success.first.toString());
        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from wallet balance status  service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  /// get flutter wave banks list
  static Future<FlutterWaveBanksModel?> getFlutterWaveBanksApi(
    String trx,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.flutterWaveBanksURL}$trx&&lang=${GetStorage().read('selectedLanguage')}",
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        FlutterWaveBanksModel result =
            FlutterWaveBanksModel.fromJson(mapResponse);

        return result;
      }
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from get flutter wave banks list api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // update virtual card status  process
  static Future<CommonSuccessModel?> virtualCardStatusApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.virtualCardStatusURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(modelData.message.success.first.toString());
        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from virtual card status  service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // update master card status  process
  static Future<CommonSuccessModel?> masterCardStatusApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.masterCardStatusURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(modelData.message.success.first.toString());
        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from master card status  service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // update key  process
  static Future<CommonSuccessModel?> updateKeyApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.updateKeyURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(modelData.message.success.first.toString());
        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from update key status  service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // api key create process
  static Future<CommonSuccessModel?> createApiKeyApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.apiKeyCreateURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from api key create service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // delete key  process
  static Future<CommonSuccessModel?> deleteApiKeyApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.apiKeyDeleteURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from api key delete service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Strings.somethingWentWrong);
      return null;
    }
    return null;
  }

  // Wallet Info
  static Future<WalletsModel?> walletsInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.walletsURL,
        showResult: true,
      );
      if (mapResponse != null) {
        WalletsModel walletsModel = WalletsModel.fromJson(mapResponse);

        return walletsModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Wallets Info Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! Wallets Info Api');
      return null;
    }
    return null;
  }

  // remaing balance api service

  //strowallet card transaction method
  static Future<RemainingBalanceModel?> remainingBalanceAPi(
      String type,
      String attribute,
      String senderAmount,
      String currencyCode,
      int id) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.remainingBalanceURL}$type&attribute=$attribute&sender_amount=$senderAmount&currency_code=$currencyCode&charge_id=$id",
        showResult: true,
      );
      RemainingBalanceModel remainingBalanceModel =
          RemainingBalanceModel.fromJson(mapResponse!);

      return remainingBalanceModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from remaining balance Api service ==> $e 🐞🐞🐞');
      // CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }

  ///* Two fa submit process api
  static Future<CommonSuccessModel?> twoFaSubmitApiProcess(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.twoFaSubmitURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Two fa submit process api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
          'Something went Wrong! in Two fa submit process api services');
      return null;
    }
    return null;
  }

}
