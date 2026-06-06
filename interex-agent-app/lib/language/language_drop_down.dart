import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../widgets/text_labels/title_heading4_widget.dart';
import 'language_controller.dart';

class ChangeLanguageWidget extends StatelessWidget {
  const ChangeLanguageWidget({super.key, this.isOnboard = false});
  final bool isOnboard;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !isOnboard
          ? _dropDown(context)
          : Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.paddingVerticalSize * 0,
                horizontal: Dimensions.paddingHorizontalSize * 0.05,
              ),
              decoration: BoxDecoration(
                color: CustomColor.whiteColor.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.6),
              ),
              child: _dropDown(context),
            ),
    );
  }

  SizedBox _dropDown(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: DropdownButton2<String>(
        isDense: false,
        isExpanded: false,
        iconStyleData: const IconStyleData(
          icon: Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.arrow_drop_down_rounded,
              color: CustomColor.primaryLightColor,
            ),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: MediaQuery.sizeOf(context).height * .26,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(Dimensions.radius),
          ),
        ),
        value: Get.find<LanguageController>().selectedLanguage.value,
        underline: Container(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            Get.find<LanguageController>().changeLanguage(newValue);
          }
        },
        items: Get.find<LanguageController>()
            .languages
            .map<DropdownMenuItem<String>>(
          (language) {
            return DropdownMenuItem<String>(
              value: language.code,
              child: TitleHeading4Widget(
                text: isOnboard ? language.code.toUpperCase() : language.name,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
