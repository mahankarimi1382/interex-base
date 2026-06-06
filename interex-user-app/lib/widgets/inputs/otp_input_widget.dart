import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';

class OtpInputTextFieldWidget extends StatelessWidget {
  const OtpInputTextFieldWidget({super.key, required this.controller});

  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialPinField(
      pinController: controller,
      length: 6,
      onChanged: (String value) {},
      theme: MaterialPinTheme(
        borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
        cellSize: const Size(48, 50),
        borderWidth: 2,
        borderColor: CustomColor.primaryTextColor,
        focusedBorderColor: CustomColor.primaryTextColor,
        filledBorderColor: Theme.of(context).primaryColor,
        fillColor: CustomColor.transparent,
        textStyle: TextStyle(color: Theme.of(context).primaryColor),
        cursorColor: CustomColor.primaryLightColor,
        entryAnimation: MaterialPinAnimation.fade,
      ),
    );
  }
}
