import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/backend/utils/custom_loading_api.dart';
import '/utils/dimensions.dart';
import '/utils/responsive_layout.dart';
import '/utils/size.dart';
import '/widgets/appbar/appbar_widget.dart';
import '/widgets/buttons/primary_button.dart';
import '../../../backend/local_storage/local_storage.dart';
import '../../../controller/categories/remittance/remitance_controller.dart';
import '../../../language/english.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../widgets/inputs/country_dropdown.dart';
import '../../../widgets/inputs/input_with_text.dart';
import '../../../widgets/inputs/receiving_method_drop_down.dart';
import '../../../widgets/inputs/recipient_drop_down.dart';
import '../../../widgets/others/limit_information_widget.dart';
import '../../../widgets/others/limit_widget.dart';
import '../../../widgets/text_labels/custom_title_heading_widget.dart';
import '../../set_up_pin/controller/set_up_pin_controller.dart';

class RemittanceScreen extends StatelessWidget {
  RemittanceScreen({super.key});

  final controller = Get.put(RemittanceController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.remittance),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Form _bodyWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.9,
        ),
        children: [
          _countryInput(context),
          _dropdownInput(context),
          _selectedInputWidget(context),
          _buttonWidget(context),
        ],
      ),
    );
  }

  Container _countryInput(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          CustomTitleHeadingWidget(
            text: Strings.fromCountry,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor
                  : CustomColor.primaryTextColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.8),
          CountryDropDown(
            selectMethod: controller.selectedSendingCountryCurrency,
            itemsList: controller.sendingCountryCurrencyList,
            onChanged: (value) {
              controller.selectedSendingCountryCurrency.value =
                  "${value!.name} (${value.code})";
              controller.sendingCountryId.value = value.id;
              controller.selectedSendingCountryCode.value = value.code;
              controller.fromCountriesRate.value = value.rate;
              controller.isCrypto1.value = value.type == "CRYPTO";
              debugPrint("=======> ${value.type}");
              controller.senderSendAmount;
              // controller.recipientGet;
              controller.remainingController.senderCurrency.value = value.code;
              controller.remainingController.getRemainingBalanceProcess();
              controller.remittanceGetRecipientProcess();
              controller.remittanceSenderRecipientProcess();
              controller.getRate();
            },
          ),

          verticalSpace(Dimensions.heightSize * 0.5),
          CustomTitleHeadingWidget(
            text: Strings.toCountry,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor
                  : CustomColor.primaryTextColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.8),
          CountryDropDown(
            selectMethod: controller.selectedReceivingCountryCurrency,
            itemsList: controller.receivingCountryCurrencyList,
            onChanged: (value) {
              controller.selectedReceivingCountryCurrency.value =
                  "${value!.name} (${value.code})";
              controller.receivingCountryId.value = value.id;
              controller.selectedReceivingCountryCode.value = value.code;
              controller.toCountriesRate.value = value.rate;
              controller.isCrypto2.value = value.type == "CRYPTO";
              controller.recipientGet;
              controller.remittanceGetRecipientProcess();
              controller.remittanceSenderRecipientProcess();
              controller.getRate();
            },
          ),
        ],
      ),
    );
  }

  Column _dropdownInput(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        verticalSpace(Dimensions.heightSize * 0.5),
        //!receiving method
        CustomTitleHeadingWidget(
          text: Strings.transactionType,
          style: CustomStyle.labelTextStyle.copyWith(
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor
                : CustomColor.primaryTextColor,
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.5),
        ReceivingMethodDropDown(
          onChanged: (value) {
            controller.selectedMethod.value = value!.labelName;
            controller.selectedTrxType.value = value.fieldName;
            controller.remittanceGetRecipientProcess();
            controller.remittanceSenderRecipientProcess();
          },
          itemsList: controller.transactionTypeList,
          selectMethod: controller.selectedMethod,
        ),
        verticalSpace(Dimensions.heightSize * 0.8),

        CustomTitleHeadingWidget(
          text: Strings.senderRecipient,
          style: CustomStyle.labelTextStyle.copyWith(
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor
                : CustomColor.primaryTextColor,
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.5),

        ///  get sender recipient
        Row(
          children: [
            Expanded(
              flex: 9,
              child: RecipientDropDown(
                onChanged: (value) {
                  controller.selectedSenderRecipient.value =
                      "${value!.firstname} ${value.lastname}";
                  controller.selectedSenderRecipientId.value = value.id;
                },
                itemsList: controller.senderRecipientList,
                selectMethod: controller.selectedSenderRecipient,
              ),
            ),
            horizontalSpace(Dimensions.widthSize * 0.5),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: (() {
                  Get.toNamed(Routes.addMySenderRecipientScreen);
                }),
                child: Container(
                  height: Dimensions.heightSize * 3.2,
                  width: Dimensions.widthSize * 8.2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 0.5,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: CustomTitleHeadingWidget(
                    text: Strings.addPlus,
                    style: CustomStyle.lightHeading4TextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.headingTextSize3,
                      color: CustomColor.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize * 0.5),
        CustomTitleHeadingWidget(
          text: Strings.receiverRecipient,
          style: CustomStyle.labelTextStyle.copyWith(
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor
                : CustomColor.primaryTextColor,
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.5),

        /// Receiver
        Row(
          children: [
            Expanded(
              flex: 9,
              child: RecipientDropDown(
                onChanged: (value) {
                  controller.selectedRecipient.value =
                      "${value!.firstname} ${value.lastname}";
                  controller.selectedRecipientId.value = value.id;
                },
                itemsList: controller.recipientList,
                selectMethod: controller.selectedRecipient,
              ),
            ),
            horizontalSpace(Dimensions.widthSize * 0.5),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: (() {
                  Get.toNamed(Routes.addRecipientScreen);
                }),
                child: Container(
                  height: Dimensions.heightSize * 3.2,
                  width: Dimensions.widthSize * 8.2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 0.5,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: CustomTitleHeadingWidget(
                    text: Strings.addPlus,
                    style: CustomStyle.lightHeading4TextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.headingTextSize3,
                      color: CustomColor.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize * 0.9),
      ],
    );
  }

  Column _selectedInputWidget(BuildContext context) {
    final currency = controller.baseCurrency.value;
    final int precision = !controller.isCrypto1.value
        ? LocalStorage.getFiatPrecision()
        : LocalStorage.getCryptoPrecision();
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        InputWithText(
          hint: Strings.zero00,
          suffixText: controller.selectedSendingCountryCode.value.toString(),
          controller: controller.amountController,
          label: Strings.sendingAmount,
          onChanged: (amount) {
            if (controller.amountController.text.isEmpty) {
              controller.amountController.text = "";
            } else {
              controller.remainingController.senderAmount.value =
                  controller.amountController.text;
              controller.remainingController.getRemainingBalanceProcess();
            }
            controller.recipientGet;
            controller.getFee(rate: controller.fromCountriesRate.value);
          },
        ),
        verticalSpace(Dimensions.heightSize * 0.3),
        if (controller.selectedTrxType.value == 'bank-transfer') ...[
          LimitWidget(
            showExchangeRate: true,
            exchangeRate:
                "1 ${controller.selectedSendingCountryCode.value} - ${controller.exchangeRate.value.toStringAsFixed(precision)} ${controller.selectedReceivingCountryCode.value} ",

            fee:
                "${controller.totalFee.value.toStringAsFixed(precision)} $currency",
            limit:
                "${controller.minLimit.value.toStringAsFixed(precision)} $currency - ${controller.maxLimit.value.toStringAsFixed(precision)} $currency ",
          ),
        ] else ...[
          LimitWidget(
            showExchangeRate: true,
            exchangeRate:
                "1 ${controller.selectedSendingCountryCode.value} - ${controller.exchangeRate.value.toStringAsFixed(precision)} ${controller.selectedReceivingCountryCode.value} ",
            fee:
                "${controller.totalFee.value.toStringAsFixed(precision)} $currency",
            limit:
                "${controller.minLimit.value.toStringAsFixed(precision)} $currency - ${controller.maxLimit.value.toStringAsFixed(precision)} $currency ",
          ),
        ],

        verticalSpace(Dimensions.heightSize * 0.3),
        LimitInformationWidget(
          showDailyLimit: controller.dailyLimit.value == 0.0 ? false : true,
          showMonthlyLimit: controller.monthlyLimit.value == 0.0 ? false : true,
          transactionLimit:
              '${controller.minLimit.value.toStringAsFixed(precision)} - ${controller.maxLimit.value.toStringAsFixed(precision)} ${controller.selectedSendingCountryCode.value} ',
          dailyLimit:
              '${controller.dailyLimit.value.toStringAsFixed(precision)} ${controller.selectedSendingCountryCode.value} ',
          remainingDailyLimit:
              '${controller.remainingController.remainingDailyLimit.value.toStringAsFixed(precision)} ${controller.selectedSendingCountryCode.value} ',
          monthlyLimit:
              '${controller.monthlyLimit.value.toStringAsFixed(precision)} ${controller.selectedSendingCountryCode.value} ',
          remainingMonthLimit:
              '${controller.remainingController.remainingMonthLyLimit.value.toStringAsFixed(precision)} ${controller.selectedSendingCountryCode.value} ',
        ),
        verticalSpace(Dimensions.heightSize * 0.5),
        InputWithText(
          hint: Strings.zero00,
          suffixText: controller.selectedReceivingCountryCode.value.toString(),
          controller: controller.recipientGetController,
          label: Strings.recipientAmount,
          onChanged: (amount) {
            controller.senderSendAmount;
          },
        ),
      ],
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical),
      child: PrimaryButton(
        buttonColor:
            double.parse(controller.remainingController.senderAmount.value) >
                    0 &&
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
          if (double.parse(controller.remainingController.senderAmount.value) >
                  0 &&
              double.parse(controller.remainingController.senderAmount.value) <=
                  controller.dailyLimit.value &&
              double.parse(controller.remainingController.senderAmount.value) <=
                  controller.monthlyLimit.value) {
            Get.find<SetUpPinController>().showPinDialog(
              context,
              onSuccess: () {
                controller.togoRemittancePreview();
              },
            );
          }
        },
      ),
    );
  }
}
