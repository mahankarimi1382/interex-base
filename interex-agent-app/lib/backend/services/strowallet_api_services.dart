// ignore_for_file: file_names

import '../model/categories/virtual_card/strowallet_models/charge_strowallet_model.dart';
import '../model/categories/virtual_card/strowallet_models/strowallet_card_model.dart';
import '../model/categories/virtual_card/strowallet_models/strowallet_details_controller.dart';
import '../model/categories/virtual_card/strowallet_models/strowallet_transaction_model.dart';
import '../model/common/common_success_model.dart';
import '../utils/api_method.dart';
import '../utils/custom_snackbar.dart';
import 'api_endpoint.dart';

class StrowalletApiServices {
  // strowallet card info api
  static Future<StrowalletCardModel?> strowalletCardInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get(ApiEndpoint.strowalletCardURL);
      final StrowalletCardModel strowalletCardInfoModel =
          StrowalletCardModel.fromJson(mapResponse!);

      return strowalletCardInfoModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from strowallet card info api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }

  // Card details api
  static Future<StrowalletCardDetailsModel?> strowalletCardDetailsApi(
    String id,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get(ApiEndpoint.strowalletCardDetailsURL + id);
      final StrowalletCardDetailsModel cardDetailsModel =
          StrowalletCardDetailsModel.fromJson(mapResponse!);

      return cardDetailsModel;
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from strowallet card details api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }

  //strowallet card inactive api
  static Future<CommonSuccessModel?> strowalletInactiveApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.strowalletCardUnBlockURL, body, code: 200);
      final CommonSuccessModel cardUnBlockModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );

      return cardUnBlockModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from inactive api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }

  // strowallet card active api
  static Future<CommonSuccessModel?> strowalletpeActiveApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.strowalletCardBLockURL, body, code: 200);
      final CommonSuccessModel cardUnBlockModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );

      return cardUnBlockModel;
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from strowallet card active Api api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }

  //strowallet card transaction method
  static Future<StrowalletCardTransactionModel?> strowalletCardTransactionApi(
    String cardId,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.strowalletCardTransactionURL}$cardId",
        showResult: true,
      );
      final StrowalletCardTransactionModel cardTransactionModel =
          StrowalletCardTransactionModel.fromJson(mapResponse!);

      return cardTransactionModel;
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from my strowallet Card Transaction Api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }

  // Card Fund Api Method
  static Future<CommonSuccessModel?> strowalletCardFundApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.strowalletCardFundURL, body, showResult: true);
      final CommonSuccessModel cardFundModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );
      // CustomSnackBar.success(cardFundModel.message.success.first.toString());
      return cardFundModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from strowallet Fund api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in strowallet Fund Model');
      return null;
    }
  }

  static Future<StrowalletChargeModel?> strollerCardChargesApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get(ApiEndpoint.strowalletCardChargeURL, showResult: true);
      final StrowalletChargeModel cardChargesModel =
          StrowalletChargeModel.fromJson(mapResponse!);
      return cardChargesModel;
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from sudo strowallet Charges Api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }

  // strowallet create card Api method
  static Future<CommonSuccessModel?> strowalletBuyCardApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.strowalletBuyCardURL, body, showResult: true);
      final CommonSuccessModel cardUnblockModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );
      CustomSnackBar.success(cardUnblockModel.message.success.first.toString());
      return cardUnblockModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from strowallet card buy api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }

  // strowallet card make or remove default api
  static Future<CommonSuccessModel?> strowalletCardMakeOrRemoveDefaultApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.strowalletCardMakeOrRemoveDefaultFundURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        final CommonSuccessModel result = CommonSuccessModel.fromJson(
          mapResponse,
        );

        return result;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from card strowallet Card Make Or Remove Default Api api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }
}
