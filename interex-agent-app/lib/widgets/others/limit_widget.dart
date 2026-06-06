import 'package:qrpay/utils/basic_screen_imports.dart';
import 'package:qrpay/widgets/text_labels/title_heading5_widget.dart';

class LimitWidget extends StatelessWidget {
  const LimitWidget({
    super.key,

    this.showExchangeRate = false,
    this.exchangeRate,

    required this.fee,
    required this.limit,
    this.showLimit = true,
  });

  final String? exchangeRate;
  final String fee;
  final String limit;
  final bool showLimit;
  final bool showExchangeRate;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 0.2,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Row(
            children: [
              TitleHeading5Widget(
                text: Strings.feesAndCharges,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                    : CustomColor.primaryLightColor.withValues(alpha: 0.6),
              ),
              TitleHeading5Widget(
                text: ": $fee",
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                    : CustomColor.primaryLightColor.withValues(alpha: 0.6),
              ),
            ],
          ),

          if (showExchangeRate)
            Row(
              children: [
                TitleHeading5Widget(
                  text: Strings.exchangeRate,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w500,
                  color: Get.isDarkMode
                      ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                      : CustomColor.primaryLightColor.withValues(alpha: 0.6),
                ),
                TitleHeading5Widget(
                  text: ": $exchangeRate",
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w500,
                  color: Get.isDarkMode
                      ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                      : CustomColor.primaryLightColor.withValues(alpha: 0.6),
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
                      text: Strings.limit,
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w500,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(
                              alpha: 0.8,
                            )
                          : CustomColor.primaryLightColor.withValues(
                              alpha: 0.6,
                            ),
                    ),
                    TitleHeading5Widget(
                      text: ": $limit",
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w500,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(
                              alpha: 0.8,
                            )
                          : CustomColor.primaryLightColor.withValues(
                              alpha: 0.6,
                            ),
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
