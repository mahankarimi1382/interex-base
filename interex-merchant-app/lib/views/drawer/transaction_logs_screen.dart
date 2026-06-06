import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/views/drawer/transactions/withdraw_log_screen.dart';

import '../../controller/drawer/transaction_controller.dart';
import '../../language/language_controller.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/strings.dart';
import '../../widgets/appbar/appbar_widget.dart';
import 'pay_link_log_screen.dart';
import 'transactions/add_sub_balance_log_screen.dart';
import 'transactions/make_payment_log_screen.dart';
import 'transactions/merchant_payment_log_screen.dart';

class TransactionLogScreen extends StatelessWidget {
  TransactionLogScreen({super.key});

  final controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(Dimensions.heightSize * 7),
            child: AppBarWidget(
              text: Strings.transactionLog.tr,
              bottomBar: PreferredSize(
                preferredSize: _tabBarWidget.preferredSize,
                child: ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: _tabBarWidget,
                ),
              ),
            ),
          ),
          body: Obx(
            () => controller.isLoading
                ? const CustomLoadingAPI()
                : _bodyWidget(context),
          ),
        ),
      ),
    );
  }

  // tab bar widget
  TabBar get _tabBarWidget => TabBar(
    automaticIndicatorColorAdjustment: false,
    dividerColor: CustomColor.transparent,
    isScrollable: true,
    labelColor: Colors.white,
    unselectedLabelColor: CustomColor.primaryLightTextColor,
    indicatorSize: TabBarIndicatorSize.tab,
    labelStyle: CustomStyle.lightHeading4TextStyle.copyWith(
      color: CustomColor.primaryLightColor,
      fontSize: Dimensions.headingTextSize4,
    ),
    unselectedLabelStyle: CustomStyle.lightHeading4TextStyle.copyWith(
      color: CustomColor.primaryLightTextColor,
      fontSize: Dimensions.headingTextSize4,
    ),
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(Dimensions.radius * 5),
      color: CustomColor.primaryLightColor,
    ),
    tabs: [
      Tab(
        child: Text(
          Get.find<LanguageController>().getTranslation(Strings.withdrawLog),
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        child: Text(
          Get.find<LanguageController>().getTranslation(
            Strings.merchantPaymentLog,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        child: Text(
          Get.find<LanguageController>().getTranslation(
            Strings.receivedPaymentLog,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        child: Text(
          Get.find<LanguageController>().getTranslation(
            Strings.addSubBalanceLog,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        child: Text(
          Get.find<LanguageController>().getTranslation(Strings.payLinkLogs),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );

  Container _bodyWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.5,
      ),
      child: TabBarView(
        physics: const BouncingScrollPhysics(),
        children: [
          WithdrawLogScreen(controller: controller),
          MerchantPaymentLogScreen(controller: controller),
          MakePaymentLogScreen(controller: controller),
          AddSubBalanceLogScreen(controller: controller),
          PayLinkLogScreen(controller: controller),
        ],
      ),
    );
  }
}
