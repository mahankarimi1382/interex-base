import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/text_labels/title_heading5_widget.dart';
import '../controller/make_counter_offer_controller.dart';

class MakeCounterOfferFieldsWidget extends StatelessWidget {
  const MakeCounterOfferFieldsWidget({super.key, required this.controller});

  final MakeCounterOfferController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.75),
      margin: EdgeInsets.only(
        top: Dimensions.marginBetweenInputTitleAndBox,
        bottom: Dimensions.marginSizeVertical,
      ),
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
            TitleHeading5Widget(text: Strings.makeCounterOffer, opacity: 0.60),
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
            PrimaryInputWidget(
              controller: controller.amountController,
              hint: '0.00',
              label: Strings.amount,
              readOnly: true,
              suffixIcon: _customCurrencyWidget(controller.sellCurrency.value),
            ).paddingSymmetric(vertical: Dimensions.marginSizeVertical * 0.666),
            PrimaryInputWidget(
              controller: controller.rateController,
              hint: '0.00',
              label: Strings.rate,
              suffixIcon: _customCurrencyWidget(controller.rateCurrency.value),
            ),
          ],
        ),
      ),
    );
  }

  Container _customCurrencyWidget(String currency) {
    return Container(
      width: Dimensions.widthSize * 8,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Dimensions.radius * 0.5),
          bottomRight: Radius.circular(Dimensions.radius * 0.5),
        ),
        color: Theme.of(Get.context!).primaryColor,
      ),
      child: Text(
        currency,
        style: Get.isDarkMode
            ? CustomStyle.lightHeading3TextStyle.copyWith(
                fontWeight: FontWeight.w500,
              )
            : CustomStyle.darkHeading3TextStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
      ),
    );
  }
}
