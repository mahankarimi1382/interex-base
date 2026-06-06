import 'package:qrpaypro/utils/basic_screen_imports.dart';
import 'package:qrpaypro/widgets/text_labels/title_heading5_widget.dart';

class LimitWidget extends StatelessWidget {
  const LimitWidget(
      {super.key,
      required this.fee,
      required this.limit,
           this.showExchangeRate = false,
      this.exchangeRate,
        this.feeText,
        this.limitText,
      this.showLimit = true});
  final String? fee, feeText;
  
  final String? limit, limitText;
  final bool showLimit;
    final bool showExchangeRate;
     final String? exchangeRate;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 0.2),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Row(
            children: [
              TitleHeading5Widget(
                text: feeText ?? Strings.feesAndCharges,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withValues(alpha:0.8)
                    : CustomColor.primaryLightColor.withValues(alpha:0.6),
              ),
              TitleHeading5Widget(
                text: ": $fee",
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withValues(alpha:0.8)
                    : CustomColor.primaryLightColor.withValues(alpha:0.6),
              ),
            ],
          ),


          if(showExchangeRate)
            Row(
            children: [
              TitleHeading5Widget(
                text: Strings.exchangeRate,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withValues(alpha:0.8)
                    : CustomColor.primaryLightColor.withValues(alpha:0.6),
              ),
              TitleHeading5Widget(
                text: ": $exchangeRate",
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withValues(alpha:0.8)
                    : CustomColor.primaryLightColor.withValues(alpha:0.6),
              ),
            ],
          ),
          if (showLimit)
            Column(
              children: [
                verticalSpace(Dimensions.heightSize * 0.2),
                Row(
                  children: [
                    TitleHeading5Widget(
                      text: limitText ?? Strings.limit,
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w500,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.8)
                          : CustomColor.primaryLightColor.withValues(alpha:0.6),
                    ),
                    TitleHeading5Widget(
                      text: ": $limit",
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w500,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.8)
                          : CustomColor.primaryLightColor.withValues(alpha:0.6),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
