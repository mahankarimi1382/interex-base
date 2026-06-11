import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/model/wallets/wallets_model.dart';
import '../../controller/wallets/wallets_controller.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/responsive_layout.dart';
import '../../utils/size.dart';
import '../../utils/strings.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/text_labels/title_heading3_widget.dart';
import '../../widgets/text_labels/title_heading4_widget.dart';

class WalletsScreen extends StatelessWidget {
  WalletsScreen({super.key});
  final controller = Get.put(WalletsController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.myWallets),
        body: _bodyWidget(context),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final List<UserWallet> wallets =
        controller.walletsInfoModel!.data.userWallets;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.5,
        ),
        child: Wrap(
          spacing: Dimensions.marginSizeHorizontal * 0.5,
          runSpacing: Dimensions.marginSizeHorizontal * 0.5,
          children: List.generate(wallets.length, (index) {
            return Container(
              width:
                  MediaQuery.of(context).size.width / 2 -
                  Dimensions.marginSizeHorizontal,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.marginSizeHorizontal * 0.5,
                vertical: Dimensions.marginSizeVertical * 0.45,
              ),
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? CustomColor.whiteColor.withValues(alpha: 0.06)
                    : CustomColor.primaryLightColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
              ),
              child: _buildWalletItem(wallets[index]),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWalletItem(UserWallet wallet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius * 0.8),
            child: Image.network(
              wallet.currency.currencyImage,
              fit: BoxFit.cover,
              height: Dimensions.heightSize * 3,
            ),
          ),
        ),
        horizontalSpace(Dimensions.widthSize),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: crossStart,
            mainAxisAlignment: mainSpaceBet,
            mainAxisSize: mainMin,
            children: [
              TitleHeading3Widget(
                text: wallet.currency.country,
                fontSize: Dimensions.headingTextSize5,
                maxLines: 1,
                color: CustomColor.blackColor,
              ),
              verticalSpace(Dimensions.heightSize * 0.5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TitleHeading4Widget(
                      text: wallet.currency.type == 'FIAT'
                          ? wallet.balance.toStringAsFixed(2)
                          : wallet.balance.toStringAsFixed(8),
                      fontSize: Dimensions.headingTextSize5 * 0.9,
                    ),
                    horizontalSpace(Dimensions.widthSize * 0.5),
                    TitleHeading4Widget(
                      text: wallet.currency.code,
                      color: CustomColor.primaryLightColor,
                      fontSize: Dimensions.headingTextSize5 * 0.9,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
