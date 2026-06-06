

import 'package:get/get.dart';
import 'package:qrpaypro/language/language_controller.dart';

import '../../../../../backend/model/common/common_success_model.dart';
import '../../../../../backend/services/api_endpoint.dart';
import '../../../../../backend/utils/api_method.dart';
import '../../../../../backend/utils/custom_snackbar.dart';
import '../../../../../language/english.dart';
import '../model/card_details_model_cardyfie.dart';
import '../model/card_transaction_model_cardyfie.dart';

class CardyfieApiServices {
    // card details api
  static Future<CardDetailsModelCardyfie?> cardyfieCardDetailsApi(
    String id,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.cardyfieCardDetails + id,
        code: 200,
        showResult: false,
      );
      CardDetailsModelCardyfie cardDetailsModel =
          CardDetailsModelCardyfie.fromJson(mapResponse!);

      return cardDetailsModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from cardyfie card details api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
  }
    //cardyfie card inactive api
  static Future<CommonSuccessModel?> cardyfieFreezeApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.cardyfieFreezeUnfreeze,
        body,
        code: 200,
        showResult: false,
      );
      CommonSuccessModel cardUnBlockModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );

      return cardUnBlockModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from inactive api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
  }


  //cardyfie card transaction method
  static Future<CardTransactionModelCardyfie?> cardyfieCardTransactionApi(
    String cardId,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get("${ApiEndpoint.cardyfieTransactionCard}$cardId", showResult: true);
      CardTransactionModelCardyfie cardTransactionModel =
          CardTransactionModelCardyfie.fromJson(mapResponse!);

      return cardTransactionModel;
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from my cardyfie Card Transaction Api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }



}
