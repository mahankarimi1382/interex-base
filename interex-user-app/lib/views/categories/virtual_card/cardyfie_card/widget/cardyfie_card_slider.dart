part of '../screen/cardyfie_card_screen.dart';

class CardyfieCardSlider extends StatelessWidget {
  CardyfieCardSlider({super.key});

  final myCardController = Get.put(VirtualCardyfieCardController());
  final controller = Get.find<DashBoardController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    var myCards = myCardController.cardyfieCardModel.data.myCards;
    return myCards.isNotEmpty
        ? Obx(() {
            return Column(
              children: [
                CarouselSlider(
                  items: myCards.map((card) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CardWidget(
                          cardHolderName: card.cardName,
                          cardNumber: card.maskedPan,
                          expiryDate: card.cardExpTime,
                          balance: card.amount.toString(),
                          validAt: card.cardExpTime,
                          cvv: card.cardType,
                          logo: myCardController
                              .cardyfieCardModel
                              .data
                              .cardBasicInfo
                              .siteLogo,
                          cardBgNetwork: myCardController
                              .cardyfieCardModel
                              .data
                              .cardBasicInfo
                              .cardBg,
                        );
                      },
                    );
                  }).toList(),
                  carouselController: controller.carouselController,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      controller.current.value = index;
                      myCardController.cardyfieCardUIId.value =
                          myCards[index].ulid;
                      debugPrint(myCardController.cardyfieCardUIId.value);
                    },
                    height: screenWidth >= 600
                        ? MediaQuery.of(context).size.height * 0.24
                        : MediaQuery.of(context).size.height * 0.22,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: myCards.length > 1 ? true : false,
                    autoPlay: false,
                    aspectRatio: 17 / 9,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(seconds: 2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                verticalSpace(Dimensions.heightSize),
                Row(
                  mainAxisAlignment: mainCenter,
                  children: [
                    TitleHeading5Widget(
                      text: Strings.myCard,
                      color: CustomColor.whiteColor,

                      fontSize: Dimensions.headingTextSize6,
                    ),
                    horizontalSpace(Dimensions.widthSize * 0.4),
                    TitleHeading5Widget(
                      color: CustomColor.whiteColor,

                      fontSize: Dimensions.headingTextSize6,

                      text:
                          '${myCardController.cardyfieCardModel.data.myCards.length}/${myCardController.cardyfieCardModel.data.cardBasicInfo.cardCreateLimit == 0 ? "∞" : myCardController.cardyfieCardModel.data.cardBasicInfo.cardCreateLimit}',
                    ),
                  ],
                ),
                verticalSpace(Dimensions.heightSize),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: myCardController.cardyfieCardModel.data.myCards
                      .asMap()
                      .entries
                      .map((entry) {
                        return controller.current.value == entry.key
                            ? Container(
                                width: Dimensions.widthSize * 1,
                                height: Dimensions.heightSize * 0.5,
                                margin: EdgeInsets.only(
                                  bottom: Dimensions.marginSizeVertical * 0.1,
                                  left: Dimensions.marginSizeHorizontal * 0.2,
                                  right: Dimensions.marginSizeHorizontal * 0.2,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CustomColor.whiteColor,
                                ),
                              )
                            : Container(
                                width: Dimensions.widthSize * 0.7,
                                height: Dimensions.heightSize * 0.4,
                                margin: EdgeInsets.only(
                                  bottom: Dimensions.marginSizeVertical * 0.1,
                                  left: Dimensions.marginSizeHorizontal * 0.2,
                                  right: Dimensions.marginSizeHorizontal * 0.2,
                                ),
                                decoration: BoxDecoration(
                                  color: CustomColor.whiteColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              );
                      })
                      .toList(),
                ),
              ],
            );
          })
        : Column(
            children: [
              CardWidget(
                cardNumber: 'xxxx xxxx xxxx xxxx',
                expiryDate: 'xx/xx',
                balance: 'xx',
                validAt: 'xx',
                cvv: 'xxx',
                logo: Assets.logo.appLauncher.path,
                isNetworkImage: false,
                cardBgNetwork: myCardController
                    .cardyfieCardModel
                    .data
                    .cardBasicInfo
                    .cardBg,
              ),
              verticalSpace(Dimensions.heightSize * 0.5),
              Row(
                mainAxisAlignment: mainCenter,
                children: [
                  TitleHeading5Widget(text: Strings.myCard),
                  horizontalSpace(Dimensions.widthSize * 0.4),
                  TitleHeading5Widget(
                    text:
                        '${myCardController.cardyfieCardModel.data.myCards.length}/${myCardController.cardyfieCardModel.data.cardBasicInfo.cardCreateLimit}',
                  ),
                ],
              ),
            ],
          );
  }
}
