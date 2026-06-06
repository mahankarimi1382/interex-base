// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpaypro/routes/routes.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';

import '../../../../controller/categories/virtual_card/flutter_wave_virtual_card/adfund_controller.dart';
import '../../../../language/english.dart';
import '../../../../widgets/others/congratulation_widget.dart';
import '../../../../widgets/others/customInput_widget.dart/add_fund_keybaord.dart';
import '../../../set_up_pin/controller/set_up_pin_controller.dart';

class AddFundScreen extends StatelessWidget {
  AddFundScreen({super.key, required this.appBarTitle});

  final String appBarTitle;
  final controller = Get.put(AddFundController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: appBarTitle),
        body: _bodyWidget(context),
      ),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        AddFundCustomAmountWidget(
          buttonText: appBarTitle,
          onTap: () {
            if (appBarTitle == Strings.addFund) {
              debugPrint(appBarTitle);
              Get.find<SetUpPinController>().showPinDialog(
                context,
                onSuccess: () {
                  controller.carAddFundProcess().then(
                    (value) => StatusScreen.show(
                      context: context,
                      subTitle: Strings.addMoneySuccessfully.tr,
                      onPressed: () {
                        Get.offAllNamed(Routes.bottomNavBarScreen);
                      },
                    ),
                  );
                },
              );
              debugPrint("appbar two $appBarTitle");
            } else {
              controller.cardCreateProcess();
            }
          },
        ),
      ],
    );
  }
}
