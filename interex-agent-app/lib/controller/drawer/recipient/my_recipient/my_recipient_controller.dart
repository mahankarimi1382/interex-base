import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../backend/model/common/common_success_model.dart';
import '../../../../backend/model/recipient/my_recipient/my_recipient_edit_model.dart';
import '../../../../backend/model/recipient/my_recipient/my_recipient_list_model.dart';
import '../../../../backend/services/api_services.dart';
import '../../../../backend/utils/logger.dart';
import '../../../../routes/routes.dart';
import '../../../categories/remittance/edit_recipient_controller.dart';

final log = logger(MyRecipientController);

class MyRecipientController extends GetxController {
  @override
  void onInit() {
    getMyRecipientData();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late MyRecipientListModel _allRecepientData;
  MyRecipientListModel get allRecepientData => _allRecepientData;

  // --------------------------- Api function ----------------------------------
  Future<MyRecipientListModel> getMyRecipientData() async {
    _isLoading.value = true;
    update();

    await ApiServices.myRecipientAPi().then((value) {
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

    await ApiServices.myRecipientDeleteApi(body: inputBody).then((value) {
      _successDatya = value!;
      getMyRecipientData();
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

    await ApiServices.receiverRecipientEditAPi(id: id).then((value) {
      _recipientEditData = value!;
      debugPrint("edit recipient");

      final controller = Get.put(EditRecipientController());

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
      controller.emailController.text = _recipientEditData.data.recipient.email;
      controller.cityController.text = _recipientEditData.data.recipient.city;
      controller.zipController.text = _recipientEditData.data.recipient.zipCode;
      controller.numberController.text =
          _recipientEditData.data.recipient.mobile;
      controller.updateUserId.value =
          _recipientEditData.data.recipient.id.toString();
      controller.basicController.countryCode.value =
          _recipientEditData.data.recipient.mobileCode;

      controller.getRecipientInfoData();

      Get.toNamed(Routes.editRecipientScreen);
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _recipientEditData;
  }
}
