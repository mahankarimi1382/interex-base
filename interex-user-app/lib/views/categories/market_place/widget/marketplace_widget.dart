

import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../custom_assets/assets.gen.dart';
import '../../../../language/language_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../others/custom_image_widget.dart';
import '../../make_an_offer/controller/make_an_offer_controller.dart';
import '../controller/marketplace_buying_preview_controller.dart';
import '../model/marketplace_info_model.dart';

class MarketplaceWidget extends StatelessWidget {
  MarketplaceWidget({
    super.key,
    required this.data,
    required this.index,
  });
  final Datum data;
  final int index;
  final buyAndOfferController = Get.put(MarketplaceBuyingPreviewController());

  @override
  Widget build(BuildContext context) {
    final userImageSet = "${data.baseUr}/${data.imagePath}/${data.user.image}";
    final defaultImagePath = "${data.baseUr}/${data.defaultImage}";

    final userImage = data.user.image != '' ? userImageSet : defaultImagePath;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              Dimensions.radius * 1.2),
          color: Get.isDarkMode
              ? CustomColor.whiteColor
              .withValues(alpha: .05)
              : CustomColor.whiteColor
      ),
      margin: EdgeInsets.only(
        bottom: Dimensions.marginBetweenInputTitleAndBox * 2,
        left: Dimensions.marginSizeHorizontal * 0.75,
        right: Dimensions.marginSizeHorizontal * 0.75,
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.paddingSize * 0.791,
              horizontal: Dimensions.paddingSize * 0.7,
            ),
            // decoration: ShapeDecoration(
              // color: Theme.of(context).colorScheme.surface,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(Dimensions.radius),
              // ),
            // ),
            child: Column(
              children: [
                verticalSpace(Dimensions.marginBetweenInputTitleAndBox * 2),
                verticalSpace(Dimensions.paddingVerticalSize * .3),

                FittedBox(
                  child: Row(
                    children: [
                      _amountWidget(
                          context, data.amount.toStringAsFixed(2), data.saleCurrency.code),
                      CustomImageWidget(
                        path: Assets.icon.replyTeal,
                        color: CustomColor.blackColor,
                      ).paddingSymmetric(
                        horizontal: Dimensions.marginSizeHorizontal * 0.2,
                      ),
                      _amountWidget(context, data.rate.toStringAsFixed(2), data.rateCurrency.code),
                    ],
                  ),
                ),
                Container(
                  height: 1.5,
                  margin: EdgeInsets.only(
                    top: Dimensions.marginSizeVertical * 0.7,
                    bottom: Dimensions.marginSizeVertical * 0.416,
                  ),
                  color: CustomColor.whiteColor.withValues(alpha: .5),
                ),
                verticalSpace(Dimensions.paddingVerticalSize * .3),
                _userProfileWidget(context, userImage)
              ],
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.marginSizeVertical * 0.28,
              ),
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: CustomColor.primaryLightColor.withValues(alpha: .6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius),
                    topRight: Radius.circular(Dimensions.radius),
                  ),
                ),
              ),
              child: TitleHeading3Widget(
                text: data.exchangeRate,
                color: CustomColor.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _amountWidget(BuildContext context, String amount, String currency) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: amount,
            style: Get.isDarkMode
                ? CustomStyle.darkHeading1TextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.headingTextSize1 * 0.9,
                  )
                : CustomStyle.lightHeading1TextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.headingTextSize1 * 0.9,
                  ),
          ),
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.widthSize * 0.5),
            ),
          ),
          TextSpan(
            text: currency,
            style: CustomStyle.lightHeading1TextStyle.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: Dimensions.headingTextSize1 * 0.9,
            ),
          ),
        ],
      ),
    );
  }

  Row _userProfileWidget(BuildContext context, String userImage) {
    bool isBigText = Get.find<LanguageController>()
            .getTranslation(Strings.makeAnOffer)
            .length >
        13;
    return Row(
      children: [
        Expanded(
          flex: 0,
          child: CircleAvatar(
            radius: Dimensions.radius * 1.5,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundImage: NetworkImage(
              userImage,
            ),
          ),
        ),
        horizontalSpace(Dimensions.widthSize * .2),
        Expanded(
          child: Column(
            crossAxisAlignment: crossStart,
            children: [
              TitleHeading4Widget(
                text: data.user.name,
                opacity: 0.60,
                fontWeight: FontWeight.w500,
                fontSize: Dimensions.headingTextSize4 * 0.9,
              ),
              TitleHeading4Widget(
                text: data.user.emailVerified == 1 && data.user.kycVerified == 1
                    ? Strings.verified
                    : Strings.unVerified,
                fontSize: Dimensions.headingTextSize6,
                color:
                    data.user.emailVerified == 1 && data.user.kycVerified == 1
                        ? Theme.of(context).primaryColor
                        : CustomColor.redColor,
              ),
            ],
          ),
        ),
        if (!isBigText) ...[
          _makeAnOfferButtonWidget(context),
          horizontalSpace(Dimensions.widthSize * 0.8),
          _buyNowButtonWidget(context),
        ] else ...[
          Column(
            crossAxisAlignment: crossEnd,
            children: [
              _makeAnOfferButtonWidget(context),
              verticalSpace(Dimensions.heightSize),
              _buyNowButtonWidget(context),
            ],
          ),
        ]
      ],
    );
  }

  InkWell _makeAnOfferButtonWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        _onMakeAnOfferProcessMethod();
      },
      child: Container(
        padding: EdgeInsets.all(Dimensions.paddingSize * 0.2),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius * 0.3),
          ),
        ),
        child: const TitleHeading4Widget(
          text: Strings.makeAnOffer,
          color: CustomColor.whiteColor,
        ),
      ),
    );
  }

  InkWell _buyNowButtonWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        _onBuyProcessMethod();
      },
      child: Obx(
        () => buyAndOfferController.loadingIndex.value == index &&
                buyAndOfferController.isBuyLoading
            ? const CustomLoadingAPI().marginSymmetric(
                horizontal: Dimensions.marginSizeHorizontal * 0.5,
              )
            : Container(
                padding: EdgeInsets.all(Dimensions.paddingSize * 0.2),
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 0.3),
                  ),
                ),
                child: const TitleHeading4Widget(
                  text: Strings.buyNow,
                  color: CustomColor.whiteColor,
                ),
              ),
      ),
    );
  }

  void _onMakeAnOfferProcessMethod() {
    final controller = Get.put(MakeAnOfferController());

    /// >>> get seller information
    controller.sellerName.value = data.user.name;
    controller.isVerified.value =
        (data.user.emailVerified == 1 && data.user.kycVerified == 1)
            ? true
            : false;

    /// >>> get rate amount and currency from marketplace list
    controller.rateCurrency.value = data.rateCurrency.code;
    controller.rateAmount.value = data.rate;
    controller.rateController.text = data.rate.toStringAsFixed(2);

    /// >>> get sell amount and currency from marketplace list
    controller.sellAmount.value = data.amount;
    controller.sellCurrency.value = data.saleCurrency.code;
    controller.amountController.text = data.amount.toStringAsFixed(2);

    /// >>> get tarde id for send an offer [-- Required --]
    controller.tradeId.value = data.id.toString();

    Get.toNamed(Routes.makeAnOfferBuyingPreviewScreen);
  }

  void _onBuyProcessMethod() {
    // todo
    // LocalStorages.saveBuyAndOfferId(id: data.id.toString());
    buyAndOfferController.loadingIndex.value = index;
    buyAndOfferController.sellerName.value = data.user.name;
    buyAndOfferController.isVerified.value =
        data.user.emailVerified == 1 && data.user.kycVerified == 1
            ? true
            : false;
    debugPrint(buyAndOfferController.loadingIndex.value.toString());
    buyAndOfferController.marketplaceBuyProcessApi(data.id);
  }
}
