import 'package:flutter/services.dart';

import '../../../../backend/model/common/common_success_model.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../congratulation_screen.dart';
import '../model/marketplace_buy_confirm.model.dart';
import '../model/marketplace_buy_model.dart';
import '../service/marketplace_api_services.dart';
import '../widget/evidance_offer_image_widget.dart';

class MarketplaceBuyingPreviewController extends GetxController {
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

  /// >>> get seller info
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
  Future<MarketplaceBuyConfirmModel> get onConfirm =>
      marketplaceBuyConfirmProcessApi();
  Future<CommonSuccessModel> get onSubmit => marketplaceEvidenceProcessApi();

  /// >> set loading process & Model
  final _isBuyLoading = false.obs;
  final _isConfirmLoading = false.obs;
  final _isSubmitLoading = false.obs;
  late MarketplaceBuyModel _marketplaceBuyModel;
  late MarketplaceBuyConfirmModel _marketplaceBuyConfirmModel;
  late CommonSuccessModel _evidenceSubmitModel;

  /// >> get loading process & Model
  bool get isBuyLoading => _isBuyLoading.value;
  bool get isConfirmLoading => _isConfirmLoading.value;
  bool get isSubmitLoading => _isSubmitLoading.value;
  MarketplaceBuyModel get marketplaceBuyModel => _marketplaceBuyModel;
  MarketplaceBuyConfirmModel get marketplaceBuyConfirmModel =>
      _marketplaceBuyConfirmModel;
  CommonSuccessModel get evidenceSubmitModel => _evidenceSubmitModel;

  ///* Marketplace buy api process
  Future<MarketplaceBuyModel> marketplaceBuyProcessApi(int id) async {
    _isBuyLoading.value = true;
    update();
    Map<String, String> inputBody = {'target': id.toString()};
    await MarketplaceApiServices.marketplaceBuyProcessApi(body: inputBody)
        .then((value) {
          _marketplaceBuyModel = value!;

          _setDataForPreviewScreen();
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isBuyLoading.value = false;
    update();
    return _marketplaceBuyModel;
  }

  ///* Marketplace buy confirm api process
  Future<MarketplaceBuyConfirmModel> marketplaceBuyConfirmProcessApi() async {
    _isConfirmLoading.value = true;
    inputFields.clear();
    listImagePath.clear();
    listFieldName.clear();
    inputFieldControllers.clear();
    update();
    Map<String, String> inputBody = {
      'target': targetId.value,
      'gateway_id': selectPaymentGatewayId.value,
    };
    await MarketplaceApiServices.marketplaceBuyConfirmProcessApi(
          body: inputBody,
        )
        .then((value) {
          _marketplaceBuyConfirmModel = value!;
          trxID.value = _marketplaceBuyConfirmModel.data.trxId;
          _getDynamicInputFields(
            _marketplaceBuyConfirmModel.data.paymentFields,
          );

          Get.toNamed(Routes.marketplaceEvidenceSubmitScreen);

          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isConfirmLoading.value = false;
    update();
    return _marketplaceBuyConfirmModel;
  }

  ///* Marketplace evidence submit api process
  Future<CommonSuccessModel> marketplaceEvidenceProcessApi() async {
    _isSubmitLoading.value = true;
    update();
    Map<String, String> inputBody = {'trx_id': trxID.value};

    final data = _marketplaceBuyConfirmModel.data.paymentFields;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].name] = inputFieldControllers[i].text;
      }
    }

    await MarketplaceApiServices.marketplaceEvidenceSubmitProcessApi(
          body: inputBody,
          fieldList: listFieldName,
          pathList: listImagePath,
        )
        .then((value) {
          _evidenceSubmitModel = value!;
          Get.to(
            () => CongratulationScreen(
              route: Routes.bottomNavBarScreen,
              subTitle: _evidenceSubmitModel.message.success.first,
              title: Strings.congratulations,
            ),
          );
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isSubmitLoading.value = false;
    update();
    return _evidenceSubmitModel;
  }

  void _setDataForPreviewScreen() {
    var tradeData = _marketplaceBuyModel.data.trade;
    double totalCharge = _marketplaceBuyModel.data.totalCharge;
    double rate = double.parse(tradeData.subTotal);
    selectPaymentGateway.value =
        _marketplaceBuyModel.data.paymentGatewaies.first.name;
    selectPaymentGatewayId.value = _marketplaceBuyModel
        .data
        .paymentGatewaies
        .first
        .id
        .toString();

    sellAmount.value = double.parse(tradeData.seller);
    sellCurrency.value = tradeData.saleCurrency.code;
    rateAmount.value = rate;
    rateCurrency.value = tradeData.rateCurrency.code;

    subTotal.value = "${tradeData.subTotal} ${tradeData.rateCurrency.code}";
    charge.value =
        "${totalCharge.toStringAsFixed(2)} ${tradeData.rateCurrency.code}";
    willPay.value =
        "${(rate + totalCharge).toStringAsFixed(2)} ${tradeData.rateCurrency.code}";
    sellerWillPay.value = "${tradeData.seller} ${tradeData.saleCurrency.code}";

    targetId.value = _marketplaceBuyModel.data.target;

    /// >> route buying preview screen
    Get.toNamed(Routes.marketplaceBuyingPreviewScreen);
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
                // fillColor: Theme.of(Get.context!).colorScheme.surface,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    int.parse(data[item].validation.max.toString()),
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
            child: EvidenceImagePickerWidget(
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
