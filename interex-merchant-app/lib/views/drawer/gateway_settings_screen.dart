import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';

import '../../backend/utils/custom_loading_api.dart';
import '../../controller/drawer/gateway_settings_controller.dart';
import '../../utils/custom_color.dart';
import '../../utils/strings.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/primary_input_filed.dart';
import '../../widgets/text_labels/title_heading3_widget.dart';
import '../../widgets/text_labels/title_heading4_widget.dart';

class GatewaySettingsScreen extends StatelessWidget {
  GatewaySettingsScreen({super.key});

  final controller = Get.put(GatewaySettingsController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: Strings.gatewaySettings.tr),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  SingleChildScrollView _bodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: crossStart,
        children: [_titleWidget(context), _settingsWidget(context)],
      ),
    );
  }

  Container _titleWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.7,
        vertical: Dimensions.marginSizeVertical * 0.7,
      ),
      child: TitleHeading3Widget(
        text: Strings.allSettings.tr,
        fontWeight: FontWeight.w600,
        fontSize: Dimensions.headingTextSize2,
        color: Get.isDarkMode
            ? CustomColor.primaryDarkTextColor
            : CustomColor.primaryLightTextColor,
      ),
    );
  }

  Column _settingsWidget(BuildContext context) {
    return Column(
      children: [
        settingsItemWidget(
          context,
          title: Strings.walletBalance.tr,
          checkBoxValue: controller.walletBalanceEnable,
          onChanged: (value) => {
            controller.walletBalanceEnable.value = value,
            controller.updateWalletStatusProcess(
              value: controller.walletBalanceEnable.value ? '1' : '0',
            ),
          },
        ),
        verticalSpace(Dimensions.heightSize),
        settingsItemWidget(
          context,
          title: Strings.virtualCard.tr,
          checkBoxValue: controller.virtualCardEnable,
          onChanged: (value) => {
            controller.virtualCardEnable.value = value,
            controller.updateVirtualCardStatusProcess(
              value: controller.virtualCardEnable.value ? '1' : '0',
            ),
          },
        ),
        verticalSpace(Dimensions.heightSize),
        settingsItemWidget(
          context,
          title: Strings.masterOrVisaCard.tr,
          checkBoxValue: controller.masterCardOrVisaCardEnable,
          onChanged: (value) => {
            controller.masterCardOrVisaCardEnable.value = value,
            if (controller.masterCardOrVisaCardEnable.value == false)
              {controller.updateMasterCardStatusProcess(value: '0')},
          },
        ),
        Obx(() {
          return Visibility(
            visible: controller.masterCardOrVisaCardEnable.value,
            child: _inputWidget(context),
          );
        }),
      ],
    );
  }

  Container settingsItemWidget(
    BuildContext context, {
    required RxBool checkBoxValue,
    required String title,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.7,
      ),
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.7),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? CustomColor.primaryBGDarkColor
            : CustomColor.primaryBGLightColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 13,
            child: Obx(() {
              return Switch(
                // thumb color (round icon)
                activeThumbColor: CustomColor.whiteColor,
                activeTrackColor: Theme.of(context).primaryColor,
                inactiveThumbColor: Colors.blueGrey.shade600,
                inactiveTrackColor: Colors.grey.shade400,
                splashRadius: Dimensions.radius * 5,
                // boolean variable value
                value: checkBoxValue.value,
                // changes the state of the switch
                onChanged: onChanged,
              );
            }),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: Dimensions.marginSizeVertical * 0.5,
                  bottom: Dimensions.marginSizeVertical * 0.5,
                ),
                child: Column(
                  crossAxisAlignment: crossStart,
                  children: [
                    TitleHeading3Widget(
                      text: title,
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.headingTextSize3,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor
                          : CustomColor.primaryLightTextColor,
                    ),
                    verticalSpace(Dimensions.heightSize * 0.5),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: Dimensions.iconSizeDefault * 0.8,
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.4),
                        ),
                        horizontalSpace(Dimensions.widthSize * 0.2),
                        TitleHeading4Widget(
                          text: Strings.enableOrDisableThisFeatures.tr,
                          fontWeight: FontWeight.w500,
                          fontSize: Dimensions.headingTextSize5,
                          opacity: 0.7,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _inputWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.7,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: crossStart,
          children: [
            verticalSpace(Dimensions.heightSize),
            PrimaryInputWidget(
              controller: controller.primaryKeyController,
              hint: Strings.primaryKey.tr,
              label: Strings.primaryKey.tr,
            ),
            verticalSpace(Dimensions.heightSize * 0.7),
            PrimaryInputWidget(
              controller: controller.secretKeyController,
              hint: Strings.secretKey.tr,
              label: Strings.secretKey.tr,
            ),
            verticalSpace(Dimensions.heightSize * 0.7),
            Obx(
              () => controller.isChangeLoading
                  ? const CustomLoadingAPI()
                  : SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.35,
                      child: PrimaryButton(
                        title: Strings.submit.tr,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.updateKeyProcess(
                              pk: controller.primaryKeyController.text,
                              sk: controller.secretKeyController.text,
                            );
                          }
                        },
                        borderColor: Theme.of(context).primaryColor,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
