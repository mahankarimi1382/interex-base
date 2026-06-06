import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/inputs/copy_with_input.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/money_receiver_controller/money_receiver_controller.dart';
import '../../../custom_assets/assets.gen.dart';
import '../../../language/english.dart';
import '../../../utils/dimensions.dart';

class MoneyReceiveScreen extends StatelessWidget {
  MoneyReceiveScreen({super.key});

  final controller = Get.put(MoneyReceiverController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.moneyReceive),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.9,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _imgWidget(context),
        _inputWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  Container _imgWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize,
        vertical: Dimensions.paddingSize * 1,
      ),
      decoration: BoxDecoration(
        color: CustomColor.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
      ),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.3,
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 1.4,
        horizontal: Dimensions.marginSizeHorizontal * 1.2,
      ),
      child: SizedBox(
        width: Dimensions.widthSize * 24,
        height: Dimensions.heightSize * 22,
        child: CachedNetworkImage(
          imageUrl: controller.receiveMoneyModel.data.qrCode,
          placeholder: (context, url) => const CustomLoadingAPI(),
        ),
      ),
    );
  }

  Column _inputWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        CopyInputWidget(
          suffixIcon: Assets.icon.copy,
          onTap: () {
            Clipboard.setData(
              ClipboardData(text: controller.inputController.text),
            ).then((_) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(Strings.qrCodeAddressCopy)),
              );
            });
          },
          controller: controller.inputController,
          hint: Strings.qrCode,
          label: Strings.qrAddress,
        ),
        verticalSpace(Dimensions.heightSize * 0.5),
        CustomTitleHeadingWidget(
          text: Strings.useAppForInstant,
          textAlign: TextAlign.justify,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            fontSize: Dimensions.headingTextSize5,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 4,
        bottom: Dimensions.marginSizeVertical * 0.4,
      ),
      child: PrimaryButton(
        title: Strings.share,
        onPressed: () {
          SharePlus.instance.share(
            ShareParams(text: controller.receiveMoneyModel.data.qrCode),
          );
        },
      ),
    );
  }
}
