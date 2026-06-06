part of "../cardyfie_create_card_screen.dart";

class CardyfieCreateCardWidget extends StatelessWidget {
  CardyfieCreateCardWidget({super.key});
  final controller = Get.put(VirtualCardyfieCardController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _inputWidget(context),
        _walletWidget(context),
        _chargeWidget(context),
        _buttonWidget(context),
        _buttonCustomerUpdateWidget(context),
      ],
    );
  }

  Column _walletWidget(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            margin: EdgeInsets.only(bottom: Dimensions.heightSize),
            child: CustomDropDown<SupportedCurrency>(
              items: controller.supportedCurrencyList,
              title: Strings.cardCurrency,
              hint: controller.supportedCurrencyCode.value,

              onChanged: (value) {
                controller.selectSupportedCurrency.value = value!;
                controller.supportedCurrencyCode.value = value.code.toString();
              },
              padding: EdgeInsets.only(
                left: Dimensions.paddingSize * 0.5,
                right: Dimensions.paddingSize * 0.3,
              ),
              titleTextColor: CustomColor.primaryLightColor,
              titleStyle: TextStyle(color: CustomColor.primaryLightColor),
              borderEnable: true,
              dropDownColor: CustomColor.whiteColor,
            ),
          ),
        ),

        // from currency come to user wallet
        Obx(
          () => Container(
            margin: EdgeInsets.only(bottom: Dimensions.heightSize),
            child: CustomDropDown<UserWallet>(
              items: controller.walletsList,
              title: Strings.fromWallet,
              hint: controller.selectMainWallet.value?.title ?? '',
              onChanged: (value) {
                controller.selectMainWallet.value = value!;
                controller.fromCurrency.value = value.currency.code.toString();
              },
              padding: EdgeInsets.only(
                left: Dimensions.paddingSize * 0.5,
                right: Dimensions.paddingSize * 0.3,
              ),
              titleTextColor: CustomColor.primaryLightColor,
              titleStyle: TextStyle(color: CustomColor.primaryLightColor),
              borderEnable: true,
              dropDownColor: CustomColor.whiteColor,
            ),
          ),
        ),
      ],
    );
  }

  _chargeWidget(BuildContext context) {
    var userData = controller.cardyfieCardModel.data;
    return Column(
      mainAxisAlignment: mainCenter,
      children: [
        Row(
          mainAxisAlignment: mainSpaceBet,
          children: [
            const TitleHeading4Widget(text: Strings.totalCharge),
            Obx(
              () => TitleHeading4Widget(
                text: "${controller.totalCharge.value} ${userData.baseCurr}",
                fontSize: Dimensions.headingTextSize5,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize * 0.4),
        Row(
          mainAxisAlignment: mainSpaceBet,
          children: [
            const TitleHeading4Widget(text: Strings.totalPay),
            Obx(
              () => TitleHeading4Widget(
                text: "${controller.totalCharge.value} ${userData.baseCurr}",
                fontSize: Dimensions.headingTextSize5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _inputWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        verticalSpace(Dimensions.heightSize),
        PrimaryTextInputWidget(
          controller: controller.cardHolderNameController,
          hint: Strings.cardHolder,
          labelText: Strings.cardHolder,
        ),
        verticalSpace(Dimensions.heightSize),
        CustomDropDown<TypeSelectionModel>(
          items: controller.cardTierList
              .map((e) => TypeSelectionModel(e['name']!))
              .toList(),
          title: Strings.cardTier,
          hint: controller.selectTierName.value,
          onChanged: (value) {
            controller.selectTierName.value = value!.title;
            if (controller.selectTierName.value == "Universal") {
              controller.totalCharge.value = double.parse(
                controller
                    .cardyfieCardModel
                    .data
                    .cardCharge
                    .universalCardIssuesFee
                    .toString(),
              );

              print(controller.totalCharge);
            } else {
              controller.totalCharge.value = double.parse(
                controller
                    .cardyfieCardModel
                    .data
                    .cardCharge
                    .platinumCardIssuesFee
                    .toString(),
              );
            }

            final selectedItem = controller.cardTierList.firstWhere(
              (item) => item['name'] == value.title,
            );
            controller.selectTierSlug.value = selectedItem['slug']!;
          },
          padding: EdgeInsets.only(
            left: Dimensions.paddingSize * 0.5,
            right: Dimensions.paddingSize * 0.3,
          ),
          titleTextColor: CustomColor.primaryLightColor,
          titleStyle: TextStyle(color: CustomColor.primaryLightColor),
          borderEnable: true,
          dropDownColor: CustomColor.whiteColor,
        ),
        verticalSpace(Dimensions.heightSize),
        CustomDropDown<TypeSelectionModel>(
          items: controller.cardTypeList
              .map((e) => TypeSelectionModel(e['name']!))
              .toList(),
          title: Strings.cardType,
          hint: controller.selectCardTypeName.value,
          onChanged: (value) {
            controller.selectCardTypeName.value = value!.title;

            final selectedItem = controller.cardTypeList.firstWhere(
              (item) => item['name'] == value.title,
            );
            controller.selectCardTypeSlug.value = selectedItem['slug']!;
          },
          padding: EdgeInsets.only(
            left: Dimensions.paddingSize * 0.5,
            right: Dimensions.paddingSize * 0.3,
          ),
          titleTextColor: CustomColor.primaryLightColor,
          titleStyle: TextStyle(color: CustomColor.primaryLightColor),
          borderEnable: true,
          dropDownColor: CustomColor.whiteColor,
        ),
        verticalSpace(Dimensions.heightSize),
      ],
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.paddingSize * 2,
        // bottom: Dimensions.paddingSize * 4.8,
      ),
      child: Obx(
        () => controller.isBuyCardLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.confirm,
                onPressed: () {
                  controller.issueCardProcess(context);
                },
                borderColor: CustomColor.primaryLightColor,
                buttonColor: CustomColor.primaryLightColor,
              ),
      ),
    );
  }

  Container _buttonCustomerUpdateWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.paddingSize,
        bottom: Dimensions.paddingSize * 4.8,
      ),
      child: Obx(
        () => controller.isCustomerCreateLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.updateCustomer,
                onPressed: () {
                  Get.toNamed(Routes.cardyfieUpdateCustomerScreen);
                },
                borderColor: CustomColor.primaryLightColor,
                buttonColor: CustomColor.primaryLightColor,
              ),
      ),
    );
  }
}
