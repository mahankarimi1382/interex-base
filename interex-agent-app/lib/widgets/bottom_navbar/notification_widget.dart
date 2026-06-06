import 'package:qrpay/utils/basic_screen_imports.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.subtitle,
    required this.title,
    required this.dateText,
    required this.monthText,
  });

  final String title, monthText, dateText, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.marginSizeVertical * 0.3),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeVertical * 0.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          color: Theme.of(context).primaryColor.withValues(alpha:0.05),
        ),
        padding: EdgeInsets.only(right: Dimensions.paddingSize * 0.2),
        height: Dimensions.heightSize * 6,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: Dimensions.marginSizeVertical * 0.4,
                top: Dimensions.marginSizeVertical * 0.5,
                bottom: Dimensions.marginSizeVertical * 0.4,
                right: Dimensions.marginSizeVertical * 0.2,
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.marginSizeHorizontal * 0.5,
                vertical: Dimensions.marginSizeVertical * 0.1,
              ),
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkScaffoldBackgroundColor
                        .withValues(alpha:0.7)
                    : Theme.of(context).colorScheme.surface.withValues(alpha:0.5),
                borderRadius: BorderRadius.circular(Dimensions.radius),
              ),
              child: Column(
                mainAxisAlignment: mainCenter,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTitleHeadingWidget(
                    text: dateText,
                    style: CustomStyle.darkHeading4TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize3 * 1.6,
                        fontWeight: FontWeight.w800,
                        color: Get.isDarkMode
                            ? CustomColor.whiteColor
                            : Theme.of(context).primaryColor),
                  ),
                  CustomTitleHeadingWidget(
                    text: monthText,
                    style: CustomStyle.darkHeading4TextStyle.copyWith(
                      fontSize: Dimensions.headingTextSize6 * 0.8,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode
                          ? CustomColor.whiteColor
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            horizontalSpace(Dimensions.widthSize * 0.8),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: crossStart,
                mainAxisAlignment: mainCenter,
                children: [
                  TitleHeading3Widget(
                    text: title,
                  ),
                  verticalSpace(Dimensions.widthSize * 0.7),
                  CustomTitleHeadingWidget(
                    text: subtitle,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    style: CustomStyle.darkHeading4TextStyle.copyWith(
                      fontSize: Dimensions.headingTextSize5,
                      fontWeight: FontWeight.w400,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor
                          : CustomColor.primaryLightTextColor,
                    ),
                  ),
                ],
              ),
            ),
            horizontalSpace(Dimensions.widthSize * 0.8),
          ],
        ),
      ),
    );
  }
}
