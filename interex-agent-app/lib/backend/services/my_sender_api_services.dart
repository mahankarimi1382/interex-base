// ignore_for_file: dead_code

import 'package:http/http.dart' as http;

import '../model/common/common_success_model.dart';
import '../model/recipient/common/saved_recipient_info_model.dart';
import '../model/recipient/my_recipient/my_recipient_edit_model.dart';
import '../model/recipient/my_sender/my_sender_recipient_list_model.dart';
import '../model/recipient_models/check_recipient_model.dart';
import '../utils/api_method.dart';
import '../utils/custom_snackbar.dart';
import '../utils/logger.dart';
import 'api_endpoint.dart';

final log = logger(MySenderRecipientApiServices);

class MySenderRecipientApiServices {
  static var client = http.Client();
  static Future<MySenderRecipientListModel?> myRecipientAPi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.senderRecipientListURL,
        code: 200,
        showResult: false,
      );
      MySenderRecipientListModel modelData =
          MySenderRecipientListModel.fromJson(mapResponse!);

      return modelData;
    } catch (e) {
      log.e('🐞🐞🐞 err from My recipient info api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  static Future<CommonSuccessModel?> myRecipientStoreApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.senderRecipientStoreURL, body, code: 200);
      CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse!);

      return result;
    } catch (e) {
      log.e('err from My recipient store api service ==> $e');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  static Future<CommonSuccessModel?> myRecipientUpdateApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.senderRecipientUpdateURL, body, code: 200);
      CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse!);

      return modelData;
    } catch (e) {
      log.e('err from receiver recipient update api service ==> $e');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  static Future<CommonSuccessModel?> myRecipientDeleteApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false)
          .post(ApiEndpoint.senderRecipientDeleteURL, body, code: 200);
      CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse!);
      // CustomSnackBar.success(modelData.message.success.first.toString());
      return modelData;
    } catch (e) {
      log.e('err from my recipient delete api service ==> $e');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  static Future<RecipientEditModel?> receiverRecipientEditAPi(
      {required String id}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.senderRecipientEditURL + id,
        code: 200,
        showResult: false,
      );
      RecipientEditModel modelData = RecipientEditModel.fromJson(mapResponse!);

      return modelData;
    } catch (e) {
      log.e('🐞🐞🐞 err from all receiver recipient api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  static Future<CheckRecipientModel?> checkRecipientApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.recipientCheckUserURL,
        body,
        code: 200,
        duration: 25,
      );
      if (mapResponse != null) {
        CheckRecipientModel checkRegisterModel =
            CheckRecipientModel.fromJson(mapResponse);
        CustomSnackBar.success(
            checkRegisterModel.message.success.first.toString());
        return checkRegisterModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from check recipient user service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in check recipient user');
      return null;
    }
    return null;
  }

  static Future<SaveRecipientInfoModel?> saveRecipientInfoAPi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.senderRecipientInfoURL,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        SaveRecipientInfoModel modelData =
            SaveRecipientInfoModel.fromJson(mapResponse);

        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from all recipient info api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in all recipient info Api');
      return null;
    }
    return null;
  }
}
