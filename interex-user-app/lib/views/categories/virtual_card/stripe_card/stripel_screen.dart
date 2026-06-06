import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qrpaypro/extentions/custom_extentions.dart';
import 'package:qrpaypro/widgets/others/custom_glass/custom_glass_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../backend/model/categories/virtual_card/stripe_models/stripe_card_info_model.dart';
import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../backend/utils/no_data_widget.dart';
import '../../../../controller/categories/virtual_card/stripe_card/stripe_card_controller.dart';
import '../../../../custom_assets/assets.gen.dart';
import '../../../../language/english.dart';
import '../../../../utils/custom_color.dart';
import '../../../../utils/custom_style.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/size.dart';
import '../../../../widgets/bottom_navbar/categorie_widget.dart';
import '../../../../widgets/bottom_navbar/transaction_history_widget.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/text_labels/custom_title_heading_widget.dart';
import '../../../../widgets/text_labels/title_heading3_widget.dart';
import 'stripe_card_details_screen.dart';
import 'stripe_create_card_screen.dart';
import 'stripe_transaction_screen.dart';

class StripeCardScreen extends StatelessWidget {
  const StripeCardScreen({super.key, required this.controller});

  final StripeCardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? const CustomLoadingAPI()
          : _bodyWidget(context),
    );
  }

  Stack _bodyWidget(BuildContext context) {
    final data = controller.stripeCardModel.data.myCard;
    return Stack(
      children: [
        Column(
          children: [
            data.isEmpty ? _emptyCardWidget(context) : _cardSlider(context),
            data.isEmpty
                ? _createCardWidget(context)
                : _cardCategoriesWidget(context),
            const SizedBox(),
          ],
        ),
        _draggableSheet(context),
      ],
    );
  }

  DraggableScrollableSheet _draggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (_, scrollController) {
        return _recentTransWidget(context, scrollController);
      },
      initialChildSize: 0.45,
      minChildSize: 0.45,
      maxChildSize: 0.68,
    );
  }

  Container cardFontWidget(
    BuildContext context,
    List<MyCard> data,
    int index,
    CardBasicInfo cardData,
  ) {
    bool isTablet() {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        bottom: Dimensions.marginSizeVertical * 0.5,
        left: Dimensions.paddingSize * 0.5,
        right: Dimensions.paddingSize * 2,
      ),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            controller.stripeCardModel.data.cardBasicInfo.cardBg,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 5,
            child: Image.network(
              controller.stripeCardModel.data.cardBasicInfo.siteLogo,
              height: Dimensions.heightSize * 4,
              width: Dimensions.widthSize * 5,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: crossStart,
            children: [
              verticalSpace(Dimensions.heightSize * 1.2),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSize),
                child: TitleHeading3Widget(
                  text: controller.stripeCardModel.data.cardBasicInfo.siteTitle,
                  color: CustomColor.whiteColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              verticalSpace(
                isTablet()
                    ? Dimensions.heightSize * 2
                    : Dimensions.heightSize * 5,
              ),
              Center(
                child: Text(
                  data[index].cardPan.formatCardNumber(),
                  style: CustomStyle.lightHeading4TextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: CustomColor.whiteColor.withValues(alpha: 0.6),
                    fontSize: 22.sp,
                  ),
                ),
              ),
              verticalSpace(Dimensions.heightSize * 1.5),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.3),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: mainCenter,
                      crossAxisAlignment: crossStart,
                      children: [
                        CustomTitleHeadingWidget(
                          text:
                              '${data[index].expiryYear}/${data[index].expiryYear} ',
                          style: CustomStyle.f20w600pri.copyWith(
                            color: CustomColor.whiteColor,
                          ),
                        ),
                        CustomTitleHeadingWidget(
                          text: Strings.expiryDate,
                          style: CustomStyle.f20w600pri.copyWith(
                            color: CustomColor.whiteColor.withValues(
                              alpha: 0.6,
                            ),
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.headingTextSize5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container cardBackWidget(
    BuildContext context,
    List<MyCard> data,
    int index,
    CardBasicInfo cardData,
  ) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(
        left: Dimensions.paddingSize * 0.5,
        bottom: Dimensions.marginSizeVertical * 0.5,
        right: Dimensions.paddingSize * 0.5,
      ),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            controller.stripeCardModel.data.cardBasicInfo.cardBg,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
      ),
      child: Column(
        crossAxisAlignment: crossEnd,
        mainAxisAlignment: mainEnd,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: crossStart,
            children: [
              verticalSpace(Dimensions.heightSize),
              horizontalSpace(Dimensions.widthSize),
              Column(
                mainAxisAlignment: mainCenter,
                children: [
                  CustomTitleHeadingWidget(
                    text: data[index].cvv,
                    style: CustomStyle.f20w600pri.copyWith(
                      color: CustomColor.whiteColor,
                    ),
                  ),
                  CustomTitleHeadingWidget(
                    text: Strings.cvc,
                    style: CustomStyle.f20w600pri.copyWith(
                      color: CustomColor.whiteColor.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.headingTextSize5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: Dimensions.heightSize * 6,
            child: Html(data: cardData.cardBackDetails),
          ),
        ],
      ),
    );
  }

  FlipCard _emptyCardWidget(BuildContext context) {
    return FlipCard(
      front: emptyCardFontWidget(context),
      back: emptyCardBackWidget(context),
    );
  }

  Container emptyCardFontWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        bottom: Dimensions.marginSizeVertical * 0.5,
        left: Dimensions.paddingSize * 0.5,
        right: Dimensions.paddingSize * 2,
      ),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            controller.stripeCardModel.data.cardBasicInfo.cardBg,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 12,
            child: Image.network(
              controller.stripeCardModel.data.cardBasicInfo.siteLogo,
              height: Dimensions.heightSize * 4,
              width: Dimensions.widthSize * 5,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: crossStart,
            children: [
              verticalSpace(Dimensions.heightSize * 1.5),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.2),
                child: TitleHeading3Widget(
                  text: controller.stripeCardModel.data.cardBasicInfo.siteTitle,
                  color: CustomColor.whiteColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              verticalSpace(Dimensions.heightSize * 5),
              Center(
                child: Text(
                  "0000000000000000".formatCardNumber(),
                  style: TextStyle(
                    fontFamily: "AgencyFB",
                    fontSize: Dimensions.headingTextSize3,
                    fontWeight: FontWeight.w700,
                    color: CustomColor.whiteColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
              verticalSpace(Dimensions.heightSize * 1.5),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.1),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: mainCenter,
                      crossAxisAlignment: crossStart,
                      children: [
                        CustomTitleHeadingWidget(
                          text: '00/00',
                          style: CustomStyle.f20w600pri.copyWith(
                            color: CustomColor.whiteColor,
                            fontSize: Dimensions.headingTextSize3,
                          ),
                        ),
                        CustomTitleHeadingWidget(
                          text: Strings.expiryDate,
                          style: CustomStyle.f20w600pri.copyWith(
                            color: CustomColor.whiteColor.withValues(
                              alpha: 0.6,
                            ),
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.headingTextSize5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container emptyCardBackWidget(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(
        bottom: Dimensions.marginSizeVertical * 1.5,
        left: Dimensions.paddingSize * 0.5,
        right: Dimensions.paddingSize * 0.5,
      ),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            controller.stripeCardModel.data.cardBasicInfo.cardBg,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossStart,
        children: [
          verticalSpace(Dimensions.heightSize),
          horizontalSpace(Dimensions.widthSize),
          Column(
            mainAxisAlignment: mainCenter,
            children: [
              CustomTitleHeadingWidget(
                text: "000",
                style: CustomStyle.f20w600pri.copyWith(
                  color: CustomColor.whiteColor,
                ),
              ),
              CustomTitleHeadingWidget(
                text: Strings.cvc,
                style: CustomStyle.f20w600pri.copyWith(
                  color: CustomColor.whiteColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.headingTextSize5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _cardCategoriesWidget(BuildContext context) {
    final data = controller.stripeCardModel.data.myCard;
    return Container(
      margin: EdgeInsets.only(
        bottom: Dimensions.marginSizeVertical,
        top: Dimensions.marginSizeVertical * 0.2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CategoriesWidget(
            icon: Assets.icon.details,
            text: Strings.details,
            onTap: () {
              // controller.getCardDetailsData(data.cardId);
              // controller.getCardDetailsData(
              //   data[controller.activeIndicatorIndex.value].cardId,
              // );
              Get.to(StripeCardDetailsScreen());
            },
          ),
          // CategoriesWidget(
          //     icon: Assets.icon.myGift,
          //     text: Strings.fund,
          //     onTap: () {
          //       if (controller.stripeCardModel.data.myCard.isNotEmpty) {
          //         Get.to(() => SudoAddFundScreen(
          //               appBarTitle: Strings.addFund,
          //             ));
          //       }
          //     }),
          Obx(
            () => controller.isMakeDefaultLoading
                ? const CustomLoadingAPI()
                : CategoriesWidget(
                    icon: Assets.icon.fund,
                    text: data[controller.activeIndicatorIndex.value].isDefault
                        ? Strings.removeDefault
                        : Strings.makeDefault,
                    onTap: () {
                      controller.makeCardDefaultProcess(
                        data[controller.activeIndicatorIndex.value].cardId,
                      );
                    },
                  ),
          ),
          CategoriesWidget(
            icon: Assets.icon.transaction,
            text: Strings.transaction,
            onTap: () {
              Get.to(StripeTransactionHistoryScreen());
              // controller.getCardTransactionData(
              //     controller.stripeCardModel.data.myCard.first.cardId);
            },
          ),
        ],
      ),
    );
  }

  Padding _recentTransWidget(
    BuildContext context,
    ScrollController scrollController,
  ) {
    final data = controller.stripeCardModel.data.transactions;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.8),
      child: data.isNotEmpty
          ? ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CustomTitleHeadingWidget(
                  text: Strings.recentTransactions,
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
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return TransactionWidget(
                        payableAmount: data[index].payable,
                        amount: data[index].requestAmount,
                        title: data[index].transactionType,
                        dateText: controller.getDay(
                          data[index].dateTime.toString(),
                        ),
                        transaction: data[index].trx,
                        monthText: controller.getMonth(
                          data[index].dateTime.toString(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ).customGlassWidget()
          : Container(),
    );
  }

  Container _createCardWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize * .5,
        vertical: Dimensions.paddingSize * .5,
      ),
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSize * .5),
      child: PrimaryButton(
        title: Strings.createCard.tr,
        onPressed: () {
          Get.to(StripeCreateCardScreen(controller: controller));
        },
        borderColor: CustomColor.primaryLightColor,
        buttonColor: CustomColor.primaryLightColor,
      ),
    );
  }

  Container _cardSlider(BuildContext context) {
    final data = controller.stripeCardModel.data.myCard;
    final cardData = controller.stripeCardModel.data.cardBasicInfo;
    return Container(
      height: MediaQuery.of(context).size.height * 0.34,
      padding: EdgeInsets.only(bottom: Dimensions.marginSizeVertical * 0.5),
      // color: CustomColor.screenBGColor,
      child: data.isNotEmpty
          ? Obx(
              () => Center(
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index, realIndex) {
                        return FlipCard(
                          front: cardFontWidget(context, data, index, cardData),
                          back: cardBackWidget(context, data, index, cardData),
                        );
                      },
                      options: CarouselOptions(
                        // enlargeCenterPage: true,
                        viewportFraction: 1,
                        height: MediaQuery.of(context).size.height * 0.29,
                        onPageChanged: (index, reason) {
                          return controller.changeIndicator(index);
                        },
                      ),
                    ),
                    SizedBox(height: Dimensions.heightSize),
                    _buildIndicator(context),
                  ],
                ),
              ),
            )
          : const NoDataWidget(),
    );
  }

  AnimatedSmoothIndicator _buildIndicator(BuildContext context) {
    final data = controller.stripeCardModel.data.myCard;
    return AnimatedSmoothIndicator(
      activeIndex: controller.activeIndicatorIndex.value,
      count: data.length,
      effect: SlideEffect(
        dotHeight: 8,
        dotWidth: 8,
        activeDotColor: CustomColor.primaryLightColor,
        dotColor: Colors.grey.withValues(alpha: 0.5),
      ),
    );
  }
}
