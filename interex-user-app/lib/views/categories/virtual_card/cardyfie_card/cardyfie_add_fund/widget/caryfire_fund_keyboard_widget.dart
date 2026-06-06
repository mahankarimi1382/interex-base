part of '../cardyfie_add_fund_screen.dart';

class CardyfieAddFundWidget extends StatelessWidget {
  CardyfieAddFundWidget({super.key, required this.buttonText});
  final String buttonText;
  final controller = Get.put(CardyfieAddFundController());
  final walletController = Get.put(VirtualCardyfieCardController());

  @override
  Widget build(BuildContext context) {
    return _bodyWidget(context);
  }

  Column _bodyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _inputFieldWidget(context),
        _limitWidget(context),
        verticalSpace(Dimensions.heightSize),
        _walletDropDownWidget(context),
        _customNumKeyBoardWidget(context),
        _buttonWidget(context),
      ],
    );
  }
  // from currency come to user wallet

  Container _inputFieldWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: Dimensions.marginSizeHorizontal * 0.5,
        top: Dimensions.marginSizeVertical * 2,
      ),
      alignment: Alignment.topCenter,
      height: Dimensions.inputBoxHeight,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: Dimensions.widthSize * 0.7),
                  Expanded(
                    child: TextFormField(
                      style: CustomStyle.lightHeading2TextStyle.copyWith(
                        color: CustomColor.primaryTextColor,
                        fontSize: Dimensions.headingTextSize3 * 2,
                      ),

                      onChanged: (value) => controller.calculation(),

                      // Get.isDarkMode
                      //     ? CustomStyle.lightHeading2TextStyle.copyWith(
                      //         color: CustomColor.primaryTextColor,
                      //         fontSize: Dimensions.headingTextSize3 * 2,
                      //       )
                      //     : CustomStyle.darkHeading2TextStyle.copyWith(
                      //         color: CustomColor.primaryDarkTextColor,
                      //         fontSize: Dimensions.headingTextSize3 * 2,
                      //       ),
                      readOnly: true,
                      controller: controller.amountTextController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),

                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return Strings.pleaseFillOutTheField;
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: '0.0',
                        hintStyle: CustomStyle.darkHeading2TextStyle.copyWith(
                          color: CustomColor.primaryTextColor.withValues(
                            alpha: 0.7,
                          ),

                          fontSize: Dimensions.headingTextSize3 * 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.widthSize * 0.5),
                ],
              ),
            ),
          ),
          SizedBox(width: Dimensions.widthSize * 0.7),
          _currencyDropDownWidget(context),
        ],
      ),
    );
  }

  Container _customNumKeyBoardWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 0.3),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 3 / 1.7,
        shrinkWrap: true,
        children: List.generate(controller.keyboardItemList.length, (index) {
          return controller.inputItem(index);
        }),
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.marginSizeHorizontal * 0.8,
        right: Dimensions.marginSizeHorizontal * 0.8,
        top: Platform.isAndroid ? Dimensions.marginSizeVertical * 1.8 : 0.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => controller.isLoading
                  ? const CustomLoadingAPI()
                  : PrimaryButton(
                      title: buttonText,
                      onPressed: () {
                        Get.find<SetUpPinController>().showPinDialog(
                          context,
                          onSuccess: () {
                            if (controller
                                .amountTextController
                                .text
                                .isNotEmpty) {
                              controller.addFundProcess(context);
                            } else {
                              CustomSnackBar.error(Strings.plzEnterAmount);
                            }
                          },
                        );
                      },
                      borderColor: CustomColor.primaryLightColor,
                      buttonColor: CustomColor.primaryLightColor,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Container _currencyDropDownWidget(BuildContext context) {
    return Container(
      height: Dimensions.buttonHeight * 0.65,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.1,
        vertical: Dimensions.marginSizeVertical * 0.2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius * 2),
        color: CustomColor.primaryLightColor,
      ),
      child: Row(
        children: [
          horizontalSpace(Dimensions.widthSize),
          TitleHeading3Widget(
            text: walletController
                .cardyfieCardModel
                .data
                .supportedCurrency
                .first
                .code,

            color: CustomColor.whiteColor,
            fontWeight: FontWeight.w500,
          ),
          horizontalSpace(Dimensions.widthSize),
        ],
      ),
    );
  }

  Padding _walletDropDownWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          CustomTitleHeadingWidget(
            text: Strings.selectWallet,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: CustomColor.primaryLightTextColor,
            ),
          ),

          verticalSpace(Dimensions.paddingSize * 0.2),
          Obx(
            () => Container(
              margin: EdgeInsets.only(bottom: Dimensions.heightSize),
              child: CustomDropDown<UserWallet>(
                dropDownColor: CustomColor.whiteColor,

                items: walletController.walletsList,
                hint: walletController.selectMainWallet.value!.title,
                onChanged: (value) {
                  walletController.selectMainWallet.value = value!;
                  walletController.fromCurrency.value = value.currency.code
                      .toString();
                  controller.fromCurrencyRate.value = double.parse(
                    value.currency.rate,
                  );
                  controller.calculation();
                },

                padding: EdgeInsets.only(
                  left: Dimensions.paddingSize * 0.5,
                  right: Dimensions.paddingSize * 0.4,
                ),
                titleTextColor: CustomColor.blackColor,
                borderEnable: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Obx _limitWidget(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: mainCenter,
            children: [
              TitleHeading5Widget(
                text: Strings.exchangeRate,
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
              ),
              horizontalSpace(Dimensions.widthSize),
              TitleHeading5Widget(
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
                text:
                    "1 ${walletController.supportedCurrencyCode.value} = ${controller.exchangeRate.value.toStringAsFixed(8)} ${walletController.fromCurrency.value}",
              ),
            ],
          ),

          Row(
            mainAxisAlignment: mainCenter,
            children: [
              TitleHeading5Widget(
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
                text: Strings.charge,
              ),
              horizontalSpace(Dimensions.widthSize),
              TitleHeading5Widget(
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
                text:
                    "${controller.depositCharge.value.toStringAsFixed(2)} ${walletController.fromCurrency.value} +  ${controller.percentCharge.value.toStringAsFixed(2)} %",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: mainCenter,
            children: [
              TitleHeading5Widget(
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
                text: Strings.totalCharge,
              ),
              horizontalSpace(Dimensions.widthSize),
              TitleHeading5Widget(
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
                text:
                    "${controller.totalCharge.value.toStringAsFixed(8)} ${walletController.fromCurrency.value}",
              ),
            ],
          ),

          Row(
            mainAxisAlignment: mainCenter,
            children: [
              TitleHeading5Widget(
                text: Strings.limit,
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
              ),
              horizontalSpace(Dimensions.widthSize),
              TitleHeading5Widget(
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
                text:
                    "${walletController.minLimit.value.toStringAsFixed(2)} ${walletController.supportedCurrencyCode.value} - ${walletController.maxLimit.value.toStringAsFixed(2)}  ${walletController.supportedCurrencyCode.value}",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: mainCenter,
            children: [
              TitleHeading5Widget(
                text: Strings.remainingDailyLimit,
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
              ),
              horizontalSpace(Dimensions.widthSize),
              TitleHeading5Widget(
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
                text:
                    "${walletController.remainingController.remainingDailyLimit.value.toStringAsFixed(2)} ${walletController.supportedCurrencyCode.value} ",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: mainCenter,
            children: [
              TitleHeading5Widget(
                text: Strings.remainingMonthlyLimit,
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
              ),
              horizontalSpace(Dimensions.widthSize),
              TitleHeading5Widget(
                color: CustomColor.primaryLightColor.withValues(alpha: 0.9),
                text:
                    "${walletController.remainingController.remainingMonthLyLimit.value.toStringAsFixed(2)} ${walletController.supportedCurrencyCode.value} ",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget limitWidget({required fee, required limit}) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: Dimensions.marginSizeVertical * 0.2,
      horizontal: Dimensions.marginSizeHorizontal,
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: mainCenter,
          children: [
            CustomTitleHeadingWidget(
              text: Strings.transferFee,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                fontSize: Dimensions.headingTextSize5,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryTextColor
                    : CustomColor.primaryDarkTextColor,
              ),
            ),
            Text(
              " : $fee ",
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                fontSize: Dimensions.headingTextSize5,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryTextColor
                    : CustomColor.primaryDarkTextColor,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize * 0.2),
        Row(
          mainAxisAlignment: mainCenter,
          children: [
            CustomTitleHeadingWidget(
              text: Strings.limit,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                fontSize: Dimensions.headingTextSize5,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryTextColor
                    : CustomColor.primaryDarkTextColor,
              ),
            ),
            Text(
              " : $limit",
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                fontSize: Dimensions.headingTextSize5,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryTextColor
                    : CustomColor.primaryDarkTextColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
