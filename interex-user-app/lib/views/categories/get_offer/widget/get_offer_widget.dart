import 'package:intl/intl.dart';
import 'package:qrpaypro/backend/local_storage/local_storage.dart';

import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../controller/app_settings/app_settings_controller.dart';
import '../../../../custom_assets/assets.gen.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/text_labels/title_heading5_widget.dart';
import '../../../others/custom_image_widget.dart';
import '../../make_counter_offer/controller/make_counter_offer_controller.dart';
import '../controller/get_offer_controller.dart';
import '../controller/offer_buy_preview_controller.dart';
import '../model/get_offer_model.dart';

class GetOfferWidget extends StatefulWidget {
  const GetOfferWidget({
    super.key,
    required this.index,
    required this.getOffer,
    required this.imagePath,
    required this.defaultImage,
    required this.controller,
    this.isWhiteColor = true,
  });

  final int index;
  final bool isWhiteColor;
  final GetOffer getOffer;
  final String imagePath;
  final String defaultImage;
  final GetOfferController controller;

  @override
  State<GetOfferWidget> createState() => _GetOfferWidgetState();
}

class _GetOfferWidgetState extends State<GetOfferWidget> {
  final counterOfferController = Get.put(MakeCounterOfferController());

  final offerBuyController = Get.put(OfferBuyPreviewController());

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final creatorImageSet =
        "${Get.find<AppSettingsController>().baseUrl.value}/${widget.imagePath}/${widget.getOffer.creatorimage}";
    final defaultImagePath =
        "${Get.find<AppSettingsController>().baseUrl.value}/${widget.defaultImage}";

    final creatorImage = widget.getOffer.creatorimage != ''
        ? creatorImageSet
        : defaultImagePath;

    final DateTime offerCreated = widget.getOffer.offercreated!;

