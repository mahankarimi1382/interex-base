
import '../../../../custom_assets/assets.gen.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/payment_link/custom_drop_down.dart';
import '../../../../widgets/text_labels/title_heading5_widget.dart';
import '../../../others/custom_image_widget.dart';
import '../../make_counter_offer/widget/amount_widget.dart';
import '../controller/marketplace_buying_preview_controller.dart';
import '../model/marketplace_buy_model.dart';

class MarketplaceGatewayWidget extends StatelessWidget {
  const MarketplaceGatewayWidget({super.key, required this.controller});
  final MarketplaceBuyingPreviewController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _amountWidget(context),
        _paymentMethodWidget(context),
      ],
    );
  }

  Container _amountWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal,
        vertical: Dimensions.marginSizeVertical * 1.83,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              Dimensions.radius * 1.2),
          color: Get.isDarkMode
              ? CustomColor.whiteColor
              .withValues(alpha: .05)
              : CustomColor.whiteColor
      ),
      child: Row(
        mainAxisAlignment: mainCenter,
        children: [
          AmountWidget(
            amount: controller.sellAmount.value.toStringAsFixed(2),
            currency: controller.sellCurrency.value,
            isPrimaryColor: true,
          ),
          CustomImageWidget(
            path: Assets.icon.replyTeal,
            color: Get.isDarkMode
                ? CustomColor.whiteColor
                : CustomColor.blackColor,
          ),
          AmountWidget(
            amount: controller.rateAmount.value.toStringAsFixed(2),
            currency: controller.rateCurrency.value,
            isPrimaryColor: true,
          ),
        ],
      ),
    );
  }

  Container _paymentMethodWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.marginBetweenInputTitleAndBox,
      ),
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.75),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              Dimensions.radius * 1.2),
          color: Get.isDarkMode
              ? CustomColor.whiteColor
              .withValues(alpha: .05)
              : CustomColor.whiteColor
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
           TitleHeading5Widget(
            text: Strings.paymentMethod,
            opacity: 0.60,
          ),
          Container(
            height: 2,
            width: double.infinity,
            margin: EdgeInsets.only(
              top: Dimensions.marginBetweenInputTitleAndBox,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          verticalSpace(Dimensions.marginBetweenInputTitleAndBox * 2),
          CustomDropDown<PaymentGateway>(
            items: controller.marketplaceBuyModel.data.paymentGatewaies,
            hint: controller.selectPaymentGateway.value,
            onChanged: (value) {
              controller.selectPaymentGateway.value = value!.name;
              controller.selectPaymentGatewayId.value = value.id.toString();
            },
            padding: EdgeInsets.only(
              left: Dimensions.paddingSize * 0.25,
            ),
            titleTextColor: CustomColor.blackColor.withValues(alpha: 1),
            dropDownColor: Theme.of(context).scaffoldBackgroundColor,
            borderEnable: false,
            dropDownIconColor:
                CustomColor.blackColor.withValues(alpha: 01),
          ),
        ],
      ),
    );
  }
}
