import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/local_storage/local_storage.dart';

import '../../../backend/model/categories/money_exchange/money_exchange_info_model.dart';
import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/model/wallets/wallets_model.dart';
import '../../../backend/services/money_exchange_api_services.dart';
import '../../remaining_balance/remaining_balance_controller.dart';
import '../../wallets/wallets_controller.dart';

class MoneyExchangeController extends GetxController
    with MoneyExchangeApiServices {
  final walletsController = Get.find<WalletsController>();

  final exchangeFromAmountController = TextEditingController();
  final exchangeToAmountController = TextEditingController();
  //get controller

  final remainingController = Get.put(RemaingBalanceController());
  @override
  void onInit() {
    getMoneyExchangeInfoData();
    exchangeFromAmountController.text = "0";
    super.onInit();
  }

  RxDouble fee = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble dailyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxDouble totalFee = 0.0.obs;

  RxDouble exchangeRate = 0.0.obs;

  String enteredAmount = "";
  String transferFeeAmount = "";
  String totalCharge = "";
  String youWillGet = "";
  String payableAmount = "";
  RxString checkUserMessage = "".obs;
  RxBool isValidUser = false.obs;

  Rxn<UserWallet> selectFromWallet = Rxn<UserWallet>();
  Rxn<UserWallet> selectToWallet = Rxn<UserWallet>();
  List<UserWallet> walletsList = [];

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isMoneyExchangeLoading = false.obs;
  bool get isMoneyExchangeLoading => _isMoneyExchangeLoading.value;

  /// Request money info process API
  late MoneyExchangeInfoModel _moneyExchangeInfoModel;
  MoneyExchangeInfoModel get moneyExchangeInfoModel => _moneyExchangeInfoModel;

  Future<MoneyExchangeInfoModel> getMoneyExchangeInfoData() async {
    _isLoading.value = true;
    update();

    await getMoneyExchangeInfoProcessApi()
        .then((value) {
          _moneyExchangeInfoModel = value!;
          // Get wallet information
          selectFromWallet.value =
              walletsController.walletsInfoModel.data.userWallets.first;

          // Automatically select a different wallet for selectToWallet
          selectToWallet.value = walletsController
              .walletsInfoModel
              .data
              .userWallets
              .firstWhere((wallet) => wallet != selectFromWallet.value);

          for (var element
              in walletsController.walletsInfoModel.data.userWallets) {
            walletsList.add(
              UserWallet(
                balance: element.balance,
                currency: element.currency,
                status: element.status,
              ),
            );
          }

          limitMin.value = double.parse(
            _moneyExchangeInfoModel.data.charges.minLimit,
          );
          limitMax.value = double.parse(
            _moneyExchangeInfoModel.data.charges.maxLimit,
          );

          percentCharge.value = double.parse(
            _moneyExchangeInfoModel.data.charges.percentCharge,
          );
          rate.value = double.parse(_moneyExchangeInfoModel.data.baseCurrRate);

          fixedCharge.value = double.parse(
            _moneyExchangeInfoModel.data.charges.fixedCharge,
          );

          //start remaing get
          remainingController.transactionType.value =
              _moneyExchangeInfoModel.data.getRemainingFields.transactionType;
          remainingController.attribute.value =
              _moneyExchangeInfoModel.data.getRemainingFields.attribute;
          remainingController.cardId.value =
              _moneyExchangeInfoModel.data.charges.id;
          remainingController.senderAmount.value =
              exchangeFromAmountController.text;
          remainingController.senderCurrency.value =
              selectFromWallet.value!.currency.code;

          remainingController.getRemainingBalanceProcess();
          updateExchangeRateWithToAmount();

          update();
        })
        .catchError((onError) {
          // log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _moneyExchangeInfoModel;
  }

  late CommonSuccessModel _sendMoneyModel;
  CommonSuccessModel get sendMoneyModel => _sendMoneyModel;

  // ------------------------------API Function---------------------------------
  Future<CommonSuccessModel> moneyExchangeProcess(BuildContext context) async {
    _isMoneyExchangeLoading.value = true;
    final Map<String, dynamic> inputBody = {
      'exchange_from_amount': exchangeFromAmountController.text,
      'exchange_from_currency': selectFromWallet.value!.currency.code,
      'exchange_to_amount': exchangeToAmountController.text,
      'exchange_to_currency': selectToWallet.value!.currency.code,
    };
    update();

    await moneyExchangeSubmitProcess(body: inputBody)
        .then((value) {
          _sendMoneyModel = value!;
          update();
        })
        .catchError((onError) {
          isValidUser.value = false;
          log.e(onError);
        });

    _isMoneyExchangeLoading.value = false;
    update();
    return _sendMoneyModel;
  }

  RxDouble getFee() {
    double value =
        fixedCharge.value * double.parse(selectFromWallet.value!.currency.rate);
    _updateLimit();
    value =
        value +
        (double.parse(
              exchangeFromAmountController.text.isEmpty
                  ? '0.0'
                  : exchangeFromAmountController.text,
            ) *
            (percentCharge.value / 100));

    if (exchangeFromAmountController.text.isEmpty) {
      totalFee.value = 0.0;
    } else {
      totalFee.value = value;
    }
    debugPrint(totalFee.value.toStringAsPrecision(2));
    return totalFee;
  }

  void updateExchangeRateWithToAmount() {
    exchangeRate.value =
        double.parse(selectToWallet.value!.currency.rate) /
        double.parse(selectFromWallet.value!.currency.rate);

    final double exchangeFromAmount = double.parse(
      exchangeFromAmountController.text.isEmpty
          ? "0.0"
          : exchangeFromAmountController.text,
    );

    final int precision = selectToWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();

    final String amount = (exchangeFromAmount * exchangeRate.value)
        .toStringAsFixed(precision);

    exchangeToAmountController.text = amount;

    getFee();
  }

  void updateExchangeRateWithFromAmount() {
    final double exchangeRate =
        double.parse(selectFromWallet.value!.currency.rate) /
        double.parse(selectToWallet.value!.currency.rate);

    final double exchangeToAmount = double.parse(
      exchangeToAmountController.text.isEmpty
          ? "0.0"
          : exchangeToAmountController.text,
    );
    final int precision = selectFromWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();
    final String amount = (exchangeToAmount * exchangeRate).toStringAsFixed(
      precision,
    );

    exchangeFromAmountController.text = amount;
    getFee();
  }

  void _updateLimit() {
    final limit = _moneyExchangeInfoModel.data.charges;
    limitMin.value =
        double.parse(limit.minLimit) *
        double.parse(selectFromWallet.value!.currency.rate);
    limitMax.value =
        double.parse(limit.maxLimit) *
        double.parse(selectFromWallet.value!.currency.rate);

    dailyLimit.value =
        double.parse(limit.dailyLimit) *
        double.parse(selectFromWallet.value!.currency.rate);
    monthlyLimit.value =
        double.parse(limit.monthlyLimit) *
        double.parse(selectFromWallet.value!.currency.rate);
  }
}
