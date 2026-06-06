import 'package:flutter/services.dart';

import '../../language/language_controller.dart';
import '../../utils/basic_screen_imports.dart';

class PrimaryTextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText, optional, hint;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Color? color;
  final int maxLine;
  final double focusedBorderWidth;
  final double enabledBorderWidth;
  final Widget? suffixIcon, prefixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const PrimaryTextInputWidget({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.readOnly = false,
    this.focusedBorderWidth = 1.2,
    this.enabledBorderWidth = 1,
    this.maxLine = 1,
    this.color = Colors.transparent,
    this.suffixIcon,
    this.onTap,
    this.optional = "",
    this.hint = "",
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TitleHeading4Widget(text: labelText, fontWeight: FontWeight.w600),
            horizontalSpace(Dimensions.widthSize * 0.5),
            Visibility(
              visible: optional.isNotEmpty,
              child: TitleHeading4Widget(
                text: optional,
                opacity: .4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.marginBetweenInputTitleAndBox * 1),
        TextFormField(
          cursorColor: CustomColor.primaryLightColor,

          maxLines: maxLine,
          style: CustomStyle.lightHeading3TextStyle.copyWith(
            color: CustomColor.blackColor,
          ),
          readOnly: readOnly!,
          // style: CustomStyle.textStyle,
          controller: controller,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          validator:
              validator ??
              (String? value) {
                if (value!.isEmpty && maxLine == 1) {
                  return Get.find<LanguageController>().isLoading
                      ? ""
                      : Get.find<LanguageController>().getTranslation(
                          Strings.pleaseFillOutTheField,
                        );
                } else {
                  return null;
                }
              },
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                width: enabledBorderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: focusedBorderWidth,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: color,
            contentPadding: const EdgeInsets.only(
              left: 16,
              right: 10,
              top: 10,
              bottom: 10,
            ),
            hintText: Get.find<LanguageController>().isLoading
                ? ""
                : "${Get.find<LanguageController>().getTranslation(Strings.enter)} ${Get.find<LanguageController>().getTranslation(labelText)}",
            hintStyle: Get.isDarkMode
                ? CustomStyle.darkHeading3TextStyle.copyWith(
                    color: CustomColor.primaryDarkTextColor.withValues(
                      alpha: 0.2,
                    ),
                    fontWeight: FontWeight.w500,
                    fontSize: Dimensions.headingTextSize3,
                  )
                : CustomStyle.lightHeading3TextStyle.copyWith(
                    color: CustomColor.primaryLightTextColor.withValues(
                      alpha: 0.2,
                    ),
                    fontWeight: FontWeight.w500,
                    fontSize: Dimensions.headingTextSize3,
                  ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}
