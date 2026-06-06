import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';

import '../../../../controller/categories/virtual_card/sudo_virtual_card/sudo_adfund_controller.dart';
import '../../../../language/english.dart';
import '../../../../widgets/others/customInput_widget.dart/sudo_add_fund_keybaord.dart';
import '../../../set_up_pin/controller/set_up_pin_controller.dart';

class SudoAddFundScreen extends StatelessWidget {
  SudoAddFundScreen({super.key, required this.appBarTitle});

  final String appBarTitle;
  final controller = Get.put(SudoAddFundController());

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
        SudoAddFundCustomAmountWidget(
          buttonText: appBarTitle,
          onTap: () {
            debugPrint(appBarTitle);
            if (appBarTitle == Strings.addFund) {
            } else {
              Get.find<SetUpPinController>().showPinDialog(context,
                  onSuccess: () {
                controller.cardCreateProcess();
              });
            }
          },
        ),
      ],
    );
  }
}
