import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/model/recipient/common/saved_recipient_info_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../backend/utils/logger.dart';
import '../../auth/registration/kyc_form_controller.dart';

final log = logger(EditRecipientController);

class EditRecipientController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final accountNumberController = TextEditingController();
  RxString numberCode = LocalStorage.getCountryCode()!.obs;

  RxString transactionTypeSelectedMethod = "".obs;
  late TransactionType transactionType;
  late List<TransactionType> transactionTypeList;

  RxInt receiverCountrySelectedMethodId = 0.obs;
  RxString receiverCountrySelectedMethod = "".obs;
  late ReceiverCountry receiverCountry;
  late List<ReceiverCountry> receiverCountryList;

  RxString receiverBankSelectedMethod = "".obs;
  late Bank receiverBank;
  late List<Bank> receiverBankList;

  RxString pickupPointMethod = "".obs;
  late Bank pickupPoint;
  late List<Bank> pickupPointList;

  @override
  void onInit() {
    getRecipientInfoData();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late SaveRecipientInfoModel _recipientInfoData;
  SaveRecipientInfoModel get recipientInfoData => _recipientInfoData;

  Future<SaveRecipientInfoModel> getRecipientInfoData() async {
    _isLoading.value = true;
    update();

    await ApiServices.saveRecipientInfoAPi().then((value) {
      _recipientInfoData = value!;

      setValues(_recipientInfoData);

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _recipientInfoData;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    stateController.dispose();
    cityController.dispose();
    zipController.dispose();
    numberController.dispose();

    super.dispose();
  }

  void setValues(SaveRecipientInfoModel recipientInfoData) {
    transactionTypeList = _recipientInfoData.data.transactionTypes;
    receiverCountryList = _recipientInfoData.data.receiverCountries;
    receiverBankList = _recipientInfoData.data.banks;
    pickupPointList = _recipientInfoData.data.cashPickupsPoints;

    debugPrint("Set Value in add recipient controller--------------");

    receiverBankSelectedMethod.value = _recipientInfoData.data.banks.first.name;
    receiverBank = _recipientInfoData.data.banks.first;

    pickupPointMethod.value =
        _recipientInfoData.data.cashPickupsPoints.first.name;
    pickupPoint = _recipientInfoData.data.cashPickupsPoints.first;

    debugPrint("Edit Recipient-------------");

    transactionTypeSelectedMethod.value =
        _recipientInfoData.data.transactionTypes.first.labelName;
    transactionType = _recipientInfoData.data.transactionTypes.first;
    for (var element in _recipientInfoData.data.transactionTypes) {
      if (element.fieldName == transactionTypeSelectedMethod.value) {
        transactionTypeSelectedMethod.value = element.labelName;
        transactionType = element;
      }
    }

    receiverCountrySelectedMethod.value =
        _recipientInfoData.data.receiverCountries.first.name;
    receiverCountry = _recipientInfoData.data.receiverCountries.first;
    for (var element in _recipientInfoData.data.receiverCountries) {
      if (element.id == receiverCountrySelectedMethodId.value) {
        receiverCountrySelectedMethod.value = element.name;
        receiverCountry = element;
      }
    }

    receiverBankSelectedMethod.value = _recipientInfoData.data.banks.first.name;
    receiverBank = _recipientInfoData.data.banks.first;
    for (var element in _recipientInfoData.data.banks) {
      if (element.alias == receiverBankSelectedMethod.value) {
        receiverBankSelectedMethod.value = element.name;
        receiverBank = element;
      }
    }

    pickupPointMethod.value =
        _recipientInfoData.data.cashPickupsPoints.first.name;
    pickupPoint = _recipientInfoData.data.cashPickupsPoints.first;
    for (var element in _recipientInfoData.data.cashPickupsPoints) {
      if (element.alias == pickupPointMethod.value) {
        pickupPointMethod.value = element.name;
        pickupPoint = element;
      }
    }
  }

  void addRecipient() {
    recipientUpdateApiProcess();
  }

  late CommonSuccessModel _successDatya;
  CommonSuccessModel get successDatya => _successDatya;

  final basicController = Get.put(BasicDataController());

  RxString updateUserId = "".obs;
  Future<CommonSuccessModel> recipientUpdateApiProcess() async {
    _isLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'id': updateUserId.value,
      'transaction_type': transactionType.fieldName,
      'country': receiverCountry.id,
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'mobile_code': basicController.countryCode.value,
      'mobile': numberController.text,
      'city': cityController.text,
      'address': addressController.text,
      'email': emailController.text,
      'zip': zipController.text,
      'state': stateController.text,
      'bank': receiverBank.alias,
      'cash_pickup': pickupPoint.alias,
      'account_number': accountNumberController.text,
    };
    // calling login api from api service
    await ApiServices.myRecipientUpdateApi(body: inputBody).then((value) {
      _successDatya = value!;
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _successDatya;
  }
}
