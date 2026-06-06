import 'package:qrpay/utils/basic_screen_imports.dart';
import 'package:qrpay/widgets/text_labels/title_heading5_widget.dart';

extension AmountInformation on Widget {
  Widget amountInformationWidget({
    required String information,
    required enterAmount,
    required enterAmountRow,
    required fee,
    required feeRow,
    received,
    receivedRow,
    total,
    totalRow,
    Widget? children,
  }) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.heightSize * 0.4),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? CustomColor.primaryBGDarkColor
            : CustomColor.primaryBGLightColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.marginSizeVertical * 0.7,
              bottom: Dimensions.marginSizeVertical * 0.3,
              left: Dimensions.paddingSize * 0.4,
              right: Dimensions.paddingSize * 0.4,
            ),
            child: CustomTitleHeadingWidget(
              text: information,
              textAlign: TextAlign.left,
              style: Get.isDarkMode
                  ? CustomStyle.f20w600pri.copyWith(
                      color: CustomColor.primaryDarkTextColor,
                    )
                  : CustomStyle.f20w600pri,
            ),
          ),
          Divider(
            thickness: 1,
            color: CustomColor.primaryLightColor.withValues(alpha:0.2),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.marginSizeVertical * 0.3,
              bottom: Dimensions.marginSizeVertical * 0.6,
              left: Dimensions.paddingSize * 0.4,
              right: Dimensions.paddingSize * 0.4,
            ),
            child: Column(
              children: [
                ...[
                  Container(child: children),
                ],
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading5Widget(
                      text: enterAmount,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                          : CustomColor.primaryLightColor.withValues(alpha:
                              0.4,
                            ),
                    ),
                    TitleHeading4Widget(
                      text: enterAmountRow,
                      maxLines: 2,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                          : CustomColor.primaryLightColor.withValues(alpha:
                              0.6,
                            ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.heightSize * 0.7),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading5Widget(
                      text: fee,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                          : CustomColor.primaryLightColor.withValues(alpha:
                              0.4,
                            ),
                    ),
                    TitleHeading4Widget(
                      text: feeRow,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                          : CustomColor.primaryLightColor.withValues(alpha:
                              0.6,
                            ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.heightSize * 0.7),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading5Widget(
                      text: received,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                          : CustomColor.primaryLightColor.withValues(alpha:
                              0.4,
                            ),
                    ),
                    TitleHeading4Widget(
                      text: receivedRow,
                      textOverflow: TextOverflow.ellipsis,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                          : CustomColor.primaryLightColor.withValues(alpha:
                              0.6,
                            ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.heightSize * 0.7),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading5Widget(
                      text: total,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                          : CustomColor.primaryLightColor.withValues(alpha:
                              0.4,
                            ),
                    ),
                    TitleHeading4Widget(
                      text: totalRow,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor.withValues(alpha:0.6)
                          : CustomColor.primaryLightColor.withValues(alpha:
                              0.6,
                            ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
