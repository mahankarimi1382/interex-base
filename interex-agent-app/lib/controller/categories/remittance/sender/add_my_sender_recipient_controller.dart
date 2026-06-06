import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../backend/model/common/common_success_model.dart';
import '../../../../backend/model/recipient/common/saved_recipient_info_model.dart';
import '../../../../backend/model/recipient_models/check_recipient_model.dart';
import '../../../../backend/services/my_sender_api_services.dart';
import '../../../../backend/utils/logger.dart';
import '../../../auth/registration/kyc_form_controller.dart';

final log = logger(AddMySenderRecipientController);

class AddMySenderRecipientController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final accountNumberController = TextEditingController();
  RxString numberCode = '1'.obs;
  RxString baseCurrency = "".obs;
  RxString checkUserMessage = "".obs;
  RxBool isValidUser = false.obs;

  RxString transactionTypeSelectedMethod = "".obs;
  RxString transactionTypeFieldName = "".obs;
  late TransactionType transactionType;
  late List<TransactionType> transactionTypeList;

  RxInt receiverCountrySelectedMethodId = 0.obs;
  RxString receiverCountrySelectedMethod = "".obs;
  late ReceiverCountry receiverCountry;
  List<ReceiverCountry> receiverCountryList = [];

  RxString receiverBankSelectedMethod = "".obs;
  late Bank receiverBank;
  late List<Bank> receiverBankList;

  RxString pickupPointMethod = "".obs;
  late Bank pickupPoint;
  late List<Bank> pickupPointList;

  @override
  void onInit() {
    getRecipientInfoData();
    // getRecipientDynamicFieldData();

    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late SaveRecipientInfoModel _recipientInfoData;

  SaveRecipientInfoModel get recipientInfoData => _recipientInfoData;

  Future<SaveRecipientInfoModel> getRecipientInfoData() async {
    _isLoading.value = true;
    update();

    await MySenderRecipientApiServices.saveRecipientInfoAPi()
        .then((value) {
          _recipientInfoData = value!;

          setValues(_recipientInfoData);

          update();
        })
        .catchError((onError) {
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
    receiverBankList = _recipientInfoData.data.banks;
    pickupPointList = _recipientInfoData.data.cashPickupsPoints;
    final data = recipientInfoData.data.receiverCountries;

    for (var i in data) {
      // if (i.code == _recipientInfoData.data.baseCurr) {
      numberCode.value = i.mobileCode;
      receiverCountrySelectedMethod.value = "${i.name} (${i.code})";
      receiverCountry = i;
      receiverCountryList.add(
        ReceiverCountry(
          id: i.id,
          country: i.country,
          name: i.name,
          code: i.code,
          mobileCode: i.mobileCode,
          symbol: i.symbol,
          rate: i.rate,
          status: i.status,
        ),
      );
      // }
    }
    debugPrint("Set Value in add recipient controller--------------");
    baseCurrency.value = _recipientInfoData.data.baseCurr;
    transactionTypeSelectedMethod.value =
        _recipientInfoData.data.transactionTypes.first.labelName;
    transactionTypeFieldName.value =
        _recipientInfoData.data.transactionTypes.first.fieldName;
    transactionType = _recipientInfoData.data.transactionTypes.first;

    receiverBankSelectedMethod.value = _recipientInfoData.data.banks.first.name;
    receiverBank = _recipientInfoData.data.banks.first;

    pickupPointMethod.value =
        _recipientInfoData.data.cashPickupsPoints.first.name;
    pickupPoint = _recipientInfoData.data.cashPickupsPoints.first;
  }

  void addRecipient(BuildContext context) {
    recipientStoreApiProcess(context);
  }

  late CommonSuccessModel _successDatya;

  CommonSuccessModel get successDatya => _successDatya;

  final basicController = Get.put(BasicDataController());

  // Login process function
  Future<CommonSuccessModel> recipientStoreApiProcess(
    BuildContext context,
  ) async {
    _isLoading.value = true;
    update();

    final Map<String, dynamic> inputBody = {
      'transaction_type': transactionType.fieldName,
      'country': receiverCountry.id,
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'mobile_code': numberCode.value,
      'mobile': numberController.text,
      'email': emailController.text,
      'city': cityController.text,
      'address': addressController.text,
      'zip': zipController.text,
      'state': stateController.text,
      'bank': receiverBank.alias,
      'cash_pickup': pickupPoint.alias,
      'account_number': accountNumberController.text,
    };
    // calling login api from api service
    await MySenderRecipientApiServices.myRecipientStoreApi(body: inputBody)
        .then((value) {
          _successDatya = value!;
          _isLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _successDatya;
  }

  final _isCheckLoading = false.obs;

  bool get isCheckLoading => _isCheckLoading.value;

  late CheckRecipientModel _checkRecipientModel;

  CheckRecipientModel get checkRecipientModel => _checkRecipientModel;

  Future<CheckRecipientModel> recipientCheckApiProcess() async {
    _isCheckLoading.value = true;
    update();

    final Map<String, dynamic> inputBody = {'email': emailController.text};

    await MySenderRecipientApiServices.checkRecipientApi(body: inputBody)
        .then((value) {
          _checkRecipientModel = value!;

          checkUserMessage.value = _checkRecipientModel.message.success.first;

          final data = _checkRecipientModel;
          firstNameController.text = data.data.user.firstname;
          lastNameController.text = data.data.user.lastname;
          numberController.text = data.data.user.mobile;
          cityController.text = data.data.user.address.city;
          addressController.text = data.data.user.address.city;
          zipController.text = data.data.user.address.zip;
          stateController.text = data.data.user.address.state;

          isValidUser.value = true;
          _isCheckLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isCheckLoading.value = false;
    update();
    return _checkRecipientModel;
  }

  void changeCountry(String type) {
    final data = recipientInfoData.data.receiverCountries;
    // if (type == 'wallet-to-wallet-transfer') {
    for (var i in data) {
      if (i.code == baseCurrency.value) {
        receiverCountrySelectedMethod.value = "${i.name} (${i.code})";
        receiverCountry = i;
        numberCode.value = i.mobileCode;
      }
    }
    // }
  }
}
