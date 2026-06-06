import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/withdraw_controller/withdraw_controller.dart';
import '../../../language/english.dart';
import '../../../routes/routes.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/responsive_layout.dart';
import '../../../widgets/appbar/appbar_widget.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/others/congratulation_widget.dart';

class WithdrawFlutterWaveScreen extends StatelessWidget {
  WithdrawFlutterWaveScreen({super.key});

  final controller = Get.put(WithdrawController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.withdraw),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
        bottomNavigationBar: _buttonWidget(context),
      ),
    );
  }

  Padding _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.9),
      child: ListView(
        children: [
          ...controller.inputFieldsFlutterWave.map((element) {
            return element;
          }),
        ],
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Dimensions.paddingSize * .5),
      child: Obx(
        () => controller.isConfirmManualLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.confirm,
                onPressed: () {
                  // if (formKey.currentState!.validate()) {
                  controller.flutterwavePaymentProcess().then((value) {
                    if (context.mounted) {
                      StatusScreen.show(
                        context: context,
                        subTitle: controller
                            .manualPaymentConfirmModel
                            .message
                            .success
                            .first,
                        onPressed: () {
                          controller.isButtonEnable.value = false;
                          Get.offAllNamed(Routes.bottomNavBarScreen);
                        },
                      );
                    }
                  });
                },
              ),
      ),
    );
  }
}
