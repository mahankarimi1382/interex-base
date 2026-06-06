import 'package:flutter/services.dart';
import 'package:qrpaypro/backend/utils/custom_loading_api.dart';

import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/appbar/back_button.dart';
import '../controller/marketplace_buying_preview_controller.dart';
import '../widget/marketplace_payment_details_widget.dart';
import '../widget/marketplace_rate_with_gateway_widget.dart';

class MarketplaceBuyingPreviewMobileScreenLayout extends StatelessWidget {
  MarketplaceBuyingPreviewMobileScreenLayout({
    super.key,
    required this.controller,
  });

  final MarketplaceBuyingPreviewController controller;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBarWidget(context), body: _bodyWidget(context));
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.75,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        MarketplaceGatewayWidget(controller: controller),
        MarketplacePaymentDetailsWidget(controller: controller),
        _confirmButtonWidget(),
      ],
    );
  }

  Obx _confirmButtonWidget() {
    return Obx(
      () => controller.isConfirmLoading
          ? CustomLoadingAPI()
          : PrimaryButton(
              title: Strings.confirm,
              onPressed: () {
                controller.onConfirm;
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
