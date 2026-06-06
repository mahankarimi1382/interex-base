import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/model/categories/receive_money/receive_money_model.dart';
import '../../backend/services/api_services.dart';

class MoneyReceiverController extends GetxController {
  final inputController = TextEditingController();
  final copyInputController = TextEditingController();

  @override
  void onInit() {
    getReceiveMoneyData();
    super.onInit();
  }

  // ---------------------------------------------------------------------------
  //                              Get Card Info Data
  // ---------------------------------------------------------------------------

  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late ReceiveMoneyModel _receiveMoneyModel;

  ReceiveMoneyModel get receiveMoneyModel => _receiveMoneyModel;

  // ------------------------------API Function---------------------------------
  //
  Future<ReceiveMoneyModel> getReceiveMoneyData() async {
    _isLoading.value = true;
    update();

    await ApiServices.receiveMoneyApi().then((value) {
      _receiveMoneyModel = value!;
      inputController.text = _receiveMoneyModel.data.uniqueCode.toString();
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _receiveMoneyModel;
  }
}
