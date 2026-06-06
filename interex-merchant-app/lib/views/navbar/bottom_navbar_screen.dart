import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/controller/navbar/navbar_controller.dart';
import 'package:qrpay/custom_assets/assets.gen.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/views/others/custom_image_widget.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../../widgets/bottom_navbar/bottom_navber.dart';
import '../../widgets/drawer/drawer_widget.dart';
import '../../widgets/text_labels/title_heading4_widget.dart';

class BottomNavBarScreen extends StatelessWidget {
  final bottomNavBarController = Get.put(NavbarController(), permanent: false);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  BottomNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        drawer: CustomDrawer(),
        key: scaffoldKey,
        appBar: appBarWidget(context),
        extendBody: true,
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar:
            buildBottomNavigationMenu(context, bottomNavBarController),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: bottomNavBarController
            .page[bottomNavBarController.selectedIndex.value],
      ),
    );
  }

  AppBar appBarWidget(BuildContext context) {
    bool isTablet() {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: bottomNavBarController.selectedIndex.value == 0 ? 0 : 0,
      centerTitle: true,
      leading: bottomNavBarController.selectedIndex.value == 0
          ? GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: isTablet()
                      ? Dimensions.paddingSize * 0.4
                      : Dimensions.paddingSize,
                  right: isTablet() ? 0 : Dimensions.paddingSize * 0.2,
                ),
                child: CustomImageWidget(
                  path: Assets.icon.drawerMenu,
                  height: Dimensions.heightSize * 2,
                  width: Dimensions.widthSize * 2.4,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Container(),
      title: bottomNavBarController.selectedIndex.value == 0
          ? Padding(
              padding: EdgeInsets.all(Dimensions.paddingSize * 1.2),
              child: TitleHeading4Widget(
                text: Strings.appName.toUpperCase(),
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor
                    : CustomColor.primaryDarkColor,
                fontSize: Dimensions.headingTextSize1 * 0.6,
              ),
            )
          : TitleHeading4Widget(
              text: Strings.notification.tr,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.headingTextSize1 * 0.6,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor
                  : CustomColor.primaryDarkColor,
            ),
      actions: [
        bottomNavBarController.selectedIndex.value == 0
            ? Padding(
                padding: EdgeInsets.only(right: Dimensions.paddingSize * 0.6),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.updateProfileScreen);
                  },
                  child: CustomImageWidget(
                    path: Assets.icon.profile,
                    height: Dimensions.heightSize * 2.0,
                    width: Dimensions.widthSize * 2.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
