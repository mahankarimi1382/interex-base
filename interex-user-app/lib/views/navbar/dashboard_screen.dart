import 'package:intl/intl.dart';
import 'package:qrpaypro/backend/utils/custom_loading_api.dart';
import 'package:qrpaypro/controller/navbar/dashboard_controller.dart';
import 'package:qrpaypro/custom_assets/assets.gen.dart';
import 'package:qrpaypro/utils/basic_screen_imports.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/bottom_navbar/categorie_widget.dart';

import '../../backend/model/bottom_navbar_model/dashboard_model.dart';
import '../../backend/utils/no_data_widget.dart';
import '../../controller/wallets/wallets_controller.dart';
import '../../widgets/bottom_navbar/recent_transaction_card.dart';
import '../set_up_pin/controller/set_up_pin_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controller = Get.find<DashBoardController>();
  final walletController = Get.find<WalletsController>();
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        body: Obx(
          () => walletController.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  StreamBuilder<DashboardModel> _bodyWidget(BuildContext context) {
    return StreamBuilder<DashboardModel>(
      stream: controller.getDashboardDataStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text(Strings.somethingWentWrong));
        }
        if (snapshot.hasData) {
          return Obx(
            () => Stack(
              children: [
                ListView(
                  children: [
                    verticalSpace(Dimensions.heightSize * .4),
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
        return const Align(
          alignment: Alignment.center,
          child: CustomLoadingAPI(),
        );
      },
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
      initialChildSize: isTablet() ? 0.42 : 0.46,
      minChildSize: isTablet() ? 0.42 : 0.46,
      maxChildSize: 1,
    );
  }

  Container _categoriesWidget(BuildContext context) {
    for (var v in controller.categoriesData) {
      print(v.text);
    }
    print(controller.categoriesData.length);
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.5),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? CustomColor.whiteColor.withValues(alpha: 0.06)
            : CustomColor.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
      ),
      margin: EdgeInsets.only(
        right: Dimensions.marginSizeVertical * 0.7,
        left: Dimensions.marginSizeVertical * 0.7,
      ),
      child: GridView.count(
        padding: const EdgeInsets.only(),
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisCount: 4,
        crossAxisSpacing: 4.0,
        shrinkWrap: true,
        childAspectRatio: 0.82,
        children: List.generate(
          controller.categoriesData.length > 8
              ? 8
              : controller.categoriesData.length,
          (index) {
            if (controller.categoriesData.length > 8 && index == 7) {
              return CategoriesWidget(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: Dimensions.marginSizeHorizontal,
                          right: Dimensions.marginSizeVertical,
                        ),
                        child: Column(
                          mainAxisSize: mainMin,
                          children: [
                            Container(
                              width: Dimensions.widthSize * 4.5,
                              height: Dimensions.heightSize * 0.55,
                              margin: EdgeInsets.only(
                                top: Dimensions.heightSize,
                                bottom: Dimensions.heightSize * 1.5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius,
                                ),
                                color: Colors.grey.shade400,
                              ),
                            ),
                            GridView.count(
                              padding: const EdgeInsets.only(),
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              crossAxisCount: 4,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.8,
                              shrinkWrap: true,
                              children: List.generate(
                                controller.categoriesData.length - 7,
                                (index) {
                                  final adjustedIndex = index + 7;
                                  return CategoriesWidget(
                                    onTap: () {
                                      // Get.find<SetUpPinController>().showPinDialog(context, onSuccess: (){});
                                      Get.close(1);
                                      Get.find<SetUpPinController>()
                                          .pinVerificationCheck(
                                            onChecked: controller
                                                .categoriesData[adjustedIndex]
                                                .onTap,
                                          );
                                    },
                                    icon: controller
                                        .categoriesData[adjustedIndex]
                                        .icon,
                                    text: controller
                                        .categoriesData[adjustedIndex]
                                        .text,
                                  );
                                },
                              ),
                            ),
                            verticalSpace(Dimensions.heightSize * 0.5),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Assets.icon.more,
                text: Strings.more,
              );
            }
            return CategoriesWidget(
              onTap: () {
                // Get.find<SetUpPinController>().showPinDialog(context, onSuccess: (){});

                Get.find<SetUpPinController>().pinVerificationCheck(
                  onChecked: controller.categoriesData[index].onTap,
                );
              },
              icon: controller.categoriesData[index].icon,
              text: controller.categoriesData[index].text,
            );
          },
        ),
      ),
    );
  }

  Widget _transactionWidget(
    BuildContext context,
    ScrollController scrollController,
  ) {
    final data = controller.dashBoardModel.data.transactions;
    final isDark = Get.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F1330)
            : const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          _sheetHandle(isDark),
          _sheetHeader(isDark, data.length),
          Expanded(
            child: data.isEmpty
                ? NoDataWidget(title: Strings.noTransaction.tr)
                : ListView.builder(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final tx = data[index];
                      return RecentTransactionCard(
                        type: tx?.transactionType ?? '',
                        status: tx?.status ?? '',
                        amount: tx?.requestAmount ?? '',
                        payableAmount: tx?.payable ?? '',
                        trx: tx?.trx ?? '',
                        dateText: tx?.dateTime != null
                            ? DateFormat.d().format(tx!.dateTime!)
                            : '',
                        monthText: tx?.dateTime != null
                            ? DateFormat.MMM().format(tx!.dateTime!)
                            : '',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _sheetHandle(bool isDark) {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 4.h),
      width: 44.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.18)
            : Colors.black.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  Widget _sheetHeader(bool isDark, int count) {
    final titleColor = isDark ? Colors.white : const Color(0xFF1B2138);
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 16.w, 12.h),
      child: Row(
        mainAxisAlignment: mainSpaceBet,
        crossAxisAlignment: crossCenter,
        children: [
          Row(
            children: [
              Text(
                Strings.recentTransactions.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              if (count > 0) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: CustomColor.primaryLightColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: CustomColor.primaryLightColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Column _walletsWidget(BuildContext context) {
    var wallets = controller.walletController.walletsInfoModel.data.userWallets
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
                          text: wallets[index].currency.name,
                          fontSize: Dimensions.headingTextSize4,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        Row(
                          children: [
                            TitleHeading3Widget(
                              text: wallets[index].balance.toStringAsFixed(
                                wallets[index].currency.type == 'FIAT' ? 2 : 8,
                              ),
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            horizontalSpace(Dimensions.widthSize * 0.5),
                            TitleHeading3Widget(
                              text: wallets[index].currency.code,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              opacity: 0.6,
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
