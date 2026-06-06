import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';

import '../../backend/local_storage/local_storage.dart';
import '../../controller/drawer/setting_controller.dart';
import '../../controller/navbar/dashboard_controller.dart';
import '../../language/language_drop_down.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/responsive_layout.dart';
import '../../utils/size.dart';
import '../../utils/theme.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/text_labels/title_heading2_widget.dart';
import '../../widgets/text_labels/title_heading4_widget.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: Strings.settings.tr),
        body: _bodyWidget(context),
      ),
    );
  }

  Padding _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.9,
      ),
      child: Column(
        children: [
          !Get.find<DashBoardController>().pinVerification.value
              ? SizedBox.shrink()
              : customButtonWidget(
                  context,
                  title: Strings.pinSetup,
                  onTap: () {
                    Get.toNamed(Routes.pinSetupScreen);
                  },
                ),
          customButtonWidget(
            context,
            title: Strings.updateKYC,
            onTap: () {
              Get.toNamed(Routes.updateKycScreen);
            },
          ),
          customButtonWidget(
            context,
            title: Strings.twoFaSecurity,
            onTap: () {
              Get.toNamed(Routes.enable2FaScreen);
            },
          ),
          customButtonWidget(
            context,
            title: Strings.changePassword,
            onTap: () {
              Get.toNamed(Routes.changePasswordScreen);
            },
          ),
          _changeLanguageWidget(context),
          _changeTheme(context),
          _deleteAccountWidget(context),
        ],
      ),
    );
  }

  InkWell _changeTheme(BuildContext context) {
    return InkWell(
      onTap: () {
        Themes().switchTheme();
      },
      child: Row(
        crossAxisAlignment: crossEnd,
        mainAxisAlignment: mainSpaceBet,
        children: [
          TitleHeading4Widget(
            text: Strings.changeThemes,
            fontWeight: FontWeight.w500,
            fontSize: Dimensions.headingTextSize3,
            color: Get.isDarkMode
                ? CustomColor.whiteColor
                : Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: Dimensions.heightSize * 1.8,
            child: Switch.adaptive(
              value: Themes().theme == ThemeMode.dark,
              activeThumbColor: CustomColor.primaryDarkColor,
              onChanged: (value) {
                Themes().switchTheme();
              },
            ),
          ),
        ],
      ),
    );
  }

  Column _changeLanguageWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TitleHeading4Widget(
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSize * .2,
                ),
                text: Strings.changeLanguage,
                fontWeight: FontWeight.normal,
                fontSize: Dimensions.headingTextSize3,
                color: Get.isDarkMode
                    ? CustomColor.whiteColor
                    : Theme.of(context).primaryColor,
              ),
            ),
            Expanded(child: ChangeLanguageWidget()),
          ],
        ),
        Divider(
          thickness: Dimensions.radius * .1,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  Column _deleteAccountWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      mainAxisAlignment: mainStart,
      children: [
        verticalSpace(Dimensions.heightSize * 0.8),
        InkWell(
          onTap: () {
            _openDialogueForDeleteAccount(context);
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: TitleHeading4Widget(
              text: Strings.deleteAccount.tr,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.headingTextSize3,
              color: Get.isDarkMode
                  ? CustomColor.whiteColor
                  : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  void _openDialogueForDeleteAccount(BuildContext context) {
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
            borderRadius: BorderRadius.circular(20),
          ),
          content: Builder(
            builder: (context) {
              var width = MediaQuery.of(context).size.width;
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
                    TitleHeading2Widget(text: Strings.deleteAccount.tr),
                    verticalSpace(Dimensions.heightSize * 1),
                    TitleHeading4Widget(text: Strings.deleteAccountSubTitle.tr),
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
                            child: Obx(
                              () => controller.isLoading
                                  ? const CustomLoadingAPI()
                                  : PrimaryButton(
                                      title: Strings.okay.tr,
                                      onPressed: () {
                                        controller.deleteAccountProcess().then((
                                          value,
                                        ) {
                                          LocalStorages.logout();
                                          Get.offNamedUntil(
                                            Routes.signInScreen,
                                            (route) => false,
                                          );
                                        });
                                      },
                                      borderColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                    ),
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

  Column customButtonWidget(
    BuildContext context, {
    required VoidCallback onTap,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: Dimensions.marginSizeVertical * 0.25,
            bottom: Dimensions.marginSizeVertical * 0.22,
          ),
          child: InkWell(
            onTap: onTap,
            child: TitleHeading4Widget(
              text: title,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.headingTextSize3,
              color: Get.isDarkMode
                  ? CustomColor.whiteColor
                  : Theme.of(context).primaryColor,
            ),
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.5),
        Divider(
          height: 1.5,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
