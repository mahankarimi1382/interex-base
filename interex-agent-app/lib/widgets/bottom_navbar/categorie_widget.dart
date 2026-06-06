import 'package:qrpay/utils/basic_screen_imports.dart';
import 'package:qrpay/views/others/custom_image_widget.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final String icon, text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: Dimensions.radius * 2.5,
            backgroundColor: Get.isDarkMode
                ? CustomColor.whiteColor.withValues(alpha:0.06)
                : Theme.of(context).primaryColor.withValues(alpha:0.06),
            child: CustomImageWidget(
              path: icon,
              height: 20.h,
              width: 20.w,
              color: Get.isDarkMode
                  ? CustomColor.whiteColor
                  : Theme.of(context).primaryColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.5),
          CustomTitleHeadingWidget(
            text: text,
            maxLines: 1,
            textAlign: TextAlign.center,
            textOverflow: TextOverflow.ellipsis,
            style: Get.isDarkMode
                ? CustomStyle.darkHeading5TextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.headingTextSize5 * 0.8,
                  )
                : CustomStyle.lightHeading5TextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.headingTextSize5 * 0.8,
                  ),
          ),
        ],
      ),
    );
  }
}
