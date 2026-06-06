import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/local_storage/local_storage.dart';
import 'package:qrpay/backend/model/common/common_success_model.dart';
import 'package:qrpay/routes/routes.dart';

import '../../../backend/model/remittance/remittance_info_model.dart';
import '../../../backend/model/remittance/remittance_sender_recipient_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../language/english.dart';
import '../../../widgets/others/congratulation_widget.dart';
import '../../remaining_controller/remaining_balance_controller.dart';

class RemittanceController extends GetxController {
  final sendingCountryController = TextEditingController();
  final receivingCountryController = TextEditingController();
  final recipeintController = TextEditingController();
  final receivingMethodController = TextEditingController();

  // final Controller = TextEditingController();
  final amountController = TextEditingController();
  final recipientGetController = TextEditingController();
  final remainingController = Get.put(RemaingBalanceController());

  RxString selectedSendingCountryCurrency = "".obs;
  RxString selectedReceivingCountryCurrency = "".obs;
  RxString selectedSendingCountryCode = "".obs;
  RxString selectedReceivingCountryCode = "".obs;
  RxString selectedMethod = "Select Method".obs;
  RxString selectedTrxType = "".obs;
  RxString selectedConfirmTrxType = "".obs;
  RxString selectedRecipient = "Select Recipient".obs;
  RxString selectedSenderRecipient = "Select Recipient".obs;
  RxString baseCurrency = "".obs;
  RxDouble baseCurrencyRate = 0.0.obs;
  RxInt selectedRecipientId = 0.obs;
  RxInt selectedSenderRecipientId = 0.obs;

  RxDouble toCountriesRate = 0.0.obs;
  RxDouble fromCountriesRate = 0.0.obs;
  RxDouble exchangeRate = 0.0.obs;

  RxInt sendingCountryId = 0.obs;
  RxInt receivingCountryId = 0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble minLimit = 0.0.obs;
  RxDouble maxLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble dailyLimit = 0.0.obs;
  RxDouble totalFee = 0.0.obs;

  List<Country> sendingCountryCurrencyList = [];
  List<Country> receivingCountryCurrencyList = [];
  List<TransactionType> transactionTypeList = [];

  RxList<SenderRecipient> recipientList = <SenderRecipient>[].obs;
  RxList<SenderRecipient> senderRecipientList = <SenderRecipient>[].obs;

  void togoRemittancePreview() {
    Get.toNamed(Routes.remittancePreviewScreen);
  }

  @override
  void onInit() {
    getRemittanceInfo();

    amountController.text = "0";
    super.onInit();
  }

  // ---------------------------- RemittanceInfoModel ------------------
  // api loading process indicator variable
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late RemittanceInfoModel _remittanceInfoModel;

  RemittanceInfoModel get remittanceInfoModel => _remittanceInfoModel;

