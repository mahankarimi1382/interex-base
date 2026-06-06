import 'dart:async';

import 'package:qrpaypro/backend/utils/custom_snackbar.dart';

import '../../../../backend/model/common/common_success_model.dart';
import '../../../../controller/categories/remaing_balance_controller/remaing_balance_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';

import '../model/my_trade_model.dart' as my_trade;
import '../model/trade_edit_info_model.dart';
import '../model/trade_submit_model.dart';
import '../service/trade_services.dart';

class TradeController extends GetxController with TradeApiServices {
  final remainingController = Get.put(RemaingBalanceController());

  final sellingAmountController = TextEditingController();
  final askingRateController = TextEditingController();

  @override
  void onInit() {
    fetchTradeApi();
    super.onInit();
  }

  ///=>
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late my_trade.MyTradeModel _myTradeModel;
  my_trade.MyTradeModel get myTradeModel => _myTradeModel;

  late Rx<my_trade.ECurrency> selectedSaleCurrency;
  late Rx<my_trade.ECurrency> selectedRateCurrency;

  RxDouble exchangeRate = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble percCharge = 0.0.obs;
  RxDouble totalCharge = 0.0.obs;
  RxDouble totalPay = 0.0.obs;

  RxDouble minLimit = 0.0.obs;
  RxDouble maxLimit = 0.0.obs;
  RxDouble dailyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;

  void calculation() {
    double sellingAmount = 0;
    if (sellingAmountController.text.isNotEmpty &&
        askingRateController.text.isNotEmpty) {
      sellingAmount = double.parse(sellingAmountController.text);
      double askingAmount = double.parse(askingRateController.text);

      exchangeRate.value = askingAmount / sellingAmount;
    }

    dailyLimit.value = myTradeModel.data.tradeCharge.dailyLimit *
        selectedSaleCurrency.value.rate;
    monthlyLimit.value = myTradeModel.data.tradeCharge.monthlyLimit *
        selectedSaleCurrency.value.rate;

    for (var v in myTradeModel.data.tradeCharge.intervals) {
      if (sellingAmount >= v.minLimit && sellingAmount <= v.maxLimit) {
        fixedCharge.value = v.charge * selectedSaleCurrency.value.rate;
        minLimit.value = v.minLimit * selectedSaleCurrency.value.rate;
        maxLimit.value = v.maxLimit * selectedSaleCurrency.value.rate;

        percCharge.value = v.percent;
        totalCharge.value =
            fixedCharge.value + (sellingAmount * percCharge.value / 100);
        totalPay.value = sellingAmount + totalCharge.value;
      }
    }
  }

  //=>  -----
  Future<my_trade.MyTradeModel> fetchTradeApi() async {
    _isLoading.value = true;
    update();
    await getTradeListInfoApi().then((value) {
      _myTradeModel = value!;

      print("MyTrade Wallet Length");
      print(myTradeModel.data.wallet.length);

      selectedSaleCurrency = _myTradeModel.data.saleCurrency.first.obs;
      selectedRateCurrency = _myTradeModel.data.rateCurrency.first.obs;

      if (selectedSaleCurrency.value.code == selectedRateCurrency.value.code) {
        selectedRateCurrency.value = _myTradeModel.data.rateCurrency.last;
      }

      var v = myTradeModel.data.tradeCharge.intervals.first;
      fixedCharge.value = v.charge * selectedSaleCurrency.value.rate;
      minLimit.value = v.minLimit * selectedSaleCurrency.value.rate;
      maxLimit.value = v.maxLimit * selectedSaleCurrency.value.rate;

      calculation();

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isLoading.value = false;
    update();
    return _myTradeModel;
  }

  ///=>
  final _isSubmitLoading = false.obs;
  bool get isSubmitLoading => _isSubmitLoading.value;

  late TradeSubmitModel _tradeSubmitModel;
  TradeSubmitModel get tradeSubmitModel => _tradeSubmitModel;

  //=>  -----
  Future<TradeSubmitModel> tradeSubmitApi() async {
    _isSubmitLoading.value = true;
    update();

    await tradeSubmitProcessApi(body: {
      "currency": selectedSaleCurrency.value.id,
      "rate_currency": selectedRateCurrency.value.id,
      "amount": sellingAmountController.text,
      "rate": askingRateController.text,
    }).then((value) {
      _tradeSubmitModel = value!;

      Get.toNamed(Routes.tradeQrScreen);

      _isSubmitLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isSubmitLoading.value = false;
    update();
    return _tradeSubmitModel;
  }

  ///=>
  final _isCloseLoading = false.obs;
  bool get isCloseLoading => _isCloseLoading.value;

  late CommonSuccessModel _tradeCloseModel;
  CommonSuccessModel get tradeCloseModel => _tradeCloseModel;

  RxInt selectedIndex = 0.obs;

  //=>  -----
  Future<CommonSuccessModel> tradeCloseApi(int id) async {
    _isCloseLoading.value = true;
    update();

    await tradeCloseProcessApi(body: {"target": id}).then((value) {
      _tradeCloseModel = value!;

      fetchTradeApi();

      _isCloseLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isCloseLoading.value = false;
    update();
    return _tradeCloseModel;
  }

  ///=>
  // final _isEditLoading = false.obs;
  // bool get isEditLoading => _isEditLoading.value;

  late TradeEditInfoModel _tradeEditModel;
  TradeEditInfoModel get tradeEditModel => _tradeEditModel;

  late int target;
  //=>  -----
  Future<TradeEditInfoModel> tradeEditApi(int id) async {
    _isCloseLoading.value = true;
    update();

    await tradeEditInfoProcessApi(body: {"target": id}).then((value) {
      _tradeEditModel = value!;
      target = id;

      sellingAmountController.text = _tradeEditModel.data.amount;
      askingRateController.text = _tradeEditModel.data.rate;

      selectedSaleCurrency.value = _myTradeModel.data.saleCurrency.firstWhere((v)=> v.code == _tradeEditModel.data.saleCurrency.code);
      selectedRateCurrency.value = _myTradeModel.data.rateCurrency.firstWhere((v)=> v.code == _tradeEditModel.data.rateCurrency.code);

      calculation();
      Get.toNamed(Routes.tradeUpdateScreen);

      _isCloseLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isCloseLoading.value = false;
    update();
    return _tradeEditModel;
  }

  ///=>
  final _isUpdateLoading = false.obs;
  bool get isUpdateLoading => _isUpdateLoading.value;

  late CommonSuccessModel _tradeUpdateModel;
  CommonSuccessModel get tradeUpdateModel => _tradeUpdateModel;

  //=>  -----
  Future<CommonSuccessModel> tradeUpdateApi() async {
    _isUpdateLoading.value = true;
    update();

    await tradeUpdateProcessApi(body: {
      "target": target,
      "rate": askingRateController.text,
    }).then((value) {
      _tradeUpdateModel = value!;

      fetchTradeApi();
      Get.close(1);
      CustomSnackBar.success(_tradeUpdateModel.message.success.first);

      _isUpdateLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isUpdateLoading.value = false;
    update();
    return _tradeUpdateModel;
  }
}
