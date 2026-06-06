// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/widgets/inputs/password_input_widget.dart';
import 'package:qrpay/widgets/text_labels/title_heading2_widget.dart';
import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/auth/login/reset_password_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size.dart';
import '../../../utils/strings.dart';
import '../../../widgets/appbar/back_button.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/others/congratulation_widget.dart';
import '../../../widgets/text_labels/title_heading4_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final controller = Get.put(ResetPasswordController());

  final _resetFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: WillPopScope(
        onWillPop: () async {
          Get.offAllNamed(Routes.signInScreen);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: CustomColor.primaryLightScaffoldBackgroundColor,
            leading: BackButtonWidget(
              onTap: () {
                Get.toNamed(Routes.signInScreen);
              },
            ),
          ),
          body: _bodyWidget(context),
        ),
      ),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(Dimensions.paddingSize),
      physics: const BouncingScrollPhysics(),
      children: [
        _titleAndSubtitleWidget(context),
        _inputWidget(context),
        _continueButtonWidget(context),
      ],
    );
  }

  Container _titleAndSubtitleWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 0.1,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          TitleHeading2Widget(text: Strings.resetPassword.tr),
          verticalSpace(Dimensions.heightSize * 0.7),
          TitleHeading4Widget(
            text: Strings.resetPasswordDetails.tr,
          )
        ],
      ),
    );
  }

  Container _inputWidget(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 1.4),
      child: Form(
        key: _resetFormKey,
        child: Column(
          mainAxisAlignment: mainCenter,
          children: [
            PasswordInputWidget(
              controller: controller.newPasswordController,
              hint: Strings.enterNewPassword.tr,
              label: Strings.newPassword.tr,
            ),
            verticalSpace(Dimensions.heightSize),
            PasswordInputWidget(
              controller: controller.confirmPasswordController,
              hint: Strings.enterConfirmPassword.tr,
              label: Strings.confirmPassword.tr,
            ),
          ],
        ),
      ),
    );
  }

  Column _continueButtonWidget(BuildContext context) {
    return Column(
      children: [
        Obx(() => controller.isLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.resetPassword.tr,
                onPressed: () {
                  if (_resetFormKey.currentState!.validate()) {
                    controller.resetApiProcess().then(
                          (value) => StatusScreen.show(
                              context: context,
                              subTitle: Strings.yourPasswordHasBeen.tr,
                              onPressed: () {
                                Get.offAllNamed(Routes.signInScreen);
                              }),
                        );
                  }
                },
              )),
        verticalSpace(Dimensions.heightSize * 2),
      ],
    );
  }
}
