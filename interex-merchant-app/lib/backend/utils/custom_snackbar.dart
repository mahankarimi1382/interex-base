import 'package:qrpay/language/language_controller.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/strings.dart';

class CustomSnackBar {
  static SnackbarController success(String message) {
    return Get.snackbar(
      Get.find<LanguageController>().getTranslation(Strings.success),
      Get.find<LanguageController>().getTranslation(message),
      icon: Icon(
        Icons.check_circle,
        color: CustomColor.greenColor,
        size: Dimensions.heightSize * 2.6,
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      margin: EdgeInsets.all(Dimensions.marginSizeVertical * 0.5),
    );
  }

  static SnackbarController error(String message) {
    return Get.snackbar(
      Get.find<LanguageController>().getTranslation(Strings.alert),
      Get.find<LanguageController>().getTranslation(message),
      icon: Icon(
        Icons.error,
        color: CustomColor.redColor,
        size: Dimensions.heightSize * 2.6,
      ),
      margin: EdgeInsets.all(Dimensions.marginSizeVertical * 0.5),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
