import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/controller/categories/deposit/deposti_controller.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';

import '../../../language/english.dart';
import '../../../widgets/others/customInput_widget.dart/deposit_keyboard.dart';
import '../../set_up_pin/controller/set_up_pin_controller.dart';

class DepositScreen extends StatelessWidget {
  DepositScreen({super.key});

  final controller = Get.put(DepositController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.addMoney),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  CustomAmountWidget _bodyWidget(BuildContext context) {
    return CustomAmountWidget(
      isLoading: controller.isInsertLoading.obs,
      buttonText: Strings.addMoney,
      onTap: () {
        debugPrint(controller.selectedCurrencyAlias.value);
        Get.find<SetUpPinController>().showPinDialog(
          context,
          onSuccess: () {
            if (controller.selectedCurrencyType.value.contains("AUTOMATIC")) {
              if (controller.selectedCurrencyAlias.contains('paypal')) {
                controller.addMoneyPaypalInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains(
                'flutterwave',
              )) {
                controller.addMoneyFlutterWaveInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains('stripe')) {
                debugPrint("Stripe is working");
                controller.addMoneyStripeInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains(
                'razorpay',
              )) {
                controller.addMoneyRazorPayInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains(
                'pagadito',
              )) {
                controller.addMoneyPagaditoInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains('ssl')) {
                controller.addMoneySslInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains(
                'coingate',
              )) {
                controller.addMoneyCoinGateInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains(
                'perfect-money',
              )) {
                controller.addMoneyPerfectMoneyInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains('bkash')) {
                controller.addMoneyBikashInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains('tatum')) {
                controller.tatumProcess();
              } else if (controller.selectedCurrencyAlias.contains(
                'paystack',
              )) {
                debugPrint("==============> this is working ");
                controller.addMoneyPayStackInsertProcess();
              } else if (controller.selectedCurrencyAlias.contains(
                'authorize-usd',
              )) {
                debugPrint("==============> this is working ");
                controller.addMoneyAuthorizeInsertProcess();
              }
            } else if (controller.selectedCurrencyType.value.contains(
              'MANUAL',
            )) {
              controller.manualPaymentGetGatewaysProcess();
            }
          },
        );
      },
    );
  }
}
