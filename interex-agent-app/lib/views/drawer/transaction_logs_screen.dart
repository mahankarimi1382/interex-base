import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/views/drawer/transactions/exchange_money_log_screen.dart';
import '../../backend/utils/custom_loading_api.dart';
import '../../controller/drawer/transaction_controller.dart';
import '../../language/english.dart';
import '../../language/language_controller.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/responsive_layout.dart';
import '../../widgets/appbar/transaction_appbar.dart';
import 'transactions/add_money_log_screen.dart';
import 'transactions/add_sub_balance_log_screen.dart';
import 'transactions/bill_pay_log_screen.dart';
import 'transactions/mobile_top_up_log_screen.dart';
import 'transactions/money_in_log_screen.dart';
import 'transactions/profit_logs_screen.dart';
import 'transactions/remittance_log_screen.dart';
import 'transactions/send_money_log_screen.dart';
import 'transactions/withdraw_log_screen.dart';

class TransactionLogScreen extends StatelessWidget {
  TransactionLogScreen({super.key});

  final controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: DefaultTabController(
        length: 10,
        child: Scaffold(
          appBar: TransactionAppBarWidget(
            text: Strings.transactionLog,
            bottomBar: PreferredSize(
              preferredSize: _tabBarWidget.preferredSize,
              child: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: _tabBarWidget,
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
    dividerColor: Colors.transparent,
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
      borderRadius: BorderRadius.circular(50),
      color: CustomColor.primaryLightColor,
    ),
    tabs: [
      Tab(child: _textWidget(Strings.addMoneyLog, textAlign: TextAlign.center)),
      Tab(child: _textWidget(Strings.moneyIn, textAlign: TextAlign.center)),
      Tab(child: _textWidget(Strings.profitLog, textAlign: TextAlign.center)),
      Tab(child: _textWidget(Strings.withdrawLog, textAlign: TextAlign.center)),
      Tab(
        child: _textWidget(Strings.sendMoneyLog, textAlign: TextAlign.center),
      ),
      // add new tab
      Tab(
        child: _textWidget('Exchange Money Log', textAlign: TextAlign.center),
      ),
      Tab(child: _textWidget(Strings.billPayLog, textAlign: TextAlign.center)),
      Tab(
        child: _textWidget(Strings.mobileTopUpLog, textAlign: TextAlign.center),
      ),
      Tab(
        child: _textWidget(Strings.remittanceLog, textAlign: TextAlign.center),
      ),
      Tab(
        child: _textWidget(
          Strings.addSubBalanceLog,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );

  Obx _textWidget(String text, {required TextAlign textAlign}) {
    final languageController = Get.put(LanguageController());
    return Obx(() => Text(languageController.getTranslation(text)));
  }

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
          AddMoneyLogScreen(controller: controller),
          MoneyInLogScreen(controller: controller),
          ProfitLogScreen(controller: controller),
          WithdrawLogScreen(controller: controller),
          SendMoneyLogScreen(controller: controller),
          ExchangeMoneyLogScreen(controller: controller),
          BillPayLogScreen(controller: controller),
          MobileTopUpLogScreen(controller: controller),
          RemittanceLogScreen(controller: controller),
          AddSubBalanceLogScreen(controller: controller),
        ],
      ),
    );
  }
}
