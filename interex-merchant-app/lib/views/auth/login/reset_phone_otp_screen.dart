import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qrpay/controller/auth/login/signin_controller.dart';
import 'package:qrpay/widgets/inputs/primary_input_filed.dart';
import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/auth/login/otp_reset_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size.dart';
import '../../../utils/strings.dart';
import '../../../widgets/appbar/back_button.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/text_labels/custom_title_heading_widget.dart';
import '../../../widgets/text_labels/title_heading2_widget.dart';
import '../../../widgets/text_labels/title_heading4_widget.dart';

class ResetPhoneOtpScreen extends StatelessWidget {
  ResetPhoneOtpScreen({super.key});
  final controller = Get.put(ResetOtpController());
  final _otpFormKey = GlobalKey<FormState>();
  final signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            Get.toNamed(Routes.signInScreen);
            signInController.emailForgotController.clear();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: BackButtonWidget(
              onTap: () {
                Get.toNamed(Routes.signInScreen);
                signInController.emailForgotController.clear();
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
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 3,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          TitleHeading2Widget(text: Strings.oTPVerification),
          verticalSpace(Dimensions.heightSize * 0.7),
          Column(
            crossAxisAlignment: crossStart,
            children: [
              const TitleHeading4Widget(
                text: Strings.enterTheOTPCodeSendTo,
              ),
              TitleHeading4Widget(
                text: signInController.emailForgotController.text,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Form _inputWidget(BuildContext context) {
    return Form(
      key: _otpFormKey,
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.heightSize * 5,
            ),
            child: PinCodeTextField(
              errorTextSpace: Dimensions.heightSize * 2,
              cursorColor: CustomColor.primaryLightColor,
              controller: controller.otpController,
              appContext: context,
              length: 6,
              obscureText: false,
              keyboardType: TextInputType.number,
              textStyle: const TextStyle(color: CustomColor.primaryLightColor),
              animationType: AnimationType.fade,
              validator: (v) {
                if (v!.length < 3) {
                  return Strings.pleaseFillOutTheField.translation;
                } else {
                  return null;
                }
              },
              pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
                  selectedColor: CustomColor.primaryLightColor,
                  activeColor: CustomColor.primaryLightColor,
                  inactiveColor: CustomColor.blackColor,
                  fieldHeight: 50,
                  fieldWidth: 48,
                  errorBorderColor: CustomColor.redColor,
                  activeFillColor: CustomColor.transparent,
                  borderWidth: 2,
                  fieldOuterPadding: const EdgeInsets.all(1)),
              onChanged: (value) {
                controller.changeCurrentText(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Obx _timerWidget(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Visibility(
              visible: controller.enableResend.value,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              )),
          Visibility(
            visible: !controller.enableResend.value,
            child: Container(
              margin:
                  EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.access_time_outlined,
                    color: CustomColor.primaryLightColor,
                  ),
                  SizedBox(width: Dimensions.widthSize * 0.4),
                  CustomTitleHeadingWidget(
                    text: controller.secondsRemaining.value >= 0 &&
                            controller.secondsRemaining.value <= 9
                        ? '00:0${controller.secondsRemaining.value}'
                        : '00:${controller.secondsRemaining.value}',
                    style: CustomStyle.darkHeading4TextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: CustomColor.primaryLightColor),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                      signInController.resendForgotPhoneOtpVerifyProcess(
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
                signInController.resendForgotPhoneOtpProcess();
                controller.resendCode();
              },
              child: signInController.isSendOTPLoading
                  ? const CustomLoadingAPI()
                  : CustomTitleHeadingWidget(
                      text: Strings.resendCode,
                      style: CustomStyle.darkHeading4TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize3,
                        color: CustomColor.primaryLightColor,
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
