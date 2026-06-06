import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qrpay/views/set_up_pin/controller/set_up_pin_controller.dart';

import '/backend/utils/custom_loading_api.dart';
import '/controller/navbar/dashboard_controller.dart';
import '/utils/custom_color.dart';
import '/utils/custom_style.dart';
import '/utils/dimensions.dart';
import '/utils/responsive_layout.dart';
import '/utils/size.dart';
import '/widgets/bottom_navbar/categorie_widget.dart';
import '/widgets/others/glass_widget.dart';
import '/widgets/text_labels/custom_title_heading_widget.dart';
import '../../backend/local_storage/local_storage.dart';
import '../../language/english.dart';
import '../../widgets/animation/lottie.dart';
import '../../widgets/bottom_navbar/transaction_history_widget.dart';
import '../../widgets/text_labels/title_heading3_widget.dart';
import '../../widgets/text_labels/title_heading4_widget.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controller = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        body: Obx(
          () => controller.isLoading || controller.walletController.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  RefreshIndicator _bodyWidget(BuildContext context) {
    return RefreshIndicator(
      color: CustomColor.primaryLightColor,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await controller.getDashboardData();
        await controller.walletController.getWalletsInfoProcess();
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.3,
            padding: EdgeInsets.all(Dimensions.paddingSize),
            // color: CustomColor.primaryLightColor,
          ),
          ListView(
            children: [
              verticalSpace(Dimensions.heightSize * .5),
              _walletsWidget(context),
              verticalSpace(Dimensions.heightSize * .3),
              _categoriesWidget(context),
            ],
          ),
          _draggableSheet(context),
        ],
      ),
    );
  }

  DraggableScrollableSheet _draggableSheet(BuildContext context) {
    bool isTablet() {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return DraggableScrollableSheet(
      builder: (_, scrollController) {
        return _transactionWidget(context, scrollController);
      },
      initialChildSize: isTablet() ? 0.48 : 0.47,
      minChildSize: isTablet() ? 0.48 : 0.47,
      maxChildSize: 0.80,
    );
  }

  Container _categoriesWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: Dimensions.marginSizeHorizontal * 0.8,
        left: Dimensions.marginSizeHorizontal * 0.8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.4,
        vertical: Dimensions.marginSizeVertical * 0.7,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius * 2),
        color: Get.isDarkMode
            ? const Color.fromARGB(255, 22, 25, 49)
            : Theme.of(context).colorScheme.surface,
      ),
      child: GridView.count(
        padding: const EdgeInsets.only(),
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 10.0,
        shrinkWrap: true,
        children: List.generate(
          controller.categoriesData.length,
          (index) => CategoriesWidget(
            onTap: () {
              // Get.find<SetUpPinController>().showPinDialog(context, onSuccess: (){});

              Get.find<SetUpPinController>().pinVerificationCheck(
                onChecked: controller.categoriesData[index].onTap,
              );
            },
            icon: controller.categoriesData[index].icon,
            text: controller.categoriesData[index].text,
          ),
        ),
      ),
    );
  }

  Widget _transactionWidget(
    BuildContext context,
    ScrollController scrollController,
  ) {
    final data = controller.dashBoardModel.data.transactions;
    return data.isEmpty
        ? const LottieAnimation().paddingOnly(
            bottom: Dimensions.marginSizeVertical * 2.5,
          )
        : ListView(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSize * 0.8,
              // vertical: Dimensions.paddingVerticalSize * 5,
            ),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CustomTitleHeadingWidget(
                text: Strings.recentTransactions,
                padding: EdgeInsets.only(top: Dimensions.marginSizeVertical),
                style: Get.isDarkMode
                    ? CustomStyle.darkHeading3TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize2 * 0.9,
                        fontWeight: FontWeight.w500,
                      )
                    : CustomStyle.lightHeading3TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize2 * 0.9,
                        fontWeight: FontWeight.w500,
                      ),
              ),
              verticalSpace(Dimensions.heightSize * 0.8),
              SizedBox(
                height: MediaQuery.of(context).size.height * .6,
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return TransactionWidget(
                      amount: data[index].requestAmount,
                      status: data[index].status,
                      title: data[index].transactionType,
                      dateText: DateFormat.d().format(data[index].dateTime),
                      transaction: data[index].trx,
                      monthText: DateFormat.MMMM().format(data[index].dateTime),
                      payableAmount: data[index].payable,
                    );
                  },
                ),
              ),
            ],
          ).customGlassWidget();
  }

  Column _walletsWidget(BuildContext context) {
    final wallets = controller
        .walletController
        .walletsInfoModel
        .data
        .userWallets
        .where(
          (e) =>
              e.currency.type ==
              (controller.switchCurrency.value == 0 ? 'FIAT' : 'CRYPTO'),
        )
        .toList();
    final int precision = controller.switchCurrency.value == 0
        ? LocalStorage.getFiatPrecision()
        : LocalStorage.getCryptoPrecision();
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeHorizontal * 0.9,
          ),
          child: Column(children: [_currencySwitchWidget(context)]),
        ),
        verticalSpace(Dimensions.heightSize * 0.8),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.12,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              wallets.length,
              (index) => Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? Dimensions.marginSizeHorizontal * 0.8 : 0,
                  right: Dimensions.marginSizeHorizontal * 0.5,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.marginSizeHorizontal * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? CustomColor.whiteColor.withValues(alpha: 0.06)
                      : CustomColor.whiteColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
                ),
                child: Row(
                  mainAxisSize: mainMin,
                  mainAxisAlignment: mainSpaceBet,
                  crossAxisAlignment: crossCenter,
                  children: [
                    CircleAvatar(
                      radius: Dimensions.radius * 1.5,
                      backgroundImage: NetworkImage(
                        wallets[index].currency.currencyImage,
                      ),
                    ),
                    horizontalSpace(Dimensions.widthSize),
                    Column(
                      crossAxisAlignment: crossStart,
                      mainAxisAlignment: mainCenter,
                      children: [
                        TitleHeading4Widget(
                          text: wallets[index].currency.country,
                          fontSize: Dimensions.headingTextSize4,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        Row(
                          children: [
                            TitleHeading3Widget(
                              text: wallets[index].balance.toStringAsFixed(
                                precision,
                              ),
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            horizontalSpace(Dimensions.widthSize * 0.5),
                            TitleHeading3Widget(
                              text: wallets[index].currency.code,
                              color: CustomColor.primaryLightColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.5),
      ],
    );
  }

  Row _currencySwitchWidget(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            controller.switchCurrency.value = 0;
          },
          child: Chip(
            backgroundColor: controller.switchCurrency.value == 0
                ? Get.isDarkMode
                      ? CustomColor.primaryBGDarkColor
                      : CustomColor.whiteColor
                : Theme.of(context).scaffoldBackgroundColor,
            side: BorderSide(
              color: controller.switchCurrency.value == 0
                  ? Colors.transparent
                  : Colors.grey.withValues(alpha: 0.2),
            ),
            label: const TitleHeading4Widget(
              text: Strings.fiatCurrency,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius),
            ),
          ),
        ),
        horizontalSpace(Dimensions.widthSize),
        GestureDetector(
          onTap: () {
            controller.switchCurrency.value = 1;
          },
          child: Chip(
            backgroundColor: controller.switchCurrency.value == 1
                ? Get.isDarkMode
                      ? CustomColor.primaryBGDarkColor
                      : CustomColor.whiteColor
                : Theme.of(context).scaffoldBackgroundColor,
            side: BorderSide(
              color: controller.switchCurrency.value == 1
                  ? Colors.transparent
                  : Colors.grey.withValues(alpha: 0.2),
            ),
            label: const TitleHeading4Widget(
              text: Strings.cryptoCurrency,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius),
            ),
          ),
        ),
      ],
    );
  }
}
