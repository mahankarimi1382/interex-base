import 'package:flutter/material.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * .25),
      height: Dimensions.heightSize * .17,
      decoration: BoxDecoration(
        color: CustomColor.primaryLightTextColor.withValues(alpha:
          .1,
        ),
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(Dimensions.radius),
          right: Radius.circular(
            Dimensions.radius,
          ),
        ),
      ),
    );
  }
}
