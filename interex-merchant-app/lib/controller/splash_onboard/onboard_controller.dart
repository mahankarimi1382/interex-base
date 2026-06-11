import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qrpay/custom_assets/assets.gen.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/views/others/custom_image_widget.dart';

import '../../backend/local_storage/local_storage.dart';
import '../app_settings/app_settings_controller.dart';

class OnBoardController extends GetxController {
  var selectedIndex = 0.obs;
  var pageController = PageController();
  final controller = Get.put(AppSettingsController());

  bool get isLastPage =>
      selectedIndex.value ==
      controller.appSettingsModel!.data.appSettings.agent.onboardScreen.length;

  bool get isFirstPage => selectedIndex.value == 0;

  // bool get isSecondPage => selectedIndex.value == 1;

  void nextPage() {
    if (isLastPage) {
    } else {
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    }
  }

  void backPage() {
    pageController.previousPage(duration: 300.milliseconds, curve: Curves.ease);
  }

  void pageNavigate() {
    LocalStorages.saveOnboardDoneOrNot(isOnBoardDone: true);
    Get.offAllNamed(Routes.signInScreen);
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == selectedIndex.value
            ? CustomColor.primaryLightColor
            : CustomColor.primaryTextColor.withValues(alpha: 0.3),
      ),
    );
  }

  AnimatedContainer buildArrow({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: CustomImageWidget(
        height: 11.42,
        width: 7.17,
        color: index == selectedIndex.value
            ? CustomColor.blackColor
            : CustomColor.primaryTextColor.withValues(alpha: 0.5),
        path: Assets.icon.rightArrow,
      ),
    );
  }

  Row dotWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller
            .appSettingsModel!
            .data
            .appSettings
            .agent
            .onboardScreen
            .length,
        (index) => buildDot(index: index),
      ),
    );
  }

  InkWell arrowWidget() {
    return InkWell(
      onTap: () {
        pageNavigate();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller
              .appSettingsModel!
              .data
              .appSettings
              .agent
              .onboardScreen
              .length,
          (index) => buildArrow(index: index),
        ),
      ),
    );
  }
}
