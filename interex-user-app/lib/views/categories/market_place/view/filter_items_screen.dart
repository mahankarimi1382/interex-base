
import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../make_an_offer/controller/make_an_offer_controller.dart';
import '../controller/marketplace_buying_preview_controller.dart';
import '../controller/marketplace_controller.dart';

class FilterItemsScreen extends StatelessWidget {
  FilterItemsScreen({
    super.key,
  });

  final MarketplaceController controller = Get.put(MarketplaceController());
  final buyAndOfferController = Get.put(MarketplaceBuyingPreviewController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Future<bool> willPop() {
      Get.offNamedUntil(Routes.bottomNavBarScreen, (route) => false);
      return Future.value(true);
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Column _bodyWidget(BuildContext context) {
    return Column(
      children: [
        _appBarWidget(context),
        _itemWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  Widget _appBarWidget(BuildContext context) {
    var data = controller.marketplaceInfoModel.data.trads.data.first;
    final userImageSet = "${data.baseUr}/${data.imagePath}/${data.user.image}";
    final defaultImagePath = "${data.baseUr}/${data.defaultImage}";
    final userImage = data.user.image != '' ? userImageSet : defaultImagePath;
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
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
              horizontalSpace(Dimensions.widthSize * 0.8),
              Expanded(
                child: Column(
                  crossAxisAlignment: crossStart,
                  children: [
                    TitleHeading4Widget(
                      text: data.user.name,
                      opacity: 0.60,
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.headingTextSize4 * 1.3,
                    ),
                    TitleHeading4Widget(
                      text: data.user.emailVerified == 1 &&
                              data.user.kycVerified == 1
                          ? Strings.verified
                          : Strings.unVerified,
                      fontSize: Dimensions.headingTextSize6,
                      color: data.user.emailVerified == 1 &&
                              data.user.kycVerified == 1
                          ? Theme.of(context).primaryColor
                          : CustomColor.redColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: GestureDetector(
                  onTap: () {
                    Get.offAllNamed(Routes.bottomNavBarScreen);
                  },
                  child: CircleAvatar(
                    radius: Dimensions.radius,
                    backgroundColor: CustomColor.redColor,
                    child: Icon(
                      Icons.close,
                      color: CustomColor.whiteColor,
                      size: Dimensions.iconSizeDefault * 0.8,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ).paddingSymmetric(vertical: Dimensions.paddingSize * 0.5);
  }

  Widget _buttonWidget(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => buyAndOfferController.isBuyLoading
              ? const CustomLoadingAPI()
              : PrimaryButton(
                  title: Strings.buyNow,
                  onPressed: () {
                    _onBuyProcessMethod();
                  },
                ),
        ),
        verticalSpace(Dimensions.heightSize * 1.4),
        PrimaryButton(
          title: Strings.makeAnOffer,
          onPressed: () {
            _onMakeAnOfferProcessMethod();
          },
          borderColor: Colors.orange,
          buttonColor: Colors.orange,
        ),
      ],
    )
        .paddingSymmetric(horizontal: Dimensions.paddingSize * 0.6)
        .paddingOnly(top: Dimensions.paddingSize * 1.5);
  }

  Container _itemWidget(BuildContext context) {
    var data = controller.marketplaceInfoModel.data.trads.data.first;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.6),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Dimensions.radius),
            bottomRight: Radius.circular(Dimensions.radius),
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.marginSizeVertical * 0.3,
            ),
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: Theme.of(context).primaryColor,
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
          verticalSpace(Dimensions.heightSize * 1.3),
          _amountWidget(context, data.amount.toStringAsFixed(2), data.saleCurrency.code),
          Icon(Icons.sort).paddingSymmetric(
            horizontal: Dimensions.marginSizeHorizontal * 0.2,
          ),
          verticalSpace(Dimensions.heightSize * 1.3),
          _amountWidget(context, data.rate.toStringAsFixed(2), data.rateCurrency.code),
          verticalSpace(Dimensions.heightSize * 1.3),
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
                    fontSize: Dimensions.headingTextSize1 * 1.3,
                  )
                : CustomStyle.lightHeading1TextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.headingTextSize1 * 1.3,
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
              fontSize: Dimensions.headingTextSize1 * 1.3,
            ),
          ),
        ],
      ),
    );
  }

  void _onBuyProcessMethod() {
    var data = controller.marketplaceInfoModel.data.trads.data.first;
    // LocalStorages.saveBuyAndOfferId(id: data.id.toString());
    buyAndOfferController.sellerName.value = data.user.name;
    buyAndOfferController.isVerified.value =
        data.user.emailVerified == 1 && data.user.kycVerified == 1
            ? true
            : false;
    debugPrint(buyAndOfferController.loadingIndex.value.toString());
    buyAndOfferController.marketplaceBuyProcessApi(data.id);
  }

  void _onMakeAnOfferProcessMethod() {
    var data = controller.marketplaceInfoModel.data.trads.data.first;

    final makeAnOffer = Get.put(MakeAnOfferController());

    /// >>> get seller information
    makeAnOffer.sellerName.value = data.user.name;
    makeAnOffer.isVerified.value =
        (data.user.emailVerified == 1 && data.user.kycVerified == 1)
            ? true
            : false;

    /// >>> get rate amount and currency from marketplace list
    makeAnOffer.rateCurrency.value = data.rateCurrency.code;
    makeAnOffer.rateAmount.value = data.rate;
    makeAnOffer.rateController.text = data.rate.toStringAsFixed(2); 

    /// >>> get sell amount and currency from marketplace list
    makeAnOffer.sellAmount.value = data.amount;
    makeAnOffer.sellCurrency.value = data.saleCurrency.code;
    makeAnOffer.amountController.text = data.amount.toStringAsFixed(2);

    /// >>> get tarde id for send an offer [-- Required --]
    makeAnOffer.tradeId.value = data.id.toString();

    Get.toNamed(Routes.makeAnOfferBuyingPreviewScreen);
  }
}
