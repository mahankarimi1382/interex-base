import '../../../../../../utils/basic_screen_imports.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({
    super.key,
    required this.amount,
    required this.title,
    required this.dateText,
    required this.transaction,
    required this.monthText,
  });

  final String title, monthText, dateText, amount, transaction;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.paddingSize * 0.3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius),
        ),
        padding: EdgeInsets.only(right: Dimensions.paddingSize * 0.2),
        child: Container(
          decoration: BoxDecoration(
            color: CustomColor.primaryLightColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(Dimensions.radius),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.marginSizeVertical * 0.4,
                    top: Dimensions.marginSizeVertical * 0.5,
                    bottom: Dimensions.marginSizeVertical * 0.4,
                    right: Dimensions.marginSizeVertical * 0.2,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CustomColor.whiteColor
                        .withValues(alpha: 0.5)
                        .withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 0.6,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: mainCenter,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: crossCenter,
                    children: [
                      TitleHeading4Widget(
                        text: dateText,
                        fontSize: screenWidth >= 600
                            ? Dimensions.headingTextSize3
                            : Dimensions.headingTextSize3 * 2,
                        fontWeight: FontWeight.w800,
                        color: CustomColor.whiteColor.withValues(alpha: 0.5),
                      ),
                      TitleHeading4Widget(
                        text: monthText,
                        fontSize: screenWidth >= 600
                            ? Dimensions.headingTextSize6
                            : Dimensions.headingTextSize6,
                        fontWeight: FontWeight.w500,
                        color: CustomColor.whiteColor.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              horizontalSpace(Dimensions.marginSizeHorizontal * 0.4),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: crossStart,
                  mainAxisAlignment: mainCenter,
                  children: [
                    TitleHeading3Widget(
                      text: title,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: screenWidth >= 600
                          ? Dimensions.headingTextSize6
                          : Dimensions.headingTextSize4 + 1,
                      color: CustomColor.whiteColor.withValues(alpha: 0.8),
                    ),
                    verticalSpace(Dimensions.widthSize * 0.7),
                    CustomTitleHeadingWidget(
                      text: transaction,
                      style: CustomStyle.darkHeading4TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize5,
                        fontWeight: FontWeight.w400,
                        color: CustomColor.whiteColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: TitleHeading4Widget(
                  text: amount,
                  color: CustomColor.whiteColor.withValues(alpha: 0.7),
                  fontSize: screenWidth >= 600
                      ? Dimensions.headingTextSize6
                      : Dimensions.headingTextSize4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
