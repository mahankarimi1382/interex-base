// ignore_for_file: use_build_context_synchronously

import 'package:qrpaypro/backend/utils/custom_loading_api.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';
import 'package:qrpaypro/widgets/others/preview/amount_preview_widget.dart';
import 'package:qrpaypro/widgets/others/preview/information_amount_widget.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/utils/custom_snackbar.dart';
import '../../../controller/categories/money_exchange/money_exchange_controller.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/basic_screen_imports.dart';
import '../../../widgets/others/congratulation_widget.dart';

class ExchangeMoneyPreviewScreen extends StatelessWidget {
  ExchangeMoneyPreviewScreen({super.key});

  final controller = Get.put(MoneyExchangeController());
  final dashboardController = Get.put(DashBoardController());

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
    int precision = controller.selectFromWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();
    return previewAmount(
      amount:
          '${double.parse(controller.exchangeFromAmountController.text).toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
    );
  }

  Widget _amountInformationWidget(BuildContext context) {
    var senderCurrency = controller.selectFromWallet.value!.currency;
    var receiverCurrency = controller.selectToWallet.value!.currency;
    int precision = controller.selectFromWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();
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
          '${double.parse(controller.exchangeFromAmountController.text).toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
      fee: Strings.totalCharge,
      feeRow:
          '${controller.totalFee.value.toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
      received: Strings.convertedAmount,
      receivedRow:
          '${double.parse(controller.exchangeToAmountController.text).toStringAsFixed(precision)} ${controller.selectToWallet.value!.currency.code}',
      total: Strings.totalPayable,
      totalRow:
          '${(double.parse(controller.exchangeFromAmountController.text.isNotEmpty ? controller.exchangeFromAmountController.text : '0.0') + controller.totalFee.value).toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
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
                  if (dashboardController.kycStatus.value == 1) {
                    controller
                        .moneyExchangeProcess(context)
                        .then(
                          (value) => StatusScreen.show(
                            context: context,
                            subTitle: value.message.success.first,
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