    return InkWell(
      onTap: () {
        _onCounterOfferProcessMethod();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.heightSize * 0.6),
        padding: EdgeInsets.all(Dimensions.paddingSize * 0.35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
          color: Get.isDarkMode
              ? CustomColor.whiteColor.withValues(alpha: .05)
              : CustomColor.whiteColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    width: Dimensions.widthSize * 5.5,
                    padding: EdgeInsets.all(Dimensions.paddingSize),
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(creatorImage),
                        fit: BoxFit.fill,
                      ),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius * 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
                horizontalSpace(Dimensions.widthSize * 0.6),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: crossStart,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TitleHeading3Widget(
                              text: widget.getOffer.creatorname!,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                          horizontalSpace(Dimensions.widthSize * 0.5),
                        ],
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            TitleHeading5Widget(
                              text:
                                  "${widget.getOffer.tradeamount} ${widget.getOffer.salecurrencycode}",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomImageWidget(path: Assets.icon.replyTeal),
                            TitleHeading5Widget(
                              text:
                                  "${widget.getOffer.traderate} ${widget.getOffer.ratecurrencycode}",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            TitleHeading4Widget(
                              text:
                                  "${widget.getOffer.amount} ${widget.getOffer.salecurrencycode}",
                              opacity: 0.60,
                              fontWeight: FontWeight.w500,
                              fontSize: Dimensions.headingTextSize6,
                            ),
                            CustomImageWidget(
                              path: Assets.icon.replyTeal,
                              color: CustomColor.primaryLightTextColor
                                  .withValues(alpha: 0.25),
                            ),
                            TitleHeading4Widget(
                              text:
                                  "${widget.getOffer.rate} ${widget.getOffer.ratecurrencycode}",
                              opacity: 0.60,
                              fontWeight: FontWeight.w500,
                              fontSize: Dimensions.headingTextSize6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalSpace(Dimensions.widthSize),
                Expanded(
                  flex: 0,
                  child: Column(
                    crossAxisAlignment: crossEnd,
                    children: [
                      TitleHeading4Widget(
                        text: dateFormat.format(offerCreated),
                        opacity: 0.30,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.headingTextSize6,
                      ),
                      verticalSpace(Dimensions.marginBetweenInputTitleAndBox),

                      if (widget.getOffer.tradestatus == 1) ...[
                        if (widget.getOffer.receiverid.toString() ==
                                LocalStorages.getId() ||
                            widget.getOffer.receiverid.toString() !=
                                LocalStorages.getId()) ...[
                          if (widget.getOffer.status == 4) ...[
                            _customButtonWidget(
                              title: Strings.rejected,
                              onTap: () {},
                            ),
                          ] else if (widget.getOffer.status == 1) ...[
                            if (widget.getOffer.tradeuserid.toString() ==
                                LocalStorages.getId()) ...[
                              _customButtonWidget(
                                title: Strings.accepted,
                                onTap: () {},
                              ),
                            ] else ...[
                              _customButtonWidget(
                                title: Strings.pay,
                                onTap: () {
                                  /// >>> get seller information
                                  offerBuyController.sellerName.value =
                                      widget.getOffer.creatorname!;
                                  offerBuyController.isVerified.value =
                                      (widget.getOffer.emailverified == 1 &&
                                          widget.getOffer.kycverified == 1)
                                      ? true
                                      : false;
                                  offerBuyController.offerBuyProcessApi(
                                    widget.getOffer.id.toString(),
                                  );
                                },
                              ),
                            ],
                          ],
                        ],
                      ],

                      /// get sold button &  accept , reject ,counter offer
                      if (widget.getOffer.tradestatus == 1) ...[
                        if (widget.getOffer.receiverid.toString() ==
                                LocalStorages.getId() &&
                            widget.getOffer.status != 4 &&
                            widget.getOffer.status != 1) ...[
                          Obx(
                            () =>
                                counterOfferController.loadingIndex.value ==
                                        widget.index &&
                                    counterOfferController.isStatusLoading
                                ? const CustomLoadingAPI().marginSymmetric(
                                    horizontal:
                                        Dimensions.marginSizeHorizontal * 0.5,
                                  )
                                : _customButtonWidget(
                                    title: Strings.accept,
                                    onTap: () {
                                      _onAcceptProcess();
                                    },
                                  ),
                          ),
                        ],
                      ] else ...[
                        _customButtonWidget(title: Strings.sold, onTap: () {}),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // statusInfo() {
  InkWell _customButtonWidget({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.widthSize * 1.2,
          vertical: Dimensions.heightSize * 0.4,
        ),
        alignment: Alignment.center,
        height: Dimensions.heightSize * 2.5,
        decoration: ShapeDecoration(
          color:
              title == Strings.reject ||
                  title == Strings.sold ||
                  title == Strings.rejected
              ? CustomColor.redColor
              : title == Strings.counterOffer
              ? Colors.orange
              : Theme.of(Get.context!).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius * 0.4),
          ),
        ),
        child: TitleHeading4Widget(
          text: title,
          fontWeight: FontWeight.w600,
          color: CustomColor.whiteColor,
        ),
      ),
    );
  }

  void _onCounterOfferProcessMethod() {
    /// >>> get is counter offer
    if (widget.getOffer.tradestatus == 1) {
      if (widget.getOffer.receiverid.toString() == LocalStorages.getId() &&
          widget.getOffer.status != 4 &&
          widget.getOffer.status != 1) {
        counterOfferController.isCounterOffer.value = true;
      } else {
        counterOfferController.isCounterOffer.value = false;
      }
    } else {
      counterOfferController.isCounterOffer.value = false;
    }

    /// >>> get seller information
    counterOfferController.sellerName.value = widget.getOffer.creatorname!;
    counterOfferController.isVerified.value =
        (widget.getOffer.emailverified == 1 && widget.getOffer.kycverified == 1)
        ? true
        : false;

    /// >>> get rate amount and currency from get offer list
    counterOfferController.rateCurrency.value =
        widget.getOffer.ratecurrencycode!;
    counterOfferController.rateAmount.value = double.parse(
      widget.getOffer.traderate!,
    );
    counterOfferController.rateController.text = widget.getOffer.traderate!;

    /// >>> get sell amount and currency from get offer list
    counterOfferController.sellAmount.value = double.parse(
      widget.getOffer.tradeamount!,
    );
    counterOfferController.sellCurrency.value =
        widget.getOffer.salecurrencycode!;
    counterOfferController.amountController.text = widget.getOffer.tradeamount!;

    /// >>> get counter offer sell and rate from get offer list
    counterOfferController.counterSellAmount.value = double.parse(
      widget.getOffer.amount!,
    );
    counterOfferController.counterRateAmount.value = double.parse(
      widget.getOffer.rate!,
    );

    /// >>> get tarde id for counter offer [-- Required --]
    counterOfferController.tradeId.value = widget.getOffer.tradeid.toString();
    counterOfferController.targetId.value = widget.getOffer.id.toString();

    /// >>> get tarde id for receiver id offer [-- Required --]
    counterOfferController.receiverId.value = widget.getOffer.receiverid
        .toString();

    /// >>> get creator id for counter offer [-- Required --]
    counterOfferController.creatorId.value = widget.getOffer.creatorid
        .toString();
    debugPrint(counterOfferController.isCounterOffer.value.toString());

    Get.toNamed(Routes.makeCounterOfferScreen);
  }

  void _onAcceptProcess() {
    /// >>> get target id for accept others offer [-- Required --]
    counterOfferController.targetId.value = widget.getOffer.id.toString();
    counterOfferController.loadingIndex.value = widget.index;

    /// >>> accept process
    counterOfferController.offerStatusProcessApi('Accept');
  }
}
