import 'package:qrpaypro/utils/basic_screen_imports.dart';


class TitleSubTitleWidget extends StatelessWidget {
  const TitleSubTitleWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      this.crossAxisAlignment = CrossAxisAlignment.start});
  final String title, subtitle;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        TitleHeading1Widget(
          text: title,
          padding: EdgeInsets.only(bottom: Dimensions.marginSizeVertical * 0.3),
        ),
        CustomTitleHeadingWidget(
          text: subtitle,
          opacity: .7,
          textAlign: TextAlign.center,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            fontSize: Dimensions.headingTextSize4,
            color: Get.isDarkMode ? CustomColor.whiteColor : CustomColor.blackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
