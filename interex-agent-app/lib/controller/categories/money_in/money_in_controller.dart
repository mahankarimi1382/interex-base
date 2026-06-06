import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/routes/routes.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/model/categories/money_in/money_in_info_model.dart';
import '../../../backend/model/categories/send_money/check_user_with_qr_code.dart';
import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/model/wallet/wallets_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../language/english.dart';
import '../../remaining_controller/remaining_balance_controller.dart';
import '../../wallet/wallets_controller.dart';

class MoneyInController extends GetxController {
  final copyInputController = TextEditingController();
  final senderAmountController = TextEditingController();
  final receiverAmountController = TextEditingController();
  final remarkController = TextEditingController();
  //get remaining
  final walletsController = Get.put(WalletsController());
  final remainingController = Get.put(RemaingBalanceController());

  RxDouble fee = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble dailyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxDouble totalFee = 0.0.obs;

  RxDouble receiverExchangeRate = 0.0.obs;
  RxDouble senderExchangeRate = 0.0.obs;

  String enteredAmount = "";
  String transferFeeAmount = "";
  String totalCharge = "";
  String youWillGet = "";
  String payableAmount = "";
  RxString checkUserMessage = "".obs;
  RxBool isValidUser = false.obs;

  RxString baseCurrency = "".obs;
  // List<String> baseCurrencyList = [];

  Rxn<MainUserWallet> selectReceiverWallet = Rxn<MainUserWallet>();
  Rxn<MainUserWallet> selectSenderWallet = Rxn<MainUserWallet>();
  List<MainUserWallet> walletsList = [];

  void gotoPreview() {
    Get.toNamed(Routes.moneyInPreviewScreen);
  }

  @override
  void onInit() {
    getMoneyInInfo();
    senderAmountController.text = "0";
    super.onInit();
  }

  // ---------------------------------------------------------------------------
  //                              Get Send Money Info Data
  // ---------------------------------------------------------------------------

  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late MoneyInInfoModel _moneyInInfoModel;

  MoneyInInfoModel get sendMoneyInfoModel => _moneyInInfoModel;

