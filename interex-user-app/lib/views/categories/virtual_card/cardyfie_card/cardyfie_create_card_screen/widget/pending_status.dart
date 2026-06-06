part of "../cardyfie_create_card_screen.dart";

class CardyfiePendingWidget extends StatelessWidget {
  const CardyfiePendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSize * 1.2),
      decoration: BoxDecoration(
        color: CustomColor.primaryLightColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(Dimensions.radius),
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Row(
            crossAxisAlignment: crossCenter,
            children: [
              // Icon Circle
              Container(
                padding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
                decoration: BoxDecoration(
                  color: CustomColor.primaryLightColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info,
                  size: 20,
                  color: CustomColor.whiteColor,
                ),
              ),
              horizontalSpace(Dimensions.marginSizeHorizontal * 0.5),

              // Status Text
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: languageController.getTranslation(
                      Strings.statusOfThe,
                    ),
                    style: TextStyle(
                      fontSize: Dimensions.headingTextSize5,
                      color: CustomColor.primaryDarkTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: languageController.getTranslation(
                          Strings.pending,
                        ),

                        style: TextStyle(
                          color: CustomColor.yellowColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          verticalSpace(Dimensions.marginSizeVertical * 0.7),
          Text(
            languageController.getTranslation(Strings.pleaseWaitUntill),
            style: TextStyle(
              fontSize: Dimensions.headingTextSize5,
              fontWeight: FontWeight.w500,
              color: CustomColor.primaryDarkTextColor,
            ),
          ),

          verticalSpace(Dimensions.marginSizeVertical * 0.7),

          Center(
            child: PrimaryButton(
              title: Strings.updateCustomer,
              onPressed: () {
                Get.toNamed(Routes.cardyfieUpdateCustomerScreen);
              },
            ),
          ),
        ],
      ),
    );
  }
}
