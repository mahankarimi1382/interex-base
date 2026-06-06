import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/controller/navbar/dashboard_controller.dart';
import 'package:qrpay/custom_assets/assets.gen.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/others/glass_widget.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';
import '../../backend/utils/no_data_widget.dart';
import '../../widgets/bottom_navbar/transaction_history_widget.dart';
import '../../widgets/text_labels/title_heading3_widget.dart';
import '../../widgets/text_labels/title_heading4_widget.dart';
import '../../widgets/text_labels/title_heading5_widget.dart';
import '../others/custom_image_widget.dart';
import '../set_up_pin/controller/set_up_pin_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controller = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        body: Obx(
          () => controller.isLoading || controller.walletsController.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  RefreshIndicator _bodyWidget(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.black,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      strokeWidth: 2.5,
      onRefresh: () async {
        controller.getDashboardData();
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: Stack(
        children: [
          ListView(
            children: [
              _walletsWidget(context),
              verticalSpace(Dimensions.heightSize * 0.8),
              _topButtonWidget(context),
            ],
          ),
          _draggableSheet(context)
        ],
      ),
    );
  }

  DraggableScrollableSheet _draggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (_, scrollController) {
        return _transactionWidget(context, scrollController);
      },
      initialChildSize: 0.60,
      minChildSize: 0.60,
      maxChildSize: 1,
    );
  }

  Padding _topButtonWidget(BuildContext context) {
    return Padding(
      padding: controller.withdrawMoney.value && controller.receiveMoney.value
          ? EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.5)
          : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (controller.withdrawMoney.value) ...[
            _topicWidget(
              icon: Assets.icon.withdraw,
              title: Strings.withdraw,
              onTap: () {
                // Get.find<SetUpPinController>().showPinDialog(context, onSuccess: (){});

                Get.find<SetUpPinController>().pinVerificationCheck(
                    onChecked: (){
                      Get.toNamed(Routes.withdrawScreen);
                    });
              },
            ),
          ],
          if (controller.receiveMoney.value) ...[
            _topicWidget(
              icon: Assets.icon.receive,
              title: Strings.received,
              onTap: () {
                // Get.find<SetUpPinController>().showPinDialog(context, onSuccess: (){});

                // Get.find<SetUpPinController>().pinVerificationCheck(
                //     onChecked: (){
                      Get.toNamed(Routes.moneyReceiveScreen);
                    // });
              },
            ),
          ],
          if (controller.payLink.value) ...[
            _topicWidget(
              icon: Assets.icon.paylink,
              title: Strings.payLink,
              onTap: () {
               // Get.find<SetUpPinController>().showPinDialog(context, onSuccess: (){});

                Get.find<SetUpPinController>().pinVerificationCheck(
                    onChecked: (){
                      Get.toNamed(Routes.paymentLogScreen);
                    });
                // Get.toNamed(Routes.paymentLogScreen);
              },
            ),
          ],
          // if (controller.receiveMoney.value) ...[
          _topicWidget(
            icon: Assets.icon.exchangeAlt,
            title: Strings.exchange,
            onTap: () {

              // Get.find<SetUpPinController>().showPinDialog(context, onSuccess: (){});

              Get.find<SetUpPinController>().pinVerificationCheck(
              onChecked: (){
              Get.toNamed(Routes.exchangeMoneyScreen);
              });

              // Get.toNamed(Routes.exchangeMoneyScreen);
            },
          ),
          // ],
        ],
      ),
    );
  }

  StatelessWidget _transactionWidget(BuildContext context, ScrollController scrollController) {
    var data = controller.dashBoardModel.data.transactions;
    return data.isEmpty
        ? NoDataWidget(
            title: Strings.noTransaction.tr,
          )
        : ListView(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSize * 0.8,
            ),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CustomTitleHeadingWidget(
                text: Strings.recentTransactions.tr,
                padding: EdgeInsets.only(top: Dimensions.paddingSize),
                style: Get.isDarkMode
                    ? CustomStyle.darkHeading3TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize2,
                        fontWeight: FontWeight.w600,
                      )
                    : CustomStyle.lightHeading3TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize2,
                        fontWeight: FontWeight.w600,
                      ),
              ),
              verticalSpace(Dimensions.widthSize),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length < 6 ? data.length : 6,
                    itemBuilder: (context, index) {
                      return TransactionWidget(
                        amount: data[index].requestAmount,
                        title: data[index].transactionType,
                        payableAmount: data[index].payable,
                        dateText: DateFormat.d().format(data[index].dateTime),
                        transaction: data[index].trx,
                        monthText:
                            DateFormat.MMM().format(data[index].dateTime),
                        status: data[index].status,
                      );
                    }),
              ).customGlassWidget()
            ],
          );
  }

  Column _walletsWidget(BuildContext context) {
    var wallets = controller.walletsController.walletsInfoModel.data.userWallets
        .where(
          (e) =>
              e.currency.type ==
              (controller.switchCurrency.value == 0 ? 'FIAT' : 'CRYPTO'),
        )
        .toList();
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeHorizontal * 0.9,
          ),
          child: Column(
            children: [
              _currencySwitchWidget(context),
            ],
          ),
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
                      ? CustomColor.primaryBGDarkColor
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
                          color: Get.isDarkMode
                              ? CustomColor.whiteColor
                              : CustomColor.blackColor,
                        ),
                        Row(
                          children: [
                            TitleHeading3Widget(
                              text: controller.switchCurrency.value == 0
                                  ? wallets[index].balance.toStringAsFixed(2)
                                  : wallets[index].balance.toStringAsFixed(8),
                              color: Get.isDarkMode
                                  ? CustomColor.whiteColor
                                  : CustomColor.blackColor,
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
                    : Colors.grey.withValues(alpha:0.2)),
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
                    : Colors.grey.withValues(alpha:0.2)),
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

  InkWell _topicWidget(
      {required VoidCallback onTap,
      required String title,
      required String icon}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
              color: Get.isDarkMode
                  ? CustomColor.primaryBGDarkColor
                  : CustomColor.whiteColor,
            ),
            padding: EdgeInsets.all(Dimensions.paddingSize * 0.8),
            child: CustomImageWidget(
              path: icon,
              height: Dimensions.iconSizeDefault * 1.5,
              color: Get.isDarkMode
                  ? Colors.white
                  : CustomColor.blackColor.withValues(alpha:0.7),
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.4),
          TitleHeading5Widget(
            text: title,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    );
  }
}
