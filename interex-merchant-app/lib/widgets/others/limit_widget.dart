import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/widgets/text_labels/title_heading5_widget.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../utils/strings.dart';

class LimitWidget extends StatelessWidget {
  const LimitWidget({super.key, required this.fee, required this.limit});
  final String fee;
  final String limit;

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
          verticalSpace(Dimensions.heightSize * 0.2),
          Row(
            children: [
              TitleHeading5Widget(
                text: Strings.limit,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                    : CustomColor.primaryLightColor.withValues(alpha: 0.6),
              ),
              TitleHeading5Widget(
                text: ": $limit",
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                    : CustomColor.primaryLightColor.withValues(alpha: 0.6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
