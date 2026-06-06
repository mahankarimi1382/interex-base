import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/local_storage/local_storage.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/custom_assets/assets.gen.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/inputs/input_with_dropdown.dart';
import 'package:qrpay/widgets/inputs/primary_input_filed.dart';

import '../../../controller/categories/send_money/send_money_controller.dart';
import '../../../language/english.dart';
import '../../../widgets/inputs/copy_with_input.dart';
import '../../../widgets/others/limit_information_widget.dart';
import '../../../widgets/text_labels/title_heading5_widget.dart';
import '../../set_up_pin/controller/set_up_pin_controller.dart';

class MoneyTransferScreen extends StatelessWidget {
  MoneyTransferScreen({super.key});

  final controller = Get.put(SendMoneyController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.sendMoney),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.9),
      physics: const BouncingScrollPhysics(),
      children: [
        _inputWidget(context),
        _limitInformation(context),
        _buttonWidget(context),
      ],
    );
  }

  Container _inputWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 1.6),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CopyInputWidget(
                  suffixIcon: Assets.icon.scan,
                  suffixColor: CustomColor.primaryLightColor,
                  onTap: () {
                    Get.toNamed(Routes.qRCodeScreen);
                  },
                  controller: controller.copyInputController,
                  hint: Strings.enterEmailPhone,
                  label: Strings.phoneEmail,
                ),
                Obx(() {
                  return TitleHeading5Widget(
                    text: controller.checkUserMessage.value,
                    color: controller.isValidUser.value
                        ? CustomColor.greenColor
                        : CustomColor.redColor,
                  );
                }),
              ],
            ),
            verticalSpace(Dimensions.heightSize),
            SendMoneyInputWithDropdown(
              controller: controller.senderAmountController,
              hint: Strings.zero00,
              label: Strings.senderAmount,
              selectWallet: controller.selectSenderWallet,
            ),
            verticalSpace(Dimensions.heightSize),
            SendMoneyInputWithDropdown(
              controller: controller.receiverAmountController,
              hint: Strings.zero00,
              label: Strings.receiverAmount,
              selectWallet: controller.selectReceiverWallet,
            ),
            verticalSpace(Dimensions.heightSize),
            PrimaryInputWidget(
              controller: controller.remarkController,
              hint: Strings.enterRemark,
              isValidator: false,
              label:
                  "${Strings.remark.translation} (${Strings.optional.translation})",
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }

  LimitInformationWidget _limitInformation(BuildContext context) {
    final int precision =
        controller.selectSenderWallet.value!.currency.type == 'FIAT'
        ? LocalStorage.getFiatPrecision()
        : LocalStorage.getCryptoPrecision();

    return LimitInformationWidget(
      showDailyLimit: controller.dailyLimit.value == 0.0 ? false : true,
      showMonthlyLimit: controller.monthlyLimit.value == 0.0 ? false : true,
      transactionLimit:
          '${controller.limitMin.value.toStringAsFixed(precision)} - ${controller.limitMax.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
      dailyLimit:
          '${controller.dailyLimit.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
      monthlyLimit:
          '${controller.monthlyLimit.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
      remainingMonthLimit:
          '${controller.remainingController.remainingMonthLyLimit.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
      remainingDailyLimit:
          '${controller.remainingController.remainingDailyLimit.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 1,
        bottom: Dimensions.marginSizeVertical,
      ),
      child: Obx(
        () => controller.isSendMoneyLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                buttonColor:
                    controller.isValidUser.value &&
                        double.parse(
                              controller.remainingController.senderAmount.value,
                            ) <=
                            controller.dailyLimit.value &&
                        double.parse(
                              controller.remainingController.senderAmount.value,
                            ) <=
                            controller.monthlyLimit.value
                    ? CustomColor.primaryLightColor
                    : CustomColor.primaryLightColor.withValues(alpha: 0.3),
                title: Strings.send,
                onPressed: () {
                  if (controller.isValidUser.value &&
                      double.parse(
                            controller.remainingController.senderAmount.value,
                          ) <=
                          controller.dailyLimit.value &&
                      double.parse(
                            controller.remainingController.senderAmount.value,
                          ) <=
                          controller.monthlyLimit.value) {
                    /// pin verify check
                    Get.find<SetUpPinController>().showPinDialog(
                      context,
                      onSuccess: () {
                        Get.toNamed(Routes.sendMoneyPreviewScreen);
                      },
                    );
                  }
                },
              ),
      ),
    );
  }
}
