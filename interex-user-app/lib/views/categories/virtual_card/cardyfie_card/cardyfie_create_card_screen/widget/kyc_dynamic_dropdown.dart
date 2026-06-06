import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/custom_color.dart';
import '../../../../../../utils/custom_style.dart';
import '../../../../../../utils/dimensions.dart';
import '../../../../../../widgets/text_labels/title_heading4_widget.dart';

class KycDynamicDropDown extends StatelessWidget {
  final RxString selectMethod;
  final List<String> itemsList;
  final void Function(String?)? onChanged;

  const KycDynamicDropDown({
    required this.itemsList,
    super.key,
    required this.selectMethod,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColor.primaryLightColor.withValues(alpha: 0.2),
            width: 1.5,
          ),

          borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
        ),

        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 20),
            child: DropdownButton(
              dropdownColor: CustomColor.whiteColor,
              hint: Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSize * 0.7),
                child: Text(
                  selectMethod.value,
                  style: CustomStyle.darkHeading4TextStyle.copyWith(
                    color: CustomColor.primaryLightColor,
                    fontSize: Dimensions.headingTextSize3,

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Get.isDarkMode
                      ? CustomColor.primaryLightColor
                      : CustomColor.primaryLightColor,
                ),
              ),
              isExpanded: true,
              borderRadius: BorderRadius.circular(Dimensions.radius),
              items: itemsList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: TitleHeading4Widget(text: value.toString()),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
