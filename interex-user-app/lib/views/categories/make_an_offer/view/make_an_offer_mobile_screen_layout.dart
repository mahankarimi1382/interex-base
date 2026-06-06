import 'package:flutter/services.dart';
import 'package:qrpaypro/backend/utils/custom_loading_api.dart';

import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/appbar/back_button.dart';
import '../controller/make_an_offer_controller.dart';
import '../widget/make_an_offer_fields_widget.dart';
import '../widget/make_an_offer_rate_widget.dart';

class MakeAnOfferPreviewMobileScreenLayout extends StatelessWidget {
  MakeAnOfferPreviewMobileScreenLayout({super.key, required this.controller});

  final MakeAnOfferController controller;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBarWidget(context), body: _bodyWidget(context));
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      children: [
        MakeAnOfferRateWidget(controller: controller),
        MakeAnOfferFieldsWidget(controller: controller),
        _sendOfferButtonWidget(context),
      ],
    ).paddingSymmetric(horizontal: Dimensions.marginSizeHorizontal * 0.8);
  }

  Obx _sendOfferButtonWidget(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? CustomLoadingAPI()
          : PrimaryButton(
              title: Strings.sendOffer,
              onPressed: () {
                controller.onSendOffer;
              },
            ),
    );
  }

  AppBar _appBarWidget(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      leading: BackButtonWidget(
        onTap: () {
          Get.close(1);
        },
      ),
      title: Row(
        children: [
          TitleHeading2Widget(text: controller.sellerName.value),
          CircleAvatar(
            radius: Dimensions.radius * 0.4,
            backgroundColor: Get.isDarkMode
                ? CustomColor.whiteColor.withValues(alpha: 0.30)
                : CustomColor.blackColor.withValues(alpha: 0.30),
          ).paddingSymmetric(horizontal: Dimensions.marginSizeHorizontal * 0.2),
          TitleHeading4Widget(
            text: controller.isVerified.value
                ? Strings.verified
                : Strings.unVerified,
            color: controller.isVerified.value
                ? Theme.of(context).primaryColor
                : CustomColor.redColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }
}
