// ignore_for_file: use_build_context_synchronously

import 'package:qrpaypro/backend/utils/custom_loading_api.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';
import 'package:qrpaypro/widgets/others/preview/amount_preview_widget.dart';

import '../../../../backend/local_storage/local_storage.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../controller/trade_controller.dart';


class TradeSubmitPreviewScreen extends StatelessWidget {
  TradeSubmitPreviewScreen({super.key});

  final controller = Get.find<TradeController>();

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
        verticalSpace(Dimensions.paddingVerticalSize * .3),
        _amountInformationWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  Widget _amountWidget(BuildContext context) {
    int precision = controller.selectedSaleCurrency.value.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();


    return previewAmount(
        amount:
            '${double.parse(controller.sellingAmountController.text).toStringAsFixed(precision)} ${controller.selectedSaleCurrency.value.code}');
  }

  Column _amountInformationWidget(BuildContext context) {
    int precision = controller.selectedSaleCurrency.value.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();

    int prec = controller.selectedRateCurrency.value.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();

    return Column(
      children: [
        _rowWidget(
          title: Strings.sellingAmount,
          subTitle: "${double.parse(controller.sellingAmountController.text).toStringAsFixed(precision)} ${controller.selectedSaleCurrency.value.code}",
        ),
        _rowWidget(
          title: Strings.feeAndCharge,
          subTitle: "${controller.totalCharge.toStringAsFixed(precision)} ${controller.selectedSaleCurrency.value.code}",
        ),
        _rowWidget(
          title: Strings.buyerWillPay,
          subTitle: "${double.parse(controller.askingRateController.text).toStringAsFixed(prec)} ${controller.selectedRateCurrency.value.code}",
        ),
        _rowWidget(
          title: Strings.youWillPay,
          subTitle: "${controller.totalPay.value.toStringAsFixed(precision)} ${controller.selectedSaleCurrency.value.code}",
        ),
      ],
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 2,
      ),
      child: Obx(
        () => controller.isSubmitLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.confirm,
                onPressed: () {
                  controller.tradeSubmitApi();
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
                  ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                  : CustomColor.primaryLightColor.withValues(alpha:
                      0.4,
                    ),
            ),
            TitleHeading3Widget(
              text: subTitle,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                  : CustomColor.primaryLightColor.withValues(alpha:
                      0.6,
                    ),
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize * 0.7),
      ],
    );
  }
}
