import 'package:qrpay/backend/model/common/common_success_model.dart';

import '../../../backend/services/api_endpoint.dart';
import '../../../backend/utils/api_method.dart';
import '../../../backend/utils/custom_snackbar.dart';
import '../../../backend/utils/logger.dart';
import '../model/verify_pin_model.dart';

final log = logger(PinSetupServices);

class PinSetupServices {
  //!PinVerifyModel Api method
  static Future<PinVerifyModel?> pinVerifyApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.verifyPinURL, body, code: 200);
      if (mapResponse != null) {
        final PinVerifyModel loginModel = PinVerifyModel.fromJson(mapResponse);
        // CustomSnackBar.success(loginModel.message.success.first.toString());
        return loginModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from PinVerifyModel api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in PinVerifyModel');
      return null;
    }
    return null;
  }

  //!Pin Setup Api method
  static Future<CommonSuccessModel?> pinSetUpApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.setupPinURL, body, code: 200);
      if (mapResponse != null) {
        final CommonSuccessModel loginModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        CustomSnackBar.success(loginModel.message.success.first.toString());
        return loginModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from pinSetUpApi service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in PinSetUpModel');
      return null;
    }
    return null;
  }

  //!Pin update Api method
  static Future<CommonSuccessModel?> pinUpdateApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.upDatePinURL, body, code: 200);
      if (mapResponse != null) {
        final CommonSuccessModel loginModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        CustomSnackBar.success(loginModel.message.success.first.toString());
        return loginModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from pinUpdateApi service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in PinUpdateModel');
      return null;
    }
    return null;
  }
}
