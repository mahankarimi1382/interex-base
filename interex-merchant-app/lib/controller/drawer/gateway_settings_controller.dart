import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/routes/routes.dart';

import '../../backend/model/common/common_success_model.dart';
import '../../backend/model/gateway_settings_mode/gateway_settings_model.dart';
import '../../backend/services/api_services.dart';

class GatewaySettingsController extends GetxController {
  final primaryKeyController = TextEditingController();
  final secretKeyController = TextEditingController();

  RxBool walletBalanceEnable = false.obs;
  RxBool virtualCardEnable = false.obs;
  RxBool masterCardOrVisaCardEnable = false.obs;

  @override
  void onInit() {
    getGatewaySettingsData();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  late GatewaySettingsModel _gatewaySettingsModel;

  GatewaySettingsModel get gatewaySettingsModel => _gatewaySettingsModel;

  Future<GatewaySettingsModel> getGatewaySettingsData() async {
    _isLoading.value = true;
    update();

    // calling  from api service
    await ApiServices.gatewaySettingsApi().then((value) {
      _gatewaySettingsModel = value!;
      walletBalanceEnable.value = _gatewaySettingsModel.data.walletStatus;
      virtualCardEnable.value = _gatewaySettingsModel.data.virtualCardStatus;
      masterCardOrVisaCardEnable.value =
          _gatewaySettingsModel.data.masterVisaStatus;

      primaryKeyController.text =
          _gatewaySettingsModel.data.credentials.primaryKey;
      secretKeyController.text =
          _gatewaySettingsModel.data.credentials.secretKey;

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    update();
    return _gatewaySettingsModel;
  }

  final _isChangeLoading = false.obs;

  bool get isChangeLoading => _isChangeLoading.value;

  late CommonSuccessModel _walletBalanceModel;

  CommonSuccessModel get walletBalanceModel => _walletBalanceModel;

  Future<CommonSuccessModel> updateWalletStatusProcess(
      {required String value}) async {
    _isLoading.value = true;
    Map<String, String> inputBody = {'status': value};

    await ApiServices.walletBalanceStatusApi(body: inputBody).then((value) {
      _walletBalanceModel = value!;
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isLoading.value = false;
    update();
    return _walletBalanceModel;
  }

  late CommonSuccessModel _virtualCardModel;

  CommonSuccessModel get virtualCardModel => _virtualCardModel;

  Future<CommonSuccessModel> updateVirtualCardStatusProcess(
      {required String value}) async {
    _isLoading.value = true;
    Map<String, String> inputBody = {'status': value};

    await ApiServices.virtualCardStatusApi(body: inputBody).then((value) {
      _virtualCardModel = value!;
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isLoading.value = false;
    update();
    return _virtualCardModel;
  }

  late CommonSuccessModel _masterCardModel;

  CommonSuccessModel get masterCardModel => _masterCardModel;

  Future<CommonSuccessModel> updateMasterCardStatusProcess(
      {required String value}) async {
    _isLoading.value = true;
    Map<String, String> inputBody = {'status': value};

    await ApiServices.masterCardStatusApi(body: inputBody).then((value) {
      _masterCardModel = value!;
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isLoading.value = false;
    update();
    return _masterCardModel;
  }

  late CommonSuccessModel _updateKeyModel;

  CommonSuccessModel get updateKeyModel => _updateKeyModel;

  Future<CommonSuccessModel> updateKeyProcess({
    required String pk,
    required String sk,
  }) async {
    _isChangeLoading.value = true;
    Map<String, String> inputBody = {'primary_key': pk, 'secret_key': sk};

    await ApiServices.updateKeyApi(body: inputBody).then((value) {
      _updateKeyModel = value!;
      _isChangeLoading.value = false;
      Get.offAllNamed(Routes.bottomNavBarScreen);
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isChangeLoading.value = false;
    update();
    return _updateKeyModel;
  }
}
