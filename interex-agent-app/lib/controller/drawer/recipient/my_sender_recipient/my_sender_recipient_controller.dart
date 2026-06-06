import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../backend/model/common/common_success_model.dart';
import '../../../../backend/model/recipient/my_recipient/my_recipient_edit_model.dart';
import '../../../../backend/model/recipient/my_sender/my_sender_recipient_list_model.dart';
import '../../../../backend/services/my_sender_api_services.dart';
import '../../../../backend/utils/logger.dart';
import '../../../../routes/routes.dart';
import '../../../categories/remittance/sender/edit_my_sender_recipient_controller.dart';

final log = logger(MySenderRecipientController);

class MySenderRecipientController extends GetxController {
  @override
  void onInit() {
    getMySenderRecipientData();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late MySenderRecipientListModel _allRecepientData;
  MySenderRecipientListModel get allRecepientData => _allRecepientData;

  // --------------------------- Api function ----------------------------------
  Future<MySenderRecipientListModel> getMySenderRecipientData() async {
    _isLoading.value = true;
    update();

    await MySenderRecipientApiServices.myRecipientAPi().then((value) {
      _allRecepientData = value!;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _allRecepientData;
  }

  late CommonSuccessModel _successDatya;
  CommonSuccessModel get successDatya => _successDatya;

  Future<CommonSuccessModel> recipientDeleteApiProcess(
      {required String id}) async {
    _isLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'id': id,
    };

    await MySenderRecipientApiServices.myRecipientDeleteApi(body: inputBody)
        .then((value) {
      _successDatya = value!;
      getMySenderRecipientData();
      update();
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
      _isLoading.value = false;
      update();
    });

    return _successDatya;
  }

  late RecipientEditModel _recipientEditData;
  RecipientEditModel get recipientEditData => _recipientEditData;

  Future<RecipientEditModel> recipientEditApiProcess(
      {required String id}) async {
    _isLoading.value = true;
    update();

    await MySenderRecipientApiServices.receiverRecipientEditAPi(id: id)
        .then((value) {
      _recipientEditData = value!;
      debugPrint("edit recipient");

      final controller = Get.put(MySenderEditRecipientController());

      controller.transactionTypeSelectedMethod.value =
          _recipientEditData.data.recipient.type;
      controller.receiverCountrySelectedMethodId.value =
          _recipientEditData.data.recipient.country;
      controller.receiverBankSelectedMethod.value =
          _recipientEditData.data.recipient.alias;
      controller.pickupPointMethod.value =
          _recipientEditData.data.recipient.alias;
      controller.accountNumberController.text =
          _recipientEditData.data.recipient.accountNumber;

      controller.firstNameController.text =
          _recipientEditData.data.recipient.firstname;
      controller.lastNameController.text =
          _recipientEditData.data.recipient.lastname;
      controller.addressController.text =
          _recipientEditData.data.recipient.address;
      controller.stateController.text = _recipientEditData.data.recipient.state;
      controller.cityController.text = _recipientEditData.data.recipient.city;
      controller.emailController.text = _recipientEditData.data.recipient.email;
      controller.zipController.text = _recipientEditData.data.recipient.zipCode;
      controller.numberController.text =
          _recipientEditData.data.recipient.mobile;
      controller.updateUserId.value =
          _recipientEditData.data.recipient.id.toString();
      controller.basicController.countryCode.value =
          _recipientEditData.data.recipient.mobileCode;

      controller.getRecipientInfoData();

      Get.toNamed(Routes.editMySenderRecipientScreen);
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _recipientEditData;
  }
}
