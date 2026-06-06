import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/model/api_key/api_key_model.dart';
import '../../backend/model/common/common_success_model.dart';
import '../../backend/services/api_services.dart';

class ApiKeyController extends GetxController {
  final primaryKeyController = TextEditingController();
  final secretKeyController = TextEditingController();
  final apiKeyController = TextEditingController();
  RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    getApiKeyData();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  late ApiKeyModel _apiKeyModel;

  ApiKeyModel get apiKeyModel => _apiKeyModel;

  Future<ApiKeyModel> getApiKeyData() async {
    _isLoading.value = true;
    update();

    // calling  from api service
    await ApiServices.apiKeyApi().then((value) {
      _apiKeyModel = value!;

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    update();
    return _apiKeyModel;
  }

  final _isConfirmLoading = false.obs;

  bool get isConfirmLoading => _isConfirmLoading.value;

  late CommonSuccessModel _productionModeModel;

  CommonSuccessModel get productionModeModel => _productionModeModel;

  Future<CommonSuccessModel> changeProductionModeProcess(String id) async {
    _isConfirmLoading.value = true;
    Map<String, String> inputBody = {
      "target": id,
    };

    await ApiServices.productionModeApi(body: inputBody).then((value) {
      _productionModeModel = value!;
      getApiKeyData();
      _isConfirmLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isConfirmLoading.value = false;
    update();
    return _productionModeModel;
  }

  final _isCreateLoading = false.obs;

  bool get isCreateLoading => _isCreateLoading.value;

  late CommonSuccessModel _createApiKeyModel;

  CommonSuccessModel get createApiKeyModel => _createApiKeyModel;

  Future<CommonSuccessModel> createApiKeyProcess() async {
    _isCreateLoading.value = true;
    Map<String, String> inputBody = {
      "name": apiKeyController.text,
    };

    await ApiServices.createApiKeyApi(body: inputBody).then((value) {
      _createApiKeyModel = value!;
      getApiKeyData();
      _isCreateLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isCreateLoading.value = false;
    update();
    return _createApiKeyModel;
  }

  final _isDeleteLoading = false.obs;

  bool get isDeleteLoading => _isDeleteLoading.value;

  late CommonSuccessModel _deleteApiKeyModel;

  CommonSuccessModel get deleteApiKeyModel => _deleteApiKeyModel;

  Future<CommonSuccessModel> deleteApiKeyProcess(String target) async {
    _isDeleteLoading.value = true;
    Map<String, String> inputBody = {
      "target": target,
    };

    await ApiServices.deleteApiKeyApi(body: inputBody).then((value) {
      _deleteApiKeyModel = value!;
      getApiKeyData();
      _isDeleteLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isDeleteLoading.value = false;
    update();
    return _deleteApiKeyModel;
  }
}
