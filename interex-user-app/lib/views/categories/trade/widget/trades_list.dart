import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:qrpaypro/backend/utils/custom_loading_api.dart';
import 'package:qrpaypro/custom_assets/assets.gen.dart';
import 'package:qrpaypro/language/language_controller.dart';
import 'package:qrpaypro/widgets/text_labels/title_heading5_widget.dart';

import '../../../../backend/utils/no_data_widget.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/animation/custom_listview_animation.dart';
import '../controller/trade_controller.dart';
import '../model/my_trade_model.dart';

class TradesList extends StatelessWidget {
  TradesList({super.key});

  final controller = Get.find<TradeController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          TitleHeading3Widget(text: Strings.trade),
          verticalSpace(Dimensions.paddingVerticalSize * .3),
          Expanded(
            child: AnimationLimiter(
              child: controller.myTradeModel.data.trade.isEmpty
                  ? NoDataWidget()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Trade data = controller.myTradeModel.data.trade[index];

                        return Obx(
                          () => CustomListViewAnimation(
                            index: index,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(
                                    Dimensions.paddingSize,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radius * 1.2,
                                    ),
                                    color: Get.isDarkMode
                                        ? CustomColor.whiteColor.withValues(
                                            alpha: .05,
                                          )
                                        : CustomColor.whiteColor,
                                  ),
                                  child:
                                      (controller.isCloseLoading &&
                                          (controller.selectedIndex.value ==
                                              index))
                                      ? CustomLoadingAPI()
                                      : _tileInfoWidget(data),
                                ),
                                (controller.isCloseLoading &&
                                        (controller.selectedIndex.value ==
                                            index))
                                    ? SizedBox.shrink()
                                    : _popUpMenuButton(context, data, index),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, i) =>
                          verticalSpace(Dimensions.paddingVerticalSize * .3),
                      itemCount: controller.myTradeModel.data.trade.length,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Column _tileInfoWidget(Trade data) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Get.isDarkMode
                  ? CustomColor.whiteColor.withValues(alpha: .4)
                  : CustomColor.primaryLightColor.withValues(alpha: .2),
              child: SvgPicture.asset(Assets.icon.trade),
            ),
            horizontalSpace(Dimensions.paddingHorizontalSize * .3),
            Expanded(
              child: Row(
                mainAxisAlignment: mainSpaceBet,
                children: [
                  Column(
                    crossAxisAlignment: crossStart,
                    children: [
                      TitleHeading5Widget(
                        text: Strings.trxId,
                        fontSize: Dimensions.headingTextSize6,
                        fontWeight: FontWeight.w600,
                      ),
                      verticalSpace(Dimensions.paddingVerticalSize * .1),
                      TitleHeading5Widget(text: data.trx),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingHorizontalSize * .3,
                    ),
                    child: Column(
                      crossAxisAlignment: crossEnd,
                      children: [
                        TitleHeading5Widget(
                          text: DateFormat(
                            'hh:mm a, dd MMMM, yyyy',
                          ).format(data.createdAt),
                          fontSize: Dimensions.headingTextSize6,
                        ),
                        verticalSpace(Dimensions.paddingVerticalSize * .1),
                        TitleHeading5Widget(
                          text: data.status,
                          color: (data.statusId == 1 || data.statusId == 6)
                              ? CustomColor.greenColor
                              : (data.statusId == 2 || data.statusId == 5)
                              ? Colors.orange
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  // horizontalSpace(Dimensions.paddingSize * .4)
                ],
              ),
            ),
            horizontalSpace(
              Dimensions.paddingHorizontalSize * (data.statusId == 1 ? .5 : 0),
            ),
          ],
        ),
        verticalSpace(Dimensions.paddingVerticalSize * .6),
        Row(
          mainAxisAlignment: mainSpaceBet,
          children: [
            Column(
              crossAxisAlignment: crossStart,
              children: [
                TitleHeading5Widget(
                  text: Strings.sellingAmount,
                  fontSize: Dimensions.headingTextSize6,
                  fontWeight: FontWeight.w600,
                ),
                TitleHeading4Widget(
                  text: "${data.requestAmount} ${data.saleCurrency}",
                ),
              ],
            ),
            horizontalSpace(Dimensions.paddingSize * .4),
            Column(
              crossAxisAlignment: crossEnd,
              children: [
                TitleHeading5Widget(
                  text: Strings.askingAmount,
                  fontSize: Dimensions.headingTextSize6,
                  fontWeight: FontWeight.w600,
                ),
                TitleHeading4Widget(
                  text: "${data.buyerWillPay} ${data.rateCurrency}",
                ),
              ],
            ),
          ],
        ),
        verticalSpace(Dimensions.paddingVerticalSize * .6),
        Column(
          crossAxisAlignment: crossStart,
          children: [
            TitleHeading5Widget(
              text: Strings.exchangeRate,
              fontWeight: FontWeight.w600,
            ),
            TitleHeading4Widget(
              text:
                  "1 ${data.saleCurrency} = ${(double.parse(data.buyerWillPay) / double.parse(data.buyerWillGet)).toStringAsFixed(4)} ${data.rateCurrency}",
              fontSize: Dimensions.headingTextSize3,
            ),
          ],
        ),
      ],
    );
  }

  Visibility _popUpMenuButton(BuildContext context, Trade data, int index) {
    return Visibility(
      visible: data.statusId == 1,
      child: Positioned(
        top: 30,
        right: 20,
        child: PopupMenuButton<String>(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Icon(Icons.more_vert_rounded),
          onSelected: (String value) {
            if (value == 'Close') {
              controller.selectedIndex.value = index;
              controller.tradeCloseApi(data.id);
            } else if (value == 'Edit') {
              controller.selectedIndex.value = index;
              controller.tradeEditApi(data.tradeId);
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'Close',
              child: Text(
                Get.find<LanguageController>().getTranslation(Strings.close),
              ),
            ),
            PopupMenuItem<String>(
              value: 'Edit',
              child: Text(
                Get.find<LanguageController>().getTranslation(Strings.edit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
