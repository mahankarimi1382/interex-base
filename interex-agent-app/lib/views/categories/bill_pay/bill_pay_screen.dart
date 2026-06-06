import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/utils/custom_loading_api.dart';
import '/controller/app_settings/app_settings_controller.dart';
import '/utils/dimensions.dart';
import '/utils/responsive_layout.dart';
import '/utils/size.dart';
import '/widgets/appbar/appbar_widget.dart';
import '/widgets/buttons/primary_button.dart';
import '/widgets/dropdown/input_dropdown.dart';
import '/widgets/inputs/primary_input_filed.dart';
import '/widgets/others/limit_widget.dart';
import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/model/wallet/wallets_model.dart';
import '../../../backend/utils/custom_snackbar.dart';
import '../../../controller/categories/bill_pay/bill_pay_controller.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import '../../../language/english.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../widgets/dropdown/custom_input_drop_down.dart';
import '../../../widgets/inputs/primary_text_input_widget.dart';
import '../../../widgets/others/congratulation_widget.dart';
import '../../../widgets/others/limit_information_widget.dart';
import '../../../widgets/text_labels/custom_title_heading_widget.dart';
import '../../set_up_pin/controller/set_up_pin_controller.dart';

class BillPayScreen extends StatelessWidget {
  BillPayScreen({super.key});

