import '../../../../backend/model/common/common_success_model.dart';
import '../../../../backend/utils/api_method.dart';
// import '../../../../backend/utils/custom_snackbar.dart';
import '../../../../backend/utils/logger.dart';
import '../../../../backend/services/api_endpoint.dart';
import '../model/my_trade_model.dart';
import '../model/trade_edit_info_model.dart';
import '../model/trade_submit_model.dart';

final log = logger(TradeApiServices);

mixin TradeApiServices {
  ///*
  Future<MyTradeModel?> getTradeListInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get(ApiEndpoint.tradeListURL, code: 200);
      if (mapResponse != null) {
        MyTradeModel result = MyTradeModel.fromJson(mapResponse);

        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from  Get Trade List Info Api service ==> $e 🐞🐞🐞');
      // CustomSnackBar.error('Something went Wrong! in User List Model');
      return null;
    }
    return null;
  }

  ///*
  Future<TradeSubmitModel?> tradeSubmitProcessApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.tradeSubmitURL, body, code: 200, showError: false);
      if (mapResponse != null) {
        TradeSubmitModel result = TradeSubmitModel.fromJson(mapResponse);
        // CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from Trade Submit Process Api service ==> $e');
      // CustomSnackBar.error('Something went Wrong! User Search Model');
      return null;
    }
    return null;
  }

  ///*
  Future<TradeEditInfoModel?> tradeEditInfoProcessApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.tradeEditURL, body, code: 200, showError: false);
      if (mapResponse != null) {
        TradeEditInfoModel result = TradeEditInfoModel.fromJson(mapResponse);
        // CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from Trade Edit Info Process Api service ==> $e');
      // CustomSnackBar.error('Something went Wrong! User Search Model');
      return null;
    }
    return null;
  }

  ///*
  Future<CommonSuccessModel?> tradeCloseProcessApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.tradeCloseURL, body, code: 200, showError: false);
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from Trade Close Process Api service ==> $e');
      // CustomSnackBar.error('Something went Wrong! User Search Model');
      return null;
    }
    return null;
  }

  ///*
  Future<CommonSuccessModel?> tradeUpdateProcessApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.tradeUpdateURL, body, code: 200, showError: false);
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from Trade Update Process Api service ==> $e');
      // CustomSnackBar.error('Something went Wrong! User Search Model');
      return null;
    }
    return null;
  }
}
