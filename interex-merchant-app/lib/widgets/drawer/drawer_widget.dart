import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/controller/navbar/dashboard_controller.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/strings.dart';

import '../../backend/local_storage/local_storage.dart';
import '../../backend/utils/custom_loading_api.dart';
import '../../controller/app_settings/app_settings_controller.dart';
import '../../controller/others/log_out_controller.dart';
import '../../controller/profile/update_profile_controller.dart';
import '../../custom_assets/assets.gen.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/drawer_utils.dart';
import '../../utils/size.dart';
import '../../views/others/custom_image_widget.dart';
import '../buttons/primary_button.dart';
import '../text_labels/title_heading2_widget.dart';
import '../text_labels/title_heading3_widget.dart';
import '../text_labels/title_heading4_widget.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final controller = Get.put(UpdateProfileController());
  final dashBoardController = Get.put(DashBoardController());
  final logOutController = Get.put(LogOutController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => dashBoardController.isLoading
          ? const CustomLoadingAPI()
          : SafeArea(
              child: Drawer(
                width: MediaQuery.of(context).size.width / 1.34,
                shape: Platform.isAndroid
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Dimensions.radius * 2),
                        ),
                      )
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Dimensions.radius * 2),
                          bottomRight: Radius.circular(Dimensions.radius * 2),
                        ),
                      ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: ListView(
                  children: [
                    _userImgWidget(context),
                    _userTextWidget(context),
                    _drawerWidget(context),
                  ],
                ),
              ),
            ),
    );
  }

  Center _userImgWidget(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          top: Dimensions.paddingSize,
          bottom: Dimensions.paddingSize,
        ),
        height: Dimensions.heightSize * 8.3,
        width: Dimensions.widthSize * 11.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
          color: Colors.transparent,
          border: Border.all(color: Theme.of(context).primaryColor, width: 5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          child: FadeInImage(
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            image: controller.isLoading
                ? AssetImage(Assets.clipart.user.path) as ImageProvider
                : NetworkImage(
                    controller.profileModel.data.user.image.isNotEmpty
                        ? '${Get.find<AppSettingsController>().baseUrl.value}/${controller.profileModel.data.imagePath}/${controller.profileModel.data.user.image}'
                        : '${Get.find<AppSettingsController>().baseUrl.value}/${controller.profileModel.data.imagePath}/${controller.profileModel.data.defaultImage}',
                  ),
            placeholder: AssetImage(Assets.clipart.user.path),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                Assets.clipart.user.path,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }

  Obx _userTextWidget(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          TitleHeading2Widget(
            text: controller.isLoading
                ? ''
                : controller.profileModel.data.user.firstname +
                      // ignore: prefer_interpolation_to_compose_strings
                      " " +
                      controller.profileModel.data.user.lastname,
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor
                : CustomColor.primaryDarkColor,
          ),
          TitleHeading4Widget(
            text: controller.isLoading
                ? ''
                : controller.profileModel.data.user.email,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.headingTextSize3,
          ),
          verticalSpace(Dimensions.heightSize * 2),
        ],
      ),
    );
  }

  Column _drawerWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      mainAxisAlignment: mainCenter,
      children: [
        _drawerTileWidget(
          context,
          Assets.icon.wallet,
          Strings.myWallets,
          onTap: () {
            Get.toNamed(Routes.walletsScreen);
          },
        ),
        _drawerTileWidget(
          context,
          Assets.icon.tLog,
          Strings.transactionLog,
          onTap: () {
            Get.toNamed(Routes.transactionLogScreen);
          },
        ),
        if (dashBoardController.developerApiKey.value) ...[
          _drawerTileWidget(
            context,
            Assets.icon.api,
            Strings.apiKey,
            onTap: () {
              Get.toNamed(Routes.aPIKeyScreen);
            },
          ),
        ],
        if (dashBoardController.gatewaySetting.value) ...[
          _drawerTileWidget(
            context,
            Assets.icon.gateway,
            Strings.gatewaySettings,
            onTap: () {
              Get.toNamed(Routes.gatewaySettingsScreen);
            },
          ),
        ],
        ...DrawerUtils.items.map((item) {
          return _drawerTileWidget(
            context,
            item['icon'],
            item['title'],
            onTap: () => Get.toNamed('${item['route']}'),
          );
        }),
        InkWell(
          onTap: () {
            _logOutDialogueWidget(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSize * 1,
              vertical: Dimensions.paddingSize * 0.2,
            ),
            child: Row(
              crossAxisAlignment: crossStart,
              mainAxisAlignment: mainStart,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: Dimensions.heightSize * 2.5,
                  width: Dimensions.widthSize * 3.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 0.7,
                    ),
                    color: CustomColor.primaryDarkColor,
                  ),
                  child: CustomImageWidget(
                    path: Assets.icon.signout,
                    height: Dimensions.heightSize * 3,
                    width: Dimensions.widthSize * 3.6,
                  ),
                ),
                horizontalSpace(Dimensions.widthSize),
                TitleHeading3Widget(
                  text: Strings.signOut.tr,
                  color: Get.isDarkMode
                      ? CustomColor.primaryDarkTextColor
                      : CustomColor.primaryLightTextColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InkWell _drawerTileWidget(
    BuildContext context,
    icon,
    title, {
    required VoidCallback onTap,
  }) {
    bool isTablet() {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSize * 1,
          vertical: Dimensions.paddingSize * 0.2,
        ),
        child: Row(
          crossAxisAlignment: crossStart,
          mainAxisAlignment: mainStart,
          children: [
            Container(
              alignment: Alignment.center,
              height: Dimensions.heightSize * (isTablet() ? 2.5 : 2.2),
              width: Dimensions.widthSize * (isTablet() ? 3.3 : 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
                color: CustomColor.primaryDarkColor,
              ),
              child: CustomImageWidget(
                path: icon,
                height: Dimensions.heightSize * 3,
                width: Dimensions.widthSize * 3.6,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: TitleHeading3Widget(
                text: title,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor
                    : CustomColor.primaryLightTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logOutDialogueWidget(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          insetPadding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius * 2),
          ),
          content: Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              return Container(
                width: width * 0.84,
                margin: EdgeInsets.all(Dimensions.paddingSize * 0.5),
                padding: EdgeInsets.all(Dimensions.paddingSize * 0.9),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? CustomColor.primaryBGDarkColor
                      : CustomColor.primaryBGLightColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: crossCenter,
                  children: [
                    SizedBox(height: Dimensions.heightSize * 2),
                    TitleHeading2Widget(text: Strings.signOut.tr),
                    verticalSpace(Dimensions.heightSize * 1),
                    TitleHeading4Widget(text: Strings.logMessage.tr),
                    verticalSpace(Dimensions.heightSize * 1),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .25,
                            child: PrimaryButton(
                              title: Strings.cancel.tr,
                              onPressed: () {
                                Get.close(1);
                              },
                              borderColor: CustomColor.blackColor,
                              buttonColor: CustomColor.blackColor,
                            ),
                          ),
                        ),
                        horizontalSpace(Dimensions.widthSize),
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .25,
                            child: PrimaryButton(
                              title: Strings.signOut.tr,
                              onPressed: () {
                                logOutController.logOutProcess();
                                Get.close(1);
                                LocalStorages.logout();
                                Get.offNamedUntil(
                                  Routes.signInScreen,
                                  (route) => false,
                                );
                              },
                              borderColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
