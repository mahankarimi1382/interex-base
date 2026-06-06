// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/others/preview/amount_preview_widget.dart';
import 'package:qrpay/widgets/others/preview/information_amount_widget.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/utils/custom_snackbar.dart';
import '../../../controller/categories/money_in/money_in_controller.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import '../../../language/english.dart';
import '../../../routes/routes.dart';
import '../../../widgets/others/congratulation_widget.dart';

class MoneyInPreviewScreen extends StatelessWidget {
  MoneyInPreviewScreen({super.key});

  final controller = Get.put(MoneyInController());
  final dashBoardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.preview),
        body: _bodyWidget(context),
        bottomNavigationBar: _buttonWidget(context),
      ),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.8),
      physics: const BouncingScrollPhysics(),
      children: [
        _amountWidget(context),
        _amountInformationWidget(context),
      ],
    );
  }

  Widget _amountWidget(BuildContext context) {
    return previewAmount(
        amount:
            '${controller.senderAmountController.text} ${controller.selectSenderWallet.value?.currency.code}');
  }

  Widget _amountInformationWidget(BuildContext context) {
    int precision = controller.selectSenderWallet.value!.currency.type == 'FIAT'
        ? LocalStorage.getFiatPrecision()
        : LocalStorage.getCryptoPrecision();
    return amountInformationWidget(
      information: Strings.amountInformation,
      enterAmount: Strings.enterAmount,
      enterAmountRow:
          '${controller.senderAmountController.text} ${controller.selectSenderWallet.value?.currency.code}',
      fee: Strings.transferFee,
      feeRow:
          '${controller.totalFee.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value?.currency.code}',
      received: Strings.recipientReceived,
      receivedRow:
          '${controller.receiverAmountController.text} ${controller.selectReceiverWallet.value?.currency.code}',
      total: Strings.totalPayable,
      totalRow:
          '${(double.parse(controller.senderAmountController.text.isNotEmpty ? controller.senderAmountController.text : '0.0') + controller.totalFee.value)} ${controller.selectSenderWallet.value?.currency.code}',
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 2,
      ),
      child: Obx(
        () => controller.isMoneyInLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.confirm,
                onPressed: () {
                  if (dashBoardController.kycStatus.value == 1) {
                    controller.moneyInProcess().then(
                          (value) => StatusScreen.show(
                            context: context,
                            subTitle: Strings.yourmoneySenSuccess,
                            onPressed: () {
                              Get.offAllNamed(Routes.bottomNavBarScreen);
                            },
                          ),
                        );
                  } else {
                    CustomSnackBar.error(Strings.pleaseSubmitYourInformation);
                    Future.delayed(const Duration(seconds: 2), () {
                      Get.toNamed(Routes.updateKycScreen);
                    });
                  }
                },
              ),
      ),
    );
  }
}
