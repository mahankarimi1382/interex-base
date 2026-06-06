// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../custom_assets/assets.gen.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/custom_color.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/size.dart';
import '../../../../utils/strings.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/pay_link/primary_input_widget.dart';
import '../../../../widgets/text_labels/title_heading2_widget.dart';
import '../../../../widgets/text_labels/title_heading4_widget.dart';

class ShareLinkScreenMobile extends StatelessWidget {
  const ShareLinkScreenMobile({
    super.key,
    required this.title,
    required this.onTap,
    required this.controller,
    this.isCenterText = true,
    required this.btnName,
    required this.onButtonTap,
  });

  final String title, btnName;
  final VoidCallback onTap;
  final VoidCallback onButtonTap;
  final bool isCenterText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.bottomNavBarScreen);
        return true;
      },
      child: Scaffold(
        body: _bodyWidget(
          context,
        ),
      ),
    );
  }

  // body widget containing all widget elements
  SizedBox _bodyWidget(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _congratulationImageWidget(
            context,
          ),
          verticalSpace(Dimensions.heightSize * 2),
          _congratulationInfoWidget(
            context,
          ),
          verticalSpace(Dimensions.heightSize * 1.33),
          _buttonWidget(context),
        ],
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.marginSizeHorizontal),
      child: Column(
        children: [
          PrimaryButton(
            title: btnName,
            onPressed: onButtonTap,
          ),
          verticalSpace(Dimensions.heightSize * 2),
          Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Get.offAllNamed(Routes.bottomNavBarScreen);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: Dimensions.paddingVerticalSize),
                  child: const TitleHeading4Widget(
                    text: Strings.backtoHome,
                    fontWeight: FontWeight.w600,
                    color: CustomColor.primaryLightColor,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  SvgPicture _congratulationImageWidget(
    BuildContext context,
  ) {
    return SvgPicture.asset(
      Assets.clipart.confirmation,
    );
  }

  Container _congratulationInfoWidget(
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.marginSizeHorizontal),
      child: Column(
        crossAxisAlignment: isCenterText ? crossCenter : crossStart,
        mainAxisAlignment: isCenterText ? mainCenter : mainCenter,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.marginSizeHorizontal),
            child: TitleHeading2Widget(
              text: title,
              color: CustomColor.primaryLightTextColor,
              fontWeight: FontWeight.w600,
              textAlign: isCenterText ? TextAlign.center : TextAlign.start,
            ),
          ),
          verticalSpace(Dimensions.marginBetweenInputTitleAndBox * 3),
          PrimaryInputField(
            controller: controller,
            hintText: "",
            label: Strings.copyLink,
            fillColor: CustomColor.whiteColor,
            readOnly: true,
            suffixIcon: _customCopyWidget(),
          )
        ],
      ),
    );
  }

  InkWell _customCopyWidget() {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Dimensions.widthSize * 6,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Dimensions.radius * 0.5),
            bottomRight: Radius.circular(Dimensions.radius * 0.5),
          ),
          color: Theme.of(Get.context!).primaryColor,
        ),
        child: Icon(Icons.copy,
            color: CustomColor.whiteColor, size: Dimensions.heightSize * 1.5),
      ),
    );
  }
}
