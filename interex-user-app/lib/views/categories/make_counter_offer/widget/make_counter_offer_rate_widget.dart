import '../../../../custom_assets/assets.gen.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/text_labels/title_heading5_widget.dart';
import '../../../others/custom_image_widget.dart';
import '../controller/make_counter_offer_controller.dart';
import 'amount_widget.dart';

class MakeCounterOfferRateWidget extends StatelessWidget {
  const MakeCounterOfferRateWidget({super.key, required this.controller});
  final MakeCounterOfferController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(Dimensions.paddingVerticalSize * .5),
        _rateWidget(context),
        _priceOfferWidget(context),
      ],
    );
  }

  Container _priceOfferWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.75),
      margin: EdgeInsets.only(top: Dimensions.marginBetweenInputTitleAndBox),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
        color: Get.isDarkMode
            ? CustomColor.whiteColor.withValues(alpha: .05)
            : CustomColor.whiteColor,
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: crossStart,
          children: [
            TitleHeading5Widget(text: Strings.priceOffer, opacity: 0.60),
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
            verticalSpace(Dimensions.marginSizeVertical * 0.75),
            _offerPriceWidget(
              Strings.offer,
              controller.sellAmount.value.toStringAsFixed(2),
              controller.rateAmount.value.toStringAsFixed(2),
            ),
            verticalSpace(Dimensions.marginSizeVertical * 0.5),
            _offerPriceWidget(
              Strings.counterOffer,
              controller.counterSellAmount.value.toStringAsFixed(2),
              controller.counterRateAmount.value.toStringAsFixed(2),
            ),
          ],
        ),
      ),
    );
  }

  Row _offerPriceWidget(String title, sellAmount, rateAmount) {
    return Row(
      mainAxisAlignment: mainSpaceBet,
      children: [
        Expanded(
          child: TitleHeading4Widget(
            text: title,
            opacity: 0.60,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: mainCenter,
            children: [
              Opacity(
                opacity: 0.60,
                child: AmountWidget(
                  amount: sellAmount,
                  currency: controller.sellCurrency.value,
                  fontSize: Dimensions.headingTextSize3 * 0.8,
                ),
              ),
              CustomImageWidget(
                path: Assets.icon.replyTeal,
                color: Get.isDarkMode
                    ? CustomColor.whiteColor.withValues(alpha: 0.60)
                    : CustomColor.blackColor.withValues(alpha: 0.60),
              ).paddingSymmetric(
                horizontal: Dimensions.marginSizeHorizontal * 0.1,
              ),
              Opacity(
                opacity: 0.60,
                child: AmountWidget(
                  amount: rateAmount,
                  currency: controller.rateCurrency.value,
                  fontSize: Dimensions.headingTextSize3 * 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _rateWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal,
        vertical: Dimensions.marginSizeVertical * 1.83,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
        color: Get.isDarkMode
            ? CustomColor.whiteColor.withValues(alpha: .05)
            : CustomColor.whiteColor,
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
          ).paddingSymmetric(horizontal: Dimensions.marginSizeHorizontal * 0.2),
          AmountWidget(
            amount: controller.rateAmount.value.toStringAsFixed(2),
            currency: controller.rateCurrency.value,
            isPrimaryColor: true,
          ),
        ],
      ),
    );
  }
}
