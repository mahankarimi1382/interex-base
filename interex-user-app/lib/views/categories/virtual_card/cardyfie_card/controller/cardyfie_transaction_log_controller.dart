import 'package:get/get.dart';

import '../../../../../backend/services/payment_link_services.dart';
import '../model/card_transaction_model_cardyfie.dart';
import '../services/cardyfie_api_services.dart';
import 'cardyfie_info_controller.dart';

class CardyfieTransactionLogController extends GetxController {
  final controller = Get.put(VirtualCardyfieCardController());

  @override
  void onInit() {
    getCardTransactionHistory();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late CardTransactionModelCardyfie _cardTransactionModelCardyfie;
  CardTransactionModelCardyfie get cardTransactionModelCardyfie =>
      _cardTransactionModelCardyfie;

  Future<CardTransactionModelCardyfie> getCardTransactionHistory() async {
    _isLoading.value = true;
    update();

    await CardyfieApiServices.cardyfieCardTransactionApi(
          controller.cardyfieCardUIId.value,
        )
        .then((value) {
          _cardTransactionModelCardyfie = value!;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _cardTransactionModelCardyfie;
  }
}
