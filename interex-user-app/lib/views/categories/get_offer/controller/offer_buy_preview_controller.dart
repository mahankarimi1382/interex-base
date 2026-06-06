
import 'package:flutter/services.dart';

import '../../../../backend/model/common/common_success_model.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../congratulation_screen.dart';
import '../model/offer_buy_confirm_model.dart';
import '../model/offer_buy_model.dart';
import '../service/get_offer_api_services.dart';
import '../widget/offer_evidance_image_picker.dart';
class OfferBuyPreviewController extends GetxController {
  /// >>> Rate
  RxDouble sellAmount = 0.0.obs;
  RxString sellCurrency = ''.obs;
  RxDouble rateAmount = 0.0.obs;
  RxString rateCurrency = ''.obs;
  RxString targetId = ''.obs;
  RxString trxID = ''.obs;

  /// >>> set value for payment method
  RxString selectPaymentGateway = ''.obs;
  RxString selectPaymentGatewayId = ''.obs;

  /// >>>  user info edit process
  String get onUserInfoEdit => '';

  /// >>> Transactions Summary
  RxString subTotal = ''.obs;
  RxString charge = ''.obs;
  RxString willPay = ''.obs;
  RxString sellerWillPay = ''.obs;

  /// >>> get seller information
  RxString sellerName = ''.obs;
  RxBool isVerified = false.obs;

  /// >>> set value for loading buying items button
  RxInt loadingIndex = (-1).obs;

  /// >>> set variable for dynamic input fields
  List<TextEditingController> inputFieldControllers = [];
  RxList inputFields = [].obs;
  List<String> listImagePath = [];
  List<String> listFieldName = [];
  RxBool hasFile = false.obs;

  /// >>>  on confirm
  Future<OfferBuyConfirmModel> get onConfirm => offerBuyConfirmProcessApi();
  Future<CommonSuccessModel> get onSubmit => offerEvidenceProcessApi();

  /// >> set loading process & Model
  final _isBuyLoading = false.obs;
  final _isBuyConfirmLoading = false.obs;
  final _isSubmitLoading = false.obs;
  late OfferBuyModel _offerBuyModel;
  late OfferBuyConfirmModel _offerBuyConfirmModel;
  late CommonSuccessModel _offerEvidenceModel;

  /// >> get loading process & Model
  bool get isBuyLoading => _isBuyLoading.value;
  bool get isBuyConfirmLoading => _isBuyConfirmLoading.value;
  bool get isSubmitLoading => _isSubmitLoading.value;
  OfferBuyModel get offerBuyModel => _offerBuyModel;
  OfferBuyConfirmModel get offerBuyConfirmModel => _offerBuyConfirmModel;
  CommonSuccessModel get offerEvidenceModel => _offerEvidenceModel;

  ///* offer buy api process
  Future<OfferBuyModel> offerBuyProcessApi(String targetId) async {
    _isBuyLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      'target': targetId,
    };
    await OfferApiServices.offerBuyProcessApi(body: inputBody).then((value) {
      _offerBuyModel = value!;
      _setDataForPreviewScreen();
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isBuyLoading.value = false;
    update();
    return _offerBuyModel;
  }

  ///* Offer buy confirm api process
  Future<OfferBuyConfirmModel> offerBuyConfirmProcessApi() async {
    _isBuyConfirmLoading.value = true;
    inputFields.clear();
    listImagePath.clear();
    listFieldName.clear();
    inputFieldControllers.clear();
    update();
    Map<String, String> inputBody = {
      'target': targetId.value,
      'gateway_id': selectPaymentGatewayId.value,
    };
    await OfferApiServices.offerConfirmProcessApi(body: inputBody)
        .then((value) {
      _offerBuyConfirmModel = value!;
      trxID.value = _offerBuyConfirmModel.data.trxId;
      _getDynamicInputFields(_offerBuyConfirmModel.data.paymentFields);

      Get.toNamed(Routes.offerEvidenceSubmitScreen);

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isBuyConfirmLoading.value = false;
    update();
    return _offerBuyConfirmModel;
  }

  ///* Offer evidence submit api process
  Future<CommonSuccessModel> offerEvidenceProcessApi() async {
    _isSubmitLoading.value = true;
    update();
    Map<String, String> inputBody = {
      'trx_id': trxID.value,
    };
    final data = _offerBuyConfirmModel.data.paymentFields;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].name] = inputFieldControllers[i].text;
      }
    }

    await OfferApiServices.offerEvidenceSubmitProcessApi(
      body: inputBody,
      fieldList: listFieldName,
      pathList: listImagePath,
    ).then((value) {
      _offerEvidenceModel = value!;
      Get.to(
        () => CongratulationScreen(
          route: Routes.bottomNavBarScreen,
          subTitle: _offerEvidenceModel.message.success.first,
          title: Strings.congratulations,
        ),
      );
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isSubmitLoading.value = false;
    update();
    return _offerEvidenceModel;
  }

  void _setDataForPreviewScreen() {
    var tradeData = _offerBuyModel.data.trade;
    double totalCharge = _offerBuyModel.data.totalCharge;
    double rate = double.parse(tradeData.rate);
    selectPaymentGateway.value =
        _offerBuyModel.data.paymentGatewaies.first.name;
    selectPaymentGatewayId.value =
        _offerBuyModel.data.paymentGatewaies.first.id.toString();

    sellAmount.value = double.parse(tradeData.amount);
    sellCurrency.value = tradeData.saleCurrency.code;
    rateAmount.value = rate;
    rateCurrency.value = tradeData.rateCurrency.code;

    subTotal.value = "${tradeData.rate} ${tradeData.rateCurrency.code}";
    charge.value =
        "${totalCharge.toStringAsFixed(2)} ${tradeData.rateCurrency.code}";
    willPay.value =
        "${(rate + totalCharge).toStringAsFixed(2)} ${tradeData.rateCurrency.code}";
    sellerWillPay.value = "${tradeData.amount} ${tradeData.saleCurrency.code}";

    targetId.value = _offerBuyModel.data.target;

    /// >> route buying preview screen
    Get.toNamed(Routes.offerBuyPreviewScreen);
  }

  void _getDynamicInputFields(List<PaymentField> data) {
    for (int item = 0; item < data.length; item++) {
      // make the dynamic controller
      var textEditingController = TextEditingController();
      inputFieldControllers.add(textEditingController);

      // make dynamic input widget
      if (data[item].type.contains('text') ||
          data[item].type.contains('textarea')) {
        inputFields.add(
          Column(
            children: [
              PrimaryInputWidget(
                controller: inputFieldControllers[item],
                hint: data[item].label,
                isValidator: data[item].required,
                label: data[item].label,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    int.parse(
                      data[item].validation.max.toString(),
                    ),
                  ),
                ],
              ).paddingOnly(bottom: Dimensions.marginSizeVertical * 0.75),
            ],
          ),
        );
      } else if (data[item].type.contains('file')) {
        hasFile.value = true;
        inputFields.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: OfferEvidenceImagePickerWidget(
              labelName: data[item].label,
              fieldName: data[item].name,
            ),
          ),
        );
      }
    }
  }

  void updateImageData(String fieldName, String imagePath) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      listImagePath[itemIndex] = imagePath;
    } else {
      listFieldName.add(fieldName);
      listImagePath.add(imagePath);
    }
    update();
  }

  String? getImagePath(String fieldName) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      return listImagePath[itemIndex];
    }
    return null;
  }
}
