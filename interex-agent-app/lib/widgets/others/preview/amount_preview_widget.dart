import '/utils/basic_screen_imports.dart';

extension PreviewAmount on Widget {
  Widget previewAmount({
    required String amount,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? CustomColor.primaryBGDarkColor
            : CustomColor.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
        boxShadow: const [BoxShadow()],
      ),
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 0.2),
      padding:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 1.3),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          CustomTitleHeadingWidget(
            text: amount,
            textAlign: TextAlign.center,
            style: CustomStyle.darkHeading1TextStyle.copyWith(
              fontSize: Dimensions.headingTextSize4 * 2,
              fontWeight: FontWeight.w800,
              color: CustomColor.primaryLightColor,
            ),
          ),
          CustomTitleHeadingWidget(
            text: Strings.enteredAmount,
            textAlign: TextAlign.center,
            style: Get.isDarkMode
                ? CustomStyle.darkHeading4TextStyle
                : CustomStyle.lightHeading4TextStyle,
            opacity: 0.75,
          ),
        ],
      ),
    );
  }
}
