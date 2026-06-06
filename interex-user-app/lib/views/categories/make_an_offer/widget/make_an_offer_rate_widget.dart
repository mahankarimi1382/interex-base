
import '../../../../custom_assets/assets.gen.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../others/custom_image_widget.dart';
import '../../make_counter_offer/widget/amount_widget.dart';
import '../controller/make_an_offer_controller.dart';

class MakeAnOfferRateWidget extends StatelessWidget {
  const MakeAnOfferRateWidget({super.key, required this.controller});
  final MakeAnOfferController controller;
  @override
  Widget build(BuildContext context) {
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