  // --------------------------- Api function ----------------------------------
  // get RemittanceInfo function
  Future<RemittanceInfoModel> getRemittanceInfo() async {
    _isLoading.value = true;
    update();

    await ApiServices.remittanceInfoAPi()
        .then((value) {
          _remittanceInfoModel = value!;
          final data = _remittanceInfoModel.data;

          sendingCountryCurrencyList = data.fromCountry;
          receivingCountryCurrencyList = data.toCountries;
          transactionTypeList = data.transactionTypes;

          // baseCurrency.value = data.agentWallet.currency;

          selectedSendingCountryCurrency.value =
              "${data.fromCountry.first.name} (${data.fromCountry.first.code})";
          selectedReceivingCountryCurrency.value =
              "${data.toCountries.first.name} (${data.toCountries.first.code})";

          toCountriesRate.value = data.toCountries.first.rate;
          fromCountriesRate.value = data.fromCountry.first.rate;

          sendingCountryId.value = data.fromCountry.first.id;
          receivingCountryId.value = data.toCountries.first.id;
          selectedSendingCountryCode.value = data.fromCountry.first.code;
          selectedReceivingCountryCode.value = data.toCountries.first.code;

          //get remaining controller
          remainingController.transactionType.value =
              data.getRemainingFields.transactionType;
          remainingController.attribute.value =
              data.getRemainingFields.attribute;
          remainingController.cardId.value = data.remittanceCharge.id;
          remainingController.senderAmount.value = amountController.text;
          remainingController.senderCurrency.value =
              selectedSendingCountryCode.value;
          remainingController.getRemainingBalanceProcess();

          if (data.receiverRecipients.isNotEmpty) {
            selectedMethod.value = data.receiverRecipients.first.trxTypeName;
            selectedTrxType.value = data.receiverRecipients.first.trxType;
            selectedConfirmTrxType.value =
                data.receiverRecipients.first.trxType;
            selectedRecipientId.value = data.receiverRecipients.first.id;
            remittanceGetRecipientProcess();
          }
          if (data.senderRecipients.isNotEmpty) {
            selectedMethod.value = data.senderRecipients.first.trxTypeName;
            selectedTrxType.value = data.senderRecipients.first.trxType;
            selectedConfirmTrxType.value = data.senderRecipients.first.trxType;
            selectedSenderRecipientId.value = data.senderRecipients.first.id;
            remittanceSenderRecipientProcess();
          }
          getRate();

          // Remittance Charge
          final remittanceCharge = data.remittanceCharge;
          fixedCharge.value = remittanceCharge.fixedCharge;
          percentCharge.value = remittanceCharge.percentCharge;
          minLimit.value = remittanceCharge.minLimit;
          maxLimit.value = remittanceCharge.maxLimit;
          monthlyLimit.value = remittanceCharge.monthlyLimit;
          dailyLimit.value = remittanceCharge.dailyLimit;

          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _remittanceInfoModel;
  }

  //  remittance confirm function

  final _isRemittanceConfirm = false.obs;

  bool get isRemittanceConfirm => _isRemittanceConfirm.value;

  late CommonSuccessModel _remittanceConfirmModel;

  CommonSuccessModel get remittanceConfirmModel => _remittanceConfirmModel;

  Future<CommonSuccessModel> remittanceConfirmProcess(
    BuildContext context,
  ) async {
    _isRemittanceConfirm.value = true;
    update();

    final Map<String, dynamic> inputBody = {
      'form_country': sendingCountryId.value,
      'to_country': receivingCountryId.value,
      'transaction_type': selectedTrxType.value,
      'recipient': selectedRecipientId.value,
      'send_amount': amountController.text,
      'receive_amount': recipientGetController.text,
      'sender_recipient': selectedSenderRecipientId.value,
      'receiver_recipient': selectedRecipientId.value,
    };

    await ApiServices.remittanceConfirmAPi(body: inputBody)
        .then((value) {
          _remittanceConfirmModel = value!;
          update();
          StatusScreen.show(
            // ignore: use_build_context_synchronously
            context: context,
            subTitle: Strings.sendMoneySuccesfully.tr,
            onPressed: () {
              // NotificationService.showLocalNotification(
              //   title: 'Success',
              //   body:
              //       'Your money has been send Successfully. Thanks for using QRPAY',
              // );
              Get.offAllNamed(Routes.bottomNavBarScreen);
            },
          );
        })
        .catchError((onError) {
          log.e(onError);
          _isRemittanceConfirm.value = false;
        });
    _isRemittanceConfirm.value = false;
    update();
    return _remittanceConfirmModel;
  }

  // Remittance Get Recipient function

  final _isGetRemittance = false.obs;

  bool get isGetRemittance => _isGetRemittance.value;

  late RemittanceSenderRecipientModel _getRemittanceModel;

  RemittanceSenderRecipientModel get getRemittanceModel => _getRemittanceModel;

  Future<RemittanceSenderRecipientModel> remittanceGetRecipientProcess() async {
    _isGetRemittance.value = true;
    recipientList.clear();
    selectedRecipient.value = "No Recipient";
    update();

    final Map<String, dynamic> inputBody = {
      'to_country': receivingCountryId.value,
      'transaction_type': selectedTrxType.value,
    };

    await ApiServices.remittanceGetRecipientAPi(body: inputBody)
        .then((value) {
          _getRemittanceModel = value!;
          final name = _getRemittanceModel.data.senderRecipient.first;

          recipientList.value = _getRemittanceModel.data.senderRecipient;
          selectedRecipient.value = "${name.firstname} ${name.lastname}";
          selectedRecipientId.value =
              _getRemittanceModel.data.senderRecipient.first.id;

          /// sender recipient
          /// senderRecipientList.value = _getRemittanceModel.data.senderRecipient;

          selectedRecipient.value = "${name.firstname} ${name.lastname}";
          selectedRecipientId.value =
              _getRemittanceModel.data.senderRecipient.first.id;
          update();
        })
        .catchError((onError) {
          log.e(onError);
          _isGetRemittance.value = false;
        });
    _isGetRemittance.value = false;
    update();
    return _getRemittanceModel;
  }

  /// Sender Remittance Info
  RxBool isCrypto1 = false.obs;
  RxBool isCrypto2 = false.obs;

  late RemittanceSenderRecipientModel _remittanceSenderRecipientModel;

  RemittanceSenderRecipientModel get remittanceSenderRecipientModel =>
      _remittanceSenderRecipientModel;

  Future<RemittanceSenderRecipientModel>
  remittanceSenderRecipientProcess() async {
    _isGetRemittance.value = true;
    senderRecipientList.clear();
    selectedSenderRecipient.value = "No Recipient";
    update();

    final Map<String, dynamic> inputBody = {
      "from_country": '${sendingCountryId.value}',
      'transaction_type': selectedTrxType.value,
    };

    await ApiServices.remittanceSenderRecipientAPi(body: inputBody)
        .then((value) {
          _remittanceSenderRecipientModel = value!;
          final name =
              _remittanceSenderRecipientModel.data.senderRecipient.first;

          /// sender recipient
          senderRecipientList.value =
              _remittanceSenderRecipientModel.data.senderRecipient;
          selectedSenderRecipient.value = "${name.firstname} ${name.lastname}";
          selectedSenderRecipientId.value =
              _remittanceSenderRecipientModel.data.senderRecipient.first.id;

          update();
        })
        .catchError((onError) {
          log.e(onError);
          _isGetRemittance.value = false;
        });
    _isGetRemittance.value = false;
    update();
    return _remittanceSenderRecipientModel;
  }

  // Currency exchange method

  dynamic get recipientGet => _recipientGetOnChange();

  dynamic get senderSendAmount => _senderSendAmount();

  void _senderSendAmount() {
    final amount = _doubleParse(recipientGetController.text);

    amountController.text = (amount / fromCountriesRate.value).toStringAsFixed(
      isCrypto1.value
          ? LocalStorage.getCryptoPrecision()
          : LocalStorage.getFiatPrecision(),
    );
    updateLimit();
  }

  void _recipientGetOnChange() {
    final amount = _doubleParse(amountController.text);

    recipientGetController.text = (amount * toCountriesRate.value)
        .toStringAsFixed(
          isCrypto2.value
              ? LocalStorage.getCryptoPrecision()
              : LocalStorage.getFiatPrecision(),
        );
    updateLimit();
  }

  double _doubleParse(String amount) {
    return double.parse(amount.isNotEmpty ? amount : '0.0');
  }

  void getRate() {
    exchangeRate.value = toCountriesRate.value / fromCountriesRate.value;
  }

  RxDouble getFee({required double rate}) {
    debugPrint("getFee method working");
    debugPrint("${exchangeRate.value}");

    double value = fixedCharge.value * rate;
    value =
        value +
        (double.parse(
              amountController.text.isEmpty ? '0.0' : amountController.text,
            ) *
            (percentCharge.value / 100));

    if (amountController.text.isEmpty) {
      totalFee.value = 0.0;
    } else {
      totalFee.value = value;
    }

    debugPrint(totalFee.value.toStringAsPrecision(2));
    return totalFee;
  }

  void updateLimit() {
    final limit = _remittanceInfoModel.data.remittanceCharge;
    minLimit.value = limit.minLimit! * fromCountriesRate.value;
    maxLimit.value = limit.maxLimit! * fromCountriesRate.value;

    dailyLimit.value = limit.dailyLimit! * fromCountriesRate.value;
    monthlyLimit.value = limit.monthlyLimit! * fromCountriesRate.value;
  }
}
