import 'package:qrpaypro/utils/dimensions.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';
import 'package:qrpaypro/widgets/buttons/primary_button.dart';
import 'package:qrpaypro/widgets/others/preview/amount_preview_widget.dart';
import 'package:qrpaypro/widgets/others/preview/information_amount_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../language/english.dart';
import '../../../../routes/routes.dart';
import '../../../../widgets/others/congratulation_widget.dart';

class AddFundPreviewScreen extends StatelessWidget {
  const AddFundPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileScaffold: Scaffold(
          appBar: const AppBarWidget(text: Strings.preview),
          body: _bodyWidget(context),
        ));
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.8),
      physics: const BouncingScrollPhysics(),
      children: [
        _amountWidget(context),
        _amountInformationWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  Widget _amountWidget(BuildContext context) {
    return previewAmount(amount: Strings.usd100);
  }

  Widget _amountInformationWidget(BuildContext context) {
    return amountInformationWidget(
      information: Strings.amountInformation,
      enterAmount: Strings.enterAmount,
      enterAmountRow: Strings.usd100,
      fee: Strings.transferFee,
      feeRow: Strings.uSD2,
      received: Strings.recipientReceived,
      receivedRow: Strings.uSD98,
      total: Strings.totalPayable,
      totalRow: Strings.usd102,
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 2,),
      child: PrimaryButton(
          title: Strings.confirm,
          onPressed: () {
            StatusScreen.show(
                context: context,
                subTitle: Strings.addMoneySuccessfully.tr,
                onPressed: () {
                  Get.toNamed(
                    Routes.bottomNavBarScreen,
                  );
                });
          }),
    );
  }
}
