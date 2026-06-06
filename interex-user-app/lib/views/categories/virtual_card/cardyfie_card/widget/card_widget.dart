part of '../screen/cardyfie_card_screen.dart';

class CardWidget extends StatelessWidget {
  final String cardNumber, expiryDate, balance, validAt, cvv, logo;
  final String? availableBalance;
  final String? cardHolderName;
  final String? cardBgNetwork;
  final bool isNetworkImage;

  const CardWidget({
    super.key,
    required this.cardNumber,
    this.availableBalance,
    required this.expiryDate,
    required this.balance,
    required this.validAt,
    required this.cvv,
    this.cardHolderName,
    required this.logo,
    this.isNetworkImage = true,
    this.cardBgNetwork = '',
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return FlipCard(
      fill: Fill.fillFront,
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        height: screenWidth >= 600
            ? MediaQuery.of(context).size.height * 0.2
            : MediaQuery.of(context).size.height * 0.21,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSize,
          vertical: Dimensions.paddingSize * 0.1,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.3),
          image: DecorationImage(
            image: NetworkImage(cardBgNetwork!),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: mainMin,
          crossAxisAlignment: crossStart,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: screenWidth >= 600
                    ? Dimensions.heightSize * 0.3
                    : Dimensions.heightSize * 2,
                bottom: screenWidth >= 600
                    ? Dimensions.heightSize * 0.1
                    : Dimensions.heightSize * 0.7,
              ),
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: mainSpaceBet,
                children: [
                  TitleHeading2Widget(
                    text: cardHolderName ?? "",
                    fontSize: Dimensions.headingTextSize4,
                    color: CustomColor.whiteColor,
                  ),
                  Visibility(
                    visible: isNetworkImage,
                    child: Image.network(
                      logo,
                      color: CustomColor.whiteColor,
                      height: screenWidth >= 600
                          ? Dimensions.heightSize * 1
                          : Dimensions.heightSize * 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: mainStart,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.paddingSize * 0.4),
                  child: Image.asset(
                    Assets.clipart.chip.path,
                    width: Dimensions.widthSize * 3,
                  ),
                ),
                CustomTitleHeadingWidget(
                  padding: EdgeInsets.only(
                    left: Dimensions.paddingSize * 2,
                    top: Dimensions.paddingSize * 0.5,
                  ),
                  text: cardNumber.replaceAllMapped(
                    RegExp(r".{4}"),
                    (match) => "${match.group(0)}",
                  ),
                  textOverflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.outfit(
                    fontSize: Dimensions.headingTextSize3 * 1,
                    fontWeight: FontWeight.w800,
                    color: CustomColor.whiteColor,
                  ),
                ),
              ],
            ),
            verticalSpace(
              screenWidth >= 600
                  ? Dimensions.heightSize * 0.4
                  : Dimensions.heightSize * 1,
            ),
            Row(
              mainAxisAlignment: mainSpaceBet,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: crossStart,
                    children: [
                      TitleHeading2Widget(
                        text: expiryDate,
                        fontSize: Dimensions.headingTextSize4,
                        color: CustomColor.whiteColor,
                      ),
                      TitleHeading4Widget(
                        color: CustomColor.whiteColor.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.headingTextSize5,
                        text: Strings.expiryDate,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: crossEnd,
                    children: [
                      TitleHeading2Widget(
                        text: balance,
                        fontSize: Dimensions.headingTextSize4,
                        color: CustomColor.whiteColor,
                      ),
                      TitleHeading4Widget(
                        color: CustomColor.whiteColor.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.headingTextSize5,
                        text: availableBalance ?? Strings.availabeBlance,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      back: Container(
        height: screenWidth >= 600
            ? MediaQuery.of(context).size.height * 0.2
            : MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSize,
          vertical: Dimensions.paddingSize * 0.2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.3),
          image: DecorationImage(
            image: NetworkImage(cardBgNetwork!),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: crossEnd,
          children: [
            verticalSpace(Dimensions.heightSize * 1),
            CustomTitleHeadingWidget(
              padding: EdgeInsets.only(left: Dimensions.paddingSize * 2),
              text: "Valid: $validAt",
              textOverflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.outfit(
                fontSize: Dimensions.headingTextSize2 * 0.5,
                fontWeight: FontWeight.w500,
                color: CustomColor.whiteColor.withValues(alpha: 0.6),
              ),
            ),
            Container(
              height: Dimensions.heightSize * 1.2,
              width: Dimensions.widthSize * 3.1,
              margin: EdgeInsets.only(
                right: Dimensions.marginSizeHorizontal * 0.3,
                top: Dimensions.marginSizeVertical * 0.4,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomColor.primaryLightTextColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.3),
              ),
              child: TitleHeading4Widget(
                text: cvv,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: CustomColor.whiteColor.withValues(alpha: 0.4),
              ),
            ),
            verticalSpace(Dimensions.heightSize * 0.5),
          ],
        ),
      ),
    );
  }
}
