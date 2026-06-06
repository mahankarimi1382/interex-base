import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/widgets/text_labels/title_heading1_widget.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSize),
        margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: 0.8,
                child: Icon(
                  Icons.hourglass_empty,
                  size: Dimensions.iconSizeLarge * 1.5,
                ),
              ),
              verticalSpace(Dimensions.paddingSize * 0.3),
              TitleHeading1Widget(
                text: title ?? Strings.emptyStatus,
                opacity: 0.8,
                textAlign: TextAlign.center,
                fontSize: Dimensions.headingTextSize3,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor
                    : CustomColor.primaryLightTextColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
