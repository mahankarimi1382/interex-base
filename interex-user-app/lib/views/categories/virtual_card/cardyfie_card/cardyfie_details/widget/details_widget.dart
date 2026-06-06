part of '../cardyfie_details_screen.dart';

class CardyfieDetailsWidget extends StatelessWidget {
  CardyfieDetailsWidget({super.key});
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
              text: Strings.cardInformation,
              textAlign: TextAlign.left,
              color: CustomColor.whiteColor,
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
              // crossAxisAlignment: crossEnd,
              children: [
                DetailsRowWidget(
                  variable: Strings.cardHolderSName,
                  value: myCards.cardName,
                ),
                DetailsRowWidget(variable: Strings.cardId, value: myCards.ulid),
                DetailsRowWidget(
                  variable: Strings.amount,
                  value: myCards.amount.toString(),
                ),

                DetailsRowWidget(
                  variable: Strings.cardType,
                  value: myCards.cardType,
                ),

                DetailsRowWidget(
                  variable: Strings.cardTier,
                  value: myCards.cardTier,
                ),
                DetailsRowWidget(
                  variable: Strings.customerId,
                  value: myCards.customerUlid,
                ),
                DetailsRowWidget(
                  variable: Strings.cardNumber,
                  value: myCards.realPan,
                ),

                ///>>>>>>>> card cvc
                DetailsRowWidget(variable: Strings.cvc, value: myCards.cvv),

                DetailsRowWidget(
                  variable: Strings.expiration,
                  value: myCards.cardExpTime,
                ),
                DetailsRowWidget(
                  variable: Strings.cardEnvironment,
                  value: myCards.env,
                ),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    CustomTitleHeadingWidget(
                      text: Strings.freezeCard,
                      style: CustomStyle.darkHeading4TextStyle.copyWith(
                        color: CustomColor.whiteColor.withValues(alpha: 0.9),
                      ),
                    ),

                    Obx(
                      () => controller.isCardStatusLoading
                          ? const CustomSwitchLoading(
                              color: CustomColor.whiteColor,
                            )
                          : Switch(
                              activeThumbColor: CustomColor
                                  .primaryLightTextColor
                                  .withValues(alpha: 0.6),
                              inactiveThumbColor: CustomColor.primaryLightColor
                                  .withValues(alpha: 0.6),
                              value: controller.isSelected.value,
                              onChanged: ((value) {
                                controller.cardToggle();
                              }),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsRowWidget extends StatelessWidget {
  const DetailsRowWidget({
    super.key,
    required this.variable,
    required this.value,
  });
  final String variable, value;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.paddingSize * 0.4),
      child: Row(
        mainAxisAlignment: mainSpaceBet,
        children: [
          Expanded(
            child: CustomTitleHeadingWidget(
              text: variable,
              style: CustomStyle.darkHeading4TextStyle.copyWith(
                color: CustomColor.whiteColor,
                fontSize: screenWidth >= 600
                    ? Dimensions.headingTextSize5
                    : Dimensions.headingTextSize4,
              ),
            ),
          ),
          Expanded(
            child: CustomTitleHeadingWidget(
              text: value,
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
              style: CustomStyle.darkHeading4TextStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth >= 600
                    ? Dimensions.headingTextSize5
                    : Dimensions.headingTextSize3,
                color: CustomColor.whiteColor.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
