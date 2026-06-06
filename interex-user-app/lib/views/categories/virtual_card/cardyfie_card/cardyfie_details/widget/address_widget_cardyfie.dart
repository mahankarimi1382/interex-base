part of '../cardyfie_details_screen.dart';

class AddressWidgetCardyfie extends StatelessWidget {
  AddressWidgetCardyfie({super.key});
  final controller = Get.put(CardyfieDetailsController());
  @override
  Widget build(BuildContext context) {
    var myCards = controller.cardDetailsModelCardyfie.data.myCard;
    return Container(
      margin: EdgeInsets.only(top: Dimensions.heightSize * 0.4),
      decoration: BoxDecoration(
        color: CustomColor.primaryLightColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.paddingSize * 0.7,
              bottom: Dimensions.paddingSize * 0.3,
              left: Dimensions.paddingSize * 0.7,
              right: Dimensions.paddingSize * 0.7,
            ),
            child: TitleHeading3Widget(
              text: Strings.address,
              textAlign: TextAlign.left,
              color: CustomColor.cardLightTextColor,
            ),
          ),
          const Divider(
            thickness: 1,
            color: CustomColor.primaryLightScaffoldBackgroundColor,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.paddingSize * 0.3,
              bottom: Dimensions.paddingSize * 0.6,
              left: Dimensions.paddingSize * 0.7,
              right: Dimensions.paddingSize * 0.7,
            ),
            child: Column(
              crossAxisAlignment: crossStart,
              children: [
                TitleHeading4Widget(
                  text: Strings.billingAddress,
                  color: CustomColor.whiteColor,
                  fontWeight: FontWeight.w400,
                ),
                verticalSpace(Dimensions.heightSize * 0.5),
                FittedBox(
                  child: TitleHeading5Widget(
                    text: myCards.address,
                    color: CustomColor.whiteColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
