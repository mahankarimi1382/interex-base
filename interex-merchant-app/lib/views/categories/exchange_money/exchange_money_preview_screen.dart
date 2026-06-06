import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/others/preview/amount_preview_widget.dart';
import 'package:qrpay/widgets/others/preview/information_amount_widget.dart';

import '../../../controller/categories/money_exchange/money_exchange_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/size.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/others/congratulation_widget.dart';
import '../../../widgets/text_labels/title_heading3_widget.dart';
import '../../../widgets/text_labels/title_heading4_widget.dart';

class ExchangeMoneyPreviewScreen extends StatelessWidget {
  ExchangeMoneyPreviewScreen({super.key});

  final controller = Get.put(MoneyExchangeController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.preview),
        body: _bodyWidget(context),
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
        _buttonWidget(context),
      ],
    );
  }

  Widget _amountWidget(BuildContext context) {
    return previewAmount(
      amount:
          '${controller.exchangeFromAmountController.text} ${controller.selectFromWallet.value!.currency.code}',
    );
  }

  Widget _amountInformationWidget(BuildContext context) {
    final senderCurrency = controller.selectFromWallet.value!.currency;
    final receiverCurrency = controller.selectToWallet.value!.currency;
    return amountInformationWidget(
      children: Column(
        children: [
          _rowWidget(title: Strings.fromWallet, subTitle: senderCurrency.code),
          _rowWidget(title: Strings.toWallet, subTitle: receiverCurrency.code),
        ],
      ),

      information: Strings.amountInformation,
      enterAmount: Strings.totalExchangeAmount,
      enterAmountRow:
          '${controller.exchangeFromAmountController.text} ${controller.selectFromWallet.value!.currency.code}',
      fee: Strings.totalCharge,
      feeRow:
          '${controller.totalFee.value.toStringAsFixed(2)} ${controller.selectFromWallet.value!.currency.code}',
      received: Strings.convertedAmount,
      receivedRow:
          '${controller.exchangeToAmountController.text} ${controller.selectToWallet.value!.currency.code}',
      total: Strings.totalPayable,
      totalRow:
          '${(double.parse(controller.exchangeFromAmountController.text.isNotEmpty ? controller.exchangeFromAmountController.text : '0.0') + controller.totalFee.value).toStringAsFixed(2)} ${controller.selectFromWallet.value!.currency.code}',
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 2),
      child: Obx(
        () => controller.isMoneyExchangeLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.confirm,
                onPressed: () {
                  controller.moneyExchangeProcess(context).then((value) {
                    if (!context.mounted) return;
                    StatusScreen.show(
                      context: context,
                      subTitle: value.message.success.first,
                      onPressed: () {
                        Get.offAllNamed(Routes.bottomNavBarScreen);
                      },
                    );
                  });
                },
              ),
      ),
    );
  }

  Column _rowWidget({required String title, required String subTitle}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: mainSpaceBet,
          children: [
            TitleHeading4Widget(
              text: title,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.6)
                  : CustomColor.primaryLightColor.withValues(alpha: 0.4),
            ),
            TitleHeading3Widget(
              text: subTitle,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.6)
                  : CustomColor.primaryLightColor.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize * 0.7),
      ],
    );
  }
}
