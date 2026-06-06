import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/controller/auth/login/signin_controller.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';

import '../../../controller/auth/login/sms_verification_controller.dart';
import '../../../language/english.dart';
import '../../../routes/routes.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size.dart';
import '../../../widgets/appbar/back_button.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/text_labels/title_heading2_widget.dart';
import '../../../widgets/text_labels/title_heading4_widget.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});
  final controller = Get.put(SMSVerificationController());
  final _otpFormKey = GlobalKey<FormState>();
  final signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: PopScope(
        onPopInvokedWithResult: (isTrue, value) {
          Get.offAllNamed(Routes.signInScreen);
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        _timerWidget(context),
        _continueButtonWidget(context),
      ],
    );
  }

  Container _titleAndSubtitleWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 3),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          TitleHeading2Widget(text: Strings.oTPVerification),
          verticalSpace(Dimensions.heightSize * 0.7),
          TitleHeading4Widget(
            text:
                "${Strings.enterTheOTPCodeSendTo} ${signInController.emailController.text}",
          ),
        ],
      ),
    );
  }

  Widget _inputWidget(BuildContext context) {
    return Form(
      key: _otpFormKey,
      child: Padding(
        padding: EdgeInsets.only(top: Dimensions.heightSize * 5),
        child: MaterialPinField(
          length: 6,
          pinController: controller.otpController,
          theme: MaterialPinTheme(
            borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),

            borderWidth: 2,
            borderColor: CustomColor.blackColor,
            focusedBorderColor: Theme.of(context).primaryColor,
            errorColor: CustomColor.redColor,

            textStyle: TextStyle(
              fontSize: Dimensions.headingTextSize2,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            cursorColor: Theme.of(context).primaryColor,
          ),

          onChanged: (value) {
            controller.changeCurrentText(value);
          },

          onCompleted: (value) {
            controller.changeCurrentText(value);
          },
        ),
      ),
    );
  }

  Obx _timerWidget(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time_outlined,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: Dimensions.widthSize * 0.4),
            CustomTitleHeadingWidget(
              text:
                  controller.secondsRemaining.value >= 0 &&
                      controller.secondsRemaining.value <= 9
                  ? '00:0${controller.secondsRemaining.value}'
                  : '00:${controller.secondsRemaining.value}',
              style: CustomStyle.darkHeading4TextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _continueButtonWidget(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => signInController.isLoading2
              ? const CustomLoadingAPI()
              : PrimaryButton(
                  title: Strings.submit,
                  onPressed: () {
                    if (_otpFormKey.currentState!.validate()) {
                      signInController.verifyEmailProcess(
                        otpCode: controller.otpController.text,
                      );
                    }
                  },
                ),
        ),
        verticalSpace(Dimensions.heightSize * 2),
        Obx(
          () => Visibility(
            visible: controller.enableResend.value,
            child: InkWell(
              onTap: () {
                signInController.sendOTPEmailProcess();
                controller.resendCode();
              },
              child: signInController.isSendOTPLoading
                  ? const CustomLoadingAPI()
                  : CustomTitleHeadingWidget(
                      text: Strings.resendCode,
                      style: CustomStyle.darkHeading4TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize3,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
