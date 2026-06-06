part of '../screen/cardyfie_card_screen.dart';

class CardyfieCategoryWidget extends StatelessWidget {
  CardyfieCategoryWidget({super.key});
  final controller = Get.put(VirtualCardyfieCardController());
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Visibility(
      visible: controller.cardyfieCardModel.data.myCards.isNotEmpty,
      child: GridView.count(
        padding: EdgeInsets.only(top: Dimensions.paddingSize * 0.3),
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisCount: 6,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: screenWidth >= 600 ? 1.5 : 0.9,
        shrinkWrap: true,
        children: [
          CategoriesWidget(
            icon: Assets.icon.details,
            text: Strings.details,
            color: CustomColor.whiteColor,
            onTap: () {
              if (controller.cardyfieCardModel.data.myCards.isNotEmpty) {
                Get.toNamed(Routes.cardyfieDetailsScreen);
              } else {
                CustomSnackBar.error(Strings.youDonNotBuyCard);
              }
            },
          ),
          CategoriesWidget(
            icon: Assets.icon.fundCard,
            text: Strings.fund,
            color: CustomColor.whiteColor,
            onTap: () {
              if (controller.cardyfieCardModel.data.myCards.isNotEmpty) {
                Get.toNamed(Routes.cardyfieAddFundScreen);
              } else {
                CustomSnackBar.error(Strings.youDonNotBuyCard);
              }
            },
          ),

          CategoriesWidget(
            icon: Assets.icon.withdrawCard,
            text: Strings.withdraw,
            color: CustomColor.whiteColor,
            onTap: () {
              if (controller.cardyfieCardModel.data.myCards.isNotEmpty) {
                Get.toNamed(Routes.cardyfieWithdrawScreen);
              } else {
                CustomSnackBar.error(Strings.youDonNotBuyCard);
              }
            },
          ),
          Obx(
            () => controller.isMakeDefaultLoading
                ? CustomSwitchLoading(color: CustomColor.whiteColor)
                : CategoriesWidget(
                    icon: Assets.icon.torch,
                    color: CustomColor.whiteColor,
                    text:
                        controller
                            .cardyfieCardModel
                            .data
                            .myCards[controller
                                .dashboardController
                                .current
                                .value]
                            .isDefault
                        ? Strings.removeDefault
                        : Strings.makeDefault,
                    onTap: () {
                      controller.makeCardDefaultProcess(
                        controller
                            .cardyfieCardModel
                            .data
                            .myCards[controller
                                .dashboardController
                                .current
                                .value]
                            .ulid,
                      );
                    },
                  ),
          ),

          CategoriesWidget(
            icon: Assets.icon.transactionsLog,
            text: Strings.transactions,
            color: CustomColor.whiteColor,
            onTap: () {
              if (controller.cardyfieCardModel.data.myCards.isNotEmpty) {
                Get.toNamed(Routes.cardyfieTransactionHistoryScreen);
              } else {
                CustomSnackBar.error(Strings.youDonNotBuyCard);
              }
            },
          ),
          CategoriesWidget(
            icon: Assets.icon.aboutUs,
            text: Strings.close,
            color: CustomColor.whiteColor,
            onTap: () {
              if (controller.cardyfieCardModel.data.myCards.isNotEmpty) {
                _openDialogueForCloseAccount(context);
              } else {
                CustomSnackBar.error(Strings.youDonNotBuyCard);
              }
            },
          ),
        ],
      ),
    );
  }

  void _openDialogueForCloseAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CustomColor.whiteColor,
          alignment: Alignment.center,
          insetPadding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Builder(
            builder: (context) {
              var width = MediaQuery.of(context).size.width;
              return Container(
                width: width * 0.84,
                margin: EdgeInsets.all(Dimensions.paddingSize * 0.5),
                padding: EdgeInsets.all(Dimensions.paddingSize * 0.9),
                decoration: BoxDecoration(
                  color: CustomColor.currencyColor,
                  // Get.isDarkMode
                  //     ? CustomColor.transparentColor
                  //     : CustomColor.transparentColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: crossCenter,
                  children: [
                    SizedBox(height: Dimensions.heightSize * 2),
                    TitleHeading2Widget(text: Strings.closeCard),
                    verticalSpace(Dimensions.heightSize * 1),
                    TitleHeading4Widget(text: Strings.virtualCloseMessage),
                    verticalSpace(Dimensions.heightSize * 1),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .25,
                            child: PrimaryButton(
                              title: Strings.cancel.tr,
                              onPressed: () {
                                Get.close(1);
                              },
                              borderColor: CustomColor
                                  .primaryDarkScaffoldBackgroundColor,
                              buttonColor: CustomColor
                                  .primaryDarkScaffoldBackgroundColor,
                            ),
                          ),
                        ),
                        horizontalSpace(Dimensions.widthSize),
                        Expanded(
                          child: Obx(
                            () => controller.isCloseLoading
                                ? const CustomLoadingAPI()
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: PrimaryButton(
                                      title: Strings.close.tr,
                                      onPressed: () {
                                        controller.closeProcess();
                                      },
                                      borderColor:
                                          CustomColor.primaryLightColor,
                                      buttonColor: CustomColor.redColor,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