  // ------------------------------API Function---------------------------------
  //
  Future<MoneyInInfoModel> getMoneyInInfo() async {
    _isLoading.value = true;
    update();

    await ApiServices.moneyInInfoApi()
        .then((value) {
          _moneyInInfoModel = value!;
          baseCurrency.value = _moneyInInfoModel.data.baseCurr;
          selectReceiverWallet.value =
              walletsController.walletsInfoModel.data.userWallets.first;
          selectSenderWallet.value =
              walletsController.walletsInfoModel.data.userWallets.first;

          limitMin.value = _moneyInInfoModel.data.moneyInCharge.minLimit;
          limitMax.value = _moneyInInfoModel.data.moneyInCharge.maxLimit;
          dailyLimit.value = _moneyInInfoModel.data.moneyInCharge.dailyLimit;
          monthlyLimit.value =
              _moneyInInfoModel.data.moneyInCharge.monthlyLimit;

          percentCharge.value =
              _moneyInInfoModel.data.moneyInCharge.percentCharge;
          fixedCharge.value = _moneyInInfoModel.data.moneyInCharge.fixedCharge;
          rate.value = _moneyInInfoModel.data.baseCurrRate;
          receiverExchangeRate.value = walletsController.exchangeRate.value;
          senderExchangeRate.value = walletsController.exchangeRate.value;
          //start remaing get
          remainingController.transactionType.value =
              _moneyInInfoModel.data.getRemainingFields.transactionType;
          remainingController.attribute.value =
              _moneyInInfoModel.data.getRemainingFields.attribute;
          remainingController.cardId.value =
              _moneyInInfoModel.data.moneyInCharge.id;
          remainingController.senderAmount.value = senderAmountController.text;
          remainingController.senderCurrency.value =
              selectSenderWallet.value!.currency.code;

          remainingController.getRemainingBalanceProcess();
          for (var element
              in walletsController.walletsInfoModel.data.userWallets) {
            walletsList.add(
              MainUserWallet(
                balance: element.balance,
                currency: element.currency,
                status: element.status,
              ),
            );
          }

          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _moneyInInfoModel;
  }

  // ---------------------------------------------------------------------------
  //                             Check User Exist
  // ---------------------------------------------------------------------------

  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isCheckUserLoading = false.obs;

  bool get isCheckUserLoading => _isCheckUserLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late CommonSuccessModel _checkUserExistModel;

  CommonSuccessModel get checkUserExistModel => _checkUserExistModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> getCheckMoneyInUserExistDate() async {
    _isCheckUserLoading.value = true;

    final Map<String, dynamic> inputBody = {
      'credentials': copyInputController.text,
    };
    update();

    await ApiServices.checkMoneyInUserExistApi(body: inputBody)
        .then((value) {
          _checkUserExistModel = value!;
          checkUserMessage.value = _checkUserExistModel.message.success.first;
          isValidUser.value = true;
          update();
        })
        .catchError((onError) {
          checkUserMessage.value = Strings.notValidUser;
          isValidUser.value = false;
          log.e(onError);
        });

    _isCheckUserLoading.value = false;
    update();
    return _checkUserExistModel;
  }

  // ---------------------------------------------------------------------------
  //                             Check User With Qr Code
  // ---------------------------------------------------------------------------

  // -------------------------------Define API Model-----------------------------
  //
  late CheckUserWithQrCodeModel _checkUserWithQrCodeModel;

  CheckUserWithQrCodeModel get checkUserWithQrCodeModel =>
      _checkUserWithQrCodeModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CheckUserWithQrCodeModel> getCheckUserWithQrCodeData(
    String qrcode,
  ) async {
    _isCheckUserLoading.value = true;

    final Map<String, dynamic> inputBody = {'qr_code': qrcode};
    update();

    await ApiServices.checkMoneyInUserWithQrCodeApi(body: inputBody)
        .then((value) {
          _checkUserWithQrCodeModel = value!;
          copyInputController.clear();
          copyInputController.text = _checkUserWithQrCodeModel.data.userMobile;
          isValidUser.value = true;
          update();
        })
        .catchError((onError) {
          isValidUser.value = false;
          log.e(onError);
        });

    _isCheckUserLoading.value = false;
    update();
    return _checkUserWithQrCodeModel;
  }

  // ---------------------------------------------------------------------------
  //                             Check User Exist
  // ---------------------------------------------------------------------------
  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isMoneyInLoading = false.obs;

  bool get isMoneyInLoading => _isMoneyInLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late CommonSuccessModel _sendMoneyModel;

  CommonSuccessModel get sendMoneyModel => _sendMoneyModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> moneyInProcess() async {
    _isMoneyInLoading.value = true;

    final Map<String, dynamic> inputBody = {
      'credentials': copyInputController.text,
      'sender_amount': senderAmountController.text,
      'receiver_amount': receiverAmountController.text,
      'sender_wallet': selectSenderWallet.value!.currency.code,
      'receiver_wallet': selectReceiverWallet.value!.currency.code,
      'remark': remarkController.text,
    };
    update();

    await ApiServices.moneyInProcessApi(body: inputBody)
        .then((value) {
          _sendMoneyModel = value!;
          update();
        })
        .catchError((onError) {
          isValidUser.value = false;
          log.e(onError);
        });

    _isMoneyInLoading.value = false;
    update();
    return _sendMoneyModel;
  }

  RxDouble getFee({required double rate}) {
    double value = fixedCharge.value * rate;
    value =
        value +
        (double.parse(
              senderAmountController.text.isEmpty
                  ? '0.0'
                  : senderAmountController.text,
            ) *
            (percentCharge.value / 100));

    if (senderAmountController.text.isEmpty) {
      totalFee.value = 0.0;
    } else {
      totalFee.value = value;
    }

    debugPrint(totalFee.value.toStringAsPrecision(2));
    return totalFee;
  }

  void updateExchangeRate() {
    receiverExchangeRate.value =
        double.parse(selectReceiverWallet.value!.currency.rate) /
        double.parse(selectSenderWallet.value!.currency.rate);

    senderExchangeRate.value =
        double.parse(selectSenderWallet.value!.currency.rate) /
        double.parse(selectReceiverWallet.value!.currency.rate);

    getFee(rate: double.parse(selectSenderWallet.value!.currency.rate));
    updateLimit();
  }

  void getSenderAmount() {
    final double receiverAmount =
        double.tryParse(receiverAmountController.text) ?? 0.0;

    final int precision = selectSenderWallet.value!.currency.type == 'FIAT'
        ? LocalStorage.getFiatPrecision()
        : LocalStorage.getCryptoPrecision();
    senderAmountController.text = (receiverAmount * senderExchangeRate.value)
        .toStringAsFixed(precision);

    getFee(rate: double.parse(selectSenderWallet.value!.currency.rate));
  }

  void getReceiverAmount() {
    final double senderAmount =
        double.tryParse(senderAmountController.text) ?? 0.0;

    final int precision = selectReceiverWallet.value!.currency.type == 'FIAT'
        ? LocalStorage.getFiatPrecision()
        : LocalStorage.getCryptoPrecision();

    receiverAmountController.text = (senderAmount * receiverExchangeRate.value)
        .toStringAsFixed(precision);
    getFee(rate: double.parse(selectSenderWallet.value!.currency.rate));
  }

  void updateLimit() {
    final limit = _moneyInInfoModel.data.moneyInCharge;
    limitMin.value =
        limit.minLimit! * double.parse(selectSenderWallet.value!.currency.rate);
    limitMax.value =
        limit.maxLimit! * double.parse(selectSenderWallet.value!.currency.rate);
    dailyLimit.value =
        limit.dailyLimit! *
        double.parse(selectSenderWallet.value!.currency.rate);
    monthlyLimit.value =
        limit.monthlyLimit! *
        double.parse(selectSenderWallet.value!.currency.rate);
    remainingController.remainingMonthLyLimit.value =
        limit.monthlyLimit! *
        double.parse(selectSenderWallet.value!.currency.rate);
    remainingController.remainingDailyLimit.value =
        limit.dailyLimit! *
        double.parse(selectSenderWallet.value!.currency.rate);

    remainingController.senderAmount.value = senderAmountController.text;
  }
}
