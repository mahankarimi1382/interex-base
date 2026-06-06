import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpaypro/backend/utils/custom_loading_api.dart';
import 'package:qrpaypro/utils/dimensions.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/utils/size.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';
import 'package:qrpaypro/widgets/buttons/primary_button.dart';
import 'package:qrpaypro/widgets/inputs/password_input_widget.dart';

import '../../controller/drawer/change_password_controller.dart';
import '../../language/english.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final controller = Get.put(PasswordController());
  final passwordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.changePassword),
        body: _bodyWidget(context),
      ),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.9),
      physics: const BouncingScrollPhysics(),
      children: [
        _inputWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  Form _inputWidget(BuildContext context) {
    return Form(
      key: passwordKey,
      child: Column(
        children: [
          verticalSpace(Dimensions.heightSize * 2),
          PasswordInputWidget(
            controller: controller.oldPasswordController,
            hint: Strings.enterOldPassword,
            label: Strings.oldPassword,
          ),
          verticalSpace(Dimensions.heightSize),
          PasswordInputWidget(
            controller: controller.newPasswordController,
            hint: Strings.enterNewPassword,
            label: Strings.newPassword,
          ),
          verticalSpace(Dimensions.heightSize),
          PasswordInputWidget(
            controller: controller.confirmPasswordController,
            hint: Strings.enterConfirmPassword,
            label: Strings.confirmPassword,
          ),
        ],
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 2),
      child: Obx(
        () => controller.isLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                onPressed: () {
                  // controller.gotoNavigation();
                  if (passwordKey.currentState!.validate()) {
                    controller.updatePasswordProcess();
                  }
                },
                title: Strings.changePassword,
              ),
      ),
    );
  }
}
