import 'package:get/get.dart';

import '../../../../../backend/model/common/common_success_model.dart';
import '../../../../../backend/services/api_services.dart';
import '../model/card_details_model_cardyfie.dart';
import '../services/cardyfie_api_services.dart';
import 'cardyfie_info_controller.dart';

class CardyfieDetailsController extends GetxController {
  RxBool isSelected = false.obs;
  RxBool isShowSensitive = false.obs;
  RxString cardPlan = "".obs;
  RxString cardCVC = "".obs;
  final cardyfieController = Get.put(VirtualCardyfieCardController());

  RxString isStatus = "ENABLED".obs;
  @override
  void onInit() {
    getCardDetailsData();
    super.onInit();
  }

  late CommonSuccessModel _cardActiveModel;
  CommonSuccessModel get cardActiveModel => _cardActiveModel;

  void cardToggle() {
    // Toggle the UI switch value
    isSelected.value = !isSelected.value;

    // Update the status string
    if (isSelected.value) {
      isStatus.value = "FREEZE";
    } else {
      isStatus.value = "ENABLED";
    }

    // Call the API
    cardFreezeUnFreezeApi();
  }

  ///>>>>>>>>>> get details data
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isCardStatusLoading = false.obs;
  bool get isCardStatusLoading => _isCardStatusLoading.value;
  // Card Details Method
  late CardDetailsModelCardyfie _cardDetailsModelCardyfie;
  CardDetailsModelCardyfie get cardDetailsModelCardyfie =>
      _cardDetailsModelCardyfie;

  Future<CardDetailsModelCardyfie> getCardDetailsData() async {
    _isLoading.value = true;
    update();

    await CardyfieApiServices.cardyfieCardDetailsApi(
          cardyfieController.cardyfieCardUIId.value,
        )
        .then((value) {
          _cardDetailsModelCardyfie = value!;

          update();
        })
        .catchError((onError) {
          log.e(onError);
          _isLoading.value = false;
          update();
        });

    _isLoading.value = false;
    update();
    return _cardDetailsModelCardyfie;
  }

  Future<CommonSuccessModel> cardFreezeUnFreezeApi() async {
    _isCardStatusLoading.value = true;

    Map<String, dynamic> inputBody = {
      'card_id': cardyfieController.cardyfieCardUIId.value,
      'status': isStatus.value,
    };
    try {
      final value = await CardyfieApiServices.cardyfieFreezeApi(
        body: inputBody,
      );
      _cardActiveModel = value!;
      await getCardDetailsData(); // refresh data
    } catch (e) {
      log.e(e);
    } finally {
      _isCardStatusLoading.value = false;
    }

    return _cardActiveModel;
  }
}