  final controller = Get.put(BillPayController());
  final dashboardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.billPay),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  RefreshIndicator _bodyWidget(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getBillPayInfoData();
      },
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal,
        ),
        children: [_inputWidget(context), _buttonWidget(context)],
      ),
    );
  }

  // Drop down input, bill number input ,and amount input
  Container _inputWidget(BuildContext context) {
    final int precision =
        controller.selectMainWallet.value!.currency.type == 'FIAT'
        ? LocalStorage.getFiatPrecision()
        : LocalStorage.getCryptoPrecision();
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 1.5),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          CustomTitleHeadingWidget(
            text: Strings.billType.tr,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.7)
                  : CustomColor.primaryTextColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.5),
          CustomInputDropDown(
            itemsList: controller.billList,
            selectMethod: controller.billMethodselected,
            onChanged: ((v) {
              controller.billMethodselected.value = v!.name!;
              controller.automaticCharge.value = v.localTransactionFee!;
              controller.automaticMin.value = v.minLocalTransactionAmount!;
              controller.automaticMax.value = v.maxLocalTransactionAmount!;

              // Rate & currency get
              controller.automaticRate.value = v.receiverCurrencyRate!;
              controller.automaticSelectedCurrency.value =
                  v.receiverCurrencyCode!;
              controller.getExchangeRate(r: v.receiverCurrencyRate);

              if (v.itemType == "AUTOMATIC") {
                controller.isAutomatic.value = true;
                controller.exchangeRateUpdate();
                controller.getAutomaticFee();
              } else {
                controller.isAutomatic.value = false;
                controller.getFee(rate: controller.rate.value);
              }
            }),
          ),
          verticalSpace(Dimensions.heightSize),
          _billMonthWidget(context),
          //bill number input
          PrimaryInputWidget(
            controller: controller.billNumberController,
            hint: Strings.enterBillNumber.tr,
            label: Strings.billNumber,
            keyboardType: TextInputType.number,
          ),
          verticalSpace(Dimensions.heightSize),
          PrimaryTextInputWidget(
            keyboardType: TextInputType.number,
            controller: controller.amountController,
            hint: Strings.zero00,
            labelText: Strings.amount,
            onChanged: (v) {
              if (controller.isAutomatic.value) {
                controller.exchangeRateUpdate();
                controller.remainingController.getRemainingBalanceProcess();
                controller.getAutomaticFee();
              } else {
                controller.getFee(rate: controller.rate.value);
              }
            },
            suffixIcon: Container(
              height: Dimensions.inputBoxHeight,
              alignment: Alignment.center,
              width: Dimensions.widthSize * 7.5,
              decoration: BoxDecoration(
                color: CustomColor.primaryLightColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius * 0.5),
                  bottomRight: Radius.circular(Dimensions.radius * 0.5),
                ),
              ),
              child: Obx(
                () => DropdownButton<MainUserWallet>(
                  hint: Text(
                    controller.selectMainWallet.value!.currency.code,
                    style: GoogleFonts.inter(
                      color: CustomColor.whiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  iconEnabledColor: CustomColor.whiteColor,
                  iconSize: Dimensions.heightSize * 1.5,
                  dropdownColor: CustomColor.primaryLightColor,
                  underline: Container(),
                  items: controller.walletsList
                      .map<DropdownMenuItem<MainUserWallet>>((value) {
                        return DropdownMenuItem<MainUserWallet>(
                          value: value,
                          child: Text(
                            value.currency.code,
                            style: GoogleFonts.inter(
                              color: CustomColor.whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      })
                      .toList(),
                  onChanged: (MainUserWallet? value) {
                    controller.selectMainWallet.value = value!;
                    controller.isCrypto.value = value.currency.type == "CRYPTO";
                    controller.rate.value = double.parse(value.currency.rate);
                    controller.getFee(rate: double.parse(value.currency.rate));
                    controller.remainingController.senderCurrency.value =
                        value.currency.code;
                    controller.remainingController.getRemainingBalanceProcess();
                    controller.getFee(rate: double.parse(value.currency.rate));
                    controller.exchangeRateUpdate();
                    controller.getAutomaticFee();
                    controller.dailyLimit.value =
                        controller
                            .billPayInfoData
                            .data
                            .billPayCharge
                            .dailyLimit *
                        double.parse(value.currency.rate);
                    controller.monthlyLimit.value =
                        controller
                            .billPayInfoData
                            .data
                            .billPayCharge
                            .monthlyLimit *
                        double.parse(value.currency.rate);
                  },
                ),
              ),
            ),
          ),

          Obx(() {
            final int cryptoPrecision = Get.find<AppSettingsController>()
                .appSettingsModel
                .data
                .appSettings
                .agent
                .basicSettings
                .cryptoPrecisionValue;
            final int fiatPrecision = Get.find<AppSettingsController>()
                .appSettingsModel
                .data
                .appSettings
                .agent
                .basicSettings
                .fiatPrecisionValue;
            return controller.isAutomatic.value
                ? LimitWidget(
                    fee:
                        '${controller.automaticTotalFee.value.toStringAsFixed(controller.isCrypto.value ? cryptoPrecision : fiatPrecision)} ${controller.selectMainWallet.value!.currency.code}',
                    limit:
                        '${controller.automaticLimitMin.value.toStringAsFixed(controller.isCrypto.value ? cryptoPrecision : fiatPrecision)} - ${controller.automaticLimitMax.value.toStringAsFixed(controller.isCrypto.value ? cryptoPrecision : fiatPrecision)} ${controller.selectMainWallet.value!.currency.code}',
                  )
                : LimitWidget(
                    fee:
                        '${controller.totalFee.value.toStringAsFixed(controller.isCrypto.value ? cryptoPrecision : fiatPrecision)} ${controller.selectMainWallet.value!.currency.code}',
                    limit:
                        '${controller.manualLimitMin.value.toStringAsFixed(controller.isCrypto.value ? cryptoPrecision : fiatPrecision)} - ${controller.manualLimitMax.value.toStringAsFixed(controller.isCrypto.value ? cryptoPrecision : fiatPrecision)} ${controller.selectMainWallet.value!.currency.code}',
                  );
          }),

          LimitInformationWidget(
            showDailyLimit: controller.dailyLimit.value == 0.0 ? false : true,
            showMonthlyLimit: controller.monthlyLimit.value == 0.0
                ? false
                : true,
            transactionLimit:
                '${controller.limitMin.value.toStringAsFixed(precision)} - ${controller.limitMax.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
            dailyLimit:
                '${controller.dailyLimit.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
            monthlyLimit:
                '${controller.monthlyLimit.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
            remainingMonthLimit:
                '${controller.remainingController.remainingMonthLyLimit.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
            remainingDailyLimit:
                '${controller.remainingController.remainingDailyLimit.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
          ),
        ],
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 2),
      child: controller.isInsertLoading
          ? const CustomLoadingAPI()
          : PrimaryButton(
              title: Strings.payBill.tr,
              onPressed: () {
                if (dashboardController.kycStatus.value == 1) {
                  Get.find<SetUpPinController>().showPinDialog(
                    context,
                    onSuccess: () {
                      controller.type.value = controller.getType(
                        controller.billMethodselected.value,
                      )!;
                      controller
                          .billPayApiProcess(
                            amount: controller.amountController.text,
                            billNumber: controller.billNumberController.text,
                            type: controller.type.value,
                          )
                          .then(
                            (value) => StatusScreen.show(
                              // ignore: use_build_context_synchronously
                              context: context,
                              subTitle: Strings.yourBillPaySuccess.tr,
                              onPressed: () {
                                Get.offAllNamed(Routes.bottomNavBarScreen);
                              },
                            ),
                          );
                    },
                  );
                } else {
                  CustomSnackBar.error(Strings.pleaseSubmitYourInformation);
                  Future.delayed(const Duration(seconds: 2), () {
                    Get.toNamed(Routes.updateKycScreen);
                  });
                }
              },
            ),
    );
  }

  Column _billMonthWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        CustomTitleHeadingWidget(
          text: Strings.billMonths.tr,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.7)
                : CustomColor.primaryTextColor,
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.5),
        InputDropDown(
          itemsList: controller.billMonthsList,
          selectMethod: controller.selectedBillMonths,
          onChanged: ((v) => controller.selectedBillMonths.value = v!),
        ),
        verticalSpace(Dimensions.heightSize),
      ],
    );
  }
}
