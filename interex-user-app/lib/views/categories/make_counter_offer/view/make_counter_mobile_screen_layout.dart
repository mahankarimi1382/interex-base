import 'package:flutter/services.dart';
import 'package:qrpaypro/backend/utils/custom_loading_api.dart';

import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/appbar/back_button.dart';
import '../controller/make_counter_offer_controller.dart';
import '../widget/make_counter_offer_fields_widget.dart';
import '../widget/make_counter_offer_rate_widget.dart';

class MakeCounterOfferMobileScreenLayout extends StatelessWidget {
  final MakeCounterOfferController controller;

  final formKey = GlobalKey<FormState>();
  MakeCounterOfferMobileScreenLayout({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBarWidget(context), body: _bodyWidget(context));
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
          // Get.close(1);
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
            text: Strings.verified,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      children: [
        MakeCounterOfferRateWidget(controller: controller),
        if (controller.isCounterOffer.value) ...[
          MakeCounterOfferFieldsWidget(controller: controller),
          _makeAnOfferButtonWidget(context),
          _rejectButtonWidget(context),
        ],
      ],
    ).paddingSymmetric(horizontal: Dimensions.marginSizeHorizontal * 0.8);
  }

  Obx _makeAnOfferButtonWidget(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? CustomLoadingAPI()
          : PrimaryButton(
              title: Strings.makeCounterOffer,
              // buttonColor: Colors.orange,
              // borderColor: Colors.orange,
              onPressed: () {
                controller.onCounterOffer;
              },
            ),
    );
  }

  Widget _rejectButtonWidget(BuildContext context) {
    return PrimaryButton(
      title: Strings.reject,
      buttonColor: CustomColor.redColor,
      borderColor: CustomColor.redColor,
      borderWidth: 2,
      buttonTextColor: CustomColor.redColor,
      onPressed: () {
        controller.offerStatusProcessApi('Reject');
      },
    ).paddingOnly(
      top: Dimensions.marginBetweenInputTitleAndBox,
      bottom: Dimensions.marginSizeVertical,
    );
  }
}
