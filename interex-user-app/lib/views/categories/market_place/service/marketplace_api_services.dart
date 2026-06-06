
import 'package:get_storage/get_storage.dart';

import '../../../../backend/model/common/common_success_model.dart';
import '../../../../backend/services/api_endpoint.dart';
import '../../../../backend/utils/api_method.dart';
import '../../../../backend/utils/custom_snackbar.dart';
import '../../../../backend/utils/logger.dart';
import '../model/marketplace_buy_confirm.model.dart';
import '../model/marketplace_buy_model.dart';
import '../model/marketplace_info_model.dart';
// import '../model/marketplace_transaction_model.dart';

final log = logger(MarketplaceApiServices);

class MarketplaceApiServices {
  ///* Marketplace get info process api
  static Future<MarketplaceInfoModel?> getMarketplaceProcessApi(
    String amount,
    String rate,
    currencyId,
  {
    required bool isFilter,
    required String page,
        bool isDeepLink = false,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
         "${ApiEndpoint.marketplaceListURL}?lang=${GetStorage().read('selectedLanguage')}&page=$page",
        code: 200,
      );
      if (mapResponse != null) {
        MarketplaceInfoModel result =
            MarketplaceInfoModel.fromJson(mapResponse);

        return result;
      }
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from Marketplace get info process api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in MarketplaceInfoModel');
      return null;
    }
    return null;
  }

  // ///* Latest transaction get info process api
  // static Future<MarketplaceLatestTransactionModel?>
  //     getLatestTransactionProcessApi() async {
  //   Map<String, dynamic>? mapResponse;
  //   try {
  //     mapResponse = await ApiMethod(isBasic: false).get(
  //       ApiEndpoint.marketplaceTransactionsListURL,
  //       code: 200,
  //     );
  //     if (mapResponse != null) {
  //       MarketplaceLatestTransactionModel result =
  //           MarketplaceLatestTransactionModel.fromJson(mapResponse);
  //
  //       return result;
  //     }
  //   } catch (e) {
  //     log.e(
  //         '🐞🐞🐞 err from Latest transaction get info process api service ==> $e 🐞🐞🐞');
  //     CustomSnackBar.error(
  //         'Something went Wrong! in MarketplaceLatestTransactionModel');
  //     return null;
  //   }
  //   return null;
  // }

  ///*  Marketplace buy process api
  static Future<MarketplaceBuyModel?> marketplaceBuyProcessApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.marketplaceBuyURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        MarketplaceBuyModel result = MarketplaceBuyModel.fromJson(mapResponse);
        return result;
      }
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from Marketplace buy process api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  ///*  Marketplace buy confirm process api
  static Future<MarketplaceBuyConfirmModel?> marketplaceBuyConfirmProcessApi(
      {required Map<String, dynamic> body})
  async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.marketplaceBuyConfirmURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        MarketplaceBuyConfirmModel result =
            MarketplaceBuyConfirmModel.fromJson(mapResponse);
        return result;
      }
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from Marketplace confirm process api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  ///*  Marketplace evidence submit process api
  static Future<CommonSuccessModel?> marketplaceEvidenceSubmitProcessApi({
    required Map<String, String> body,
    required List<String> pathList,
    required List<String> fieldList,
  })
  async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).multipartMultiFile(
        ApiEndpoint.marketplaceEvidenceSubmitURL,
        body,
        code: 200,
        fieldList: fieldList,
        pathList: pathList,
      );
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        return result;
      }
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from Marketplace evidence submit process api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }
}
