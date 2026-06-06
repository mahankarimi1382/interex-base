import 'dart:io';

import 'package:intl/intl.dart';

import '../../../backend/model/categories/virtual_card/virtual_card_sudo/identity_type_model.dart';
import '../../../backend/model/wallets/wallets_model.dart';
import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/virtual_card/sudo_virtual_card/sudo_adfund_controller.dart';
import '../../../utils/basic_screen_imports.dart';
import '../../inputs/custom_input_with_drop_down.dart';
import '../../payment_link/custom_drop_down.dart';
import '../limit_widget.dart';

class SudoAddFundCustomAmountWidget extends StatelessWidget {
  SudoAddFundCustomAmountWidget({
    super.key,
    required this.buttonText,
    required this.onTap,
  });
  final String buttonText;
  final VoidCallback onTap;
  final controller = Get.put(SudoAddFundController());

  @override
  Widget build(BuildContext context) {
    return _bodyWidget(context);
  }

  Padding _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _inputFields(context),
          _chargeAndFee(context),
          _buttonWidget(context),
        ],
      ),
    );
  }

  Column _inputFields(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: Dimensions.paddingSize),
          child: CustomInputWithDropDown(
            controller: controller.virtualCardController.fundAmountController,
            hint: Strings.zero00,
            label: Strings.amount,
            selectedItem:
                controller.virtualCardController.selectedSupportedCurrency,
            itemList: controller.virtualCardController.supportedCurrencyList,
            displayItem: (item) => item.code,
            onDropChanged: (value) {
              controller.virtualCardController.selectedSupportedCurrency.value =
                  value;
              controller.virtualCardController.updateLimit();
              controller.virtualCardController.calculation();
            },
            onFieldChanged: (value) {
              controller.virtualCardController.calculation();
            },
          ),
        ),
        verticalSpace(Dimensions.marginBetweenInputBox),
        if (buttonText == Strings.createCard) ...[
          !controller
                  .virtualCardController
                  .cardInfoModel
                  .data
                  .cardExtraFieldsStatus
              ? SizedBox.shrink()
              : Column(
                  children: [
                    _datePicker(context),
                    _identityType(context),
                    _othersInput(context),
                  ],
                ),
        ],
        _fromWallet(context),
      ],
    );
  }

  Obx _chargeAndFee(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(top: Dimensions.paddingVerticalSize * 0.4),
        child: LimitWidget(
          fee:
              '${controller.virtualCardController.totalCharge.value.toStringAsFixed(4)} ${controller.virtualCardController.selectMainWallet.value!.currency.code}',
          limit:
              '${controller.virtualCardController.limitMin} - ${controller.virtualCardController.limitMax} ${controller.virtualCardController.selectedSupportedCurrency.value!.code}',
        ),
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Platform.isAndroid ? Dimensions.marginSizeVertical * 1.8 : 0.0,
      ),
      child: Row(
        mainAxisAlignment: mainCenter,
        children: [
          Obx(
            () => controller.isLoading
                ? const CustomLoadingAPI()
                : Expanded(
                    child: PrimaryButton(
                      title: buttonText,
                      onPressed: onTap,
                      borderColor: CustomColor.primaryLightColor,
                      buttonColor: CustomColor.primaryLightColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Obx _fromWallet(BuildContext context) {
    return Obx(
      () => CustomDropDown<MainUserWallet>(
        dropDownHeight: Dimensions.inputBoxHeight * 0.9,
        items: controller.virtualCardController.walletsList,
        title: Strings.fromWallet,
        hint: controller.virtualCardController.selectMainWallet.value!.title,
        onChanged: (value) {
          controller.virtualCardController.selectMainWallet.value = value!;
        },
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingHorizontalSize * 0.25,
        ),
        titleTextColor: CustomColor.primaryLightTextColor,
        borderEnable: true,
        dropDownFieldColor: Colors.transparent,
        dropDownIconColor: CustomColor.primaryLightTextColor,
      ),
    );
  }

  Column _othersInput(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        PrimaryInputWidget(
          controller: controller.identityNumberController,
          hint: Strings.enterIdentityNumber.tr,
          label: Strings.identityNumber.tr,
        ),
        verticalSpace(Dimensions.heightSize * 0.7),
        PrimaryInputWidget(
          controller: controller.phoneController,
          hint: Strings.enterPhone.tr,
          label: Strings.phone.tr,
        ),
        verticalSpace(Dimensions.heightSize * 0.7),
      ],
    );
  }

  Padding _datePicker(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.heightSize * 0.5),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(1930),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            final DateFormat formatter = DateFormat('yyyy/MM/dd');
            final String formattedDate = formatter.format(pickedDate);
            controller.birthdateController.text = formattedDate;
          }
        },
        child: AbsorbPointer(
          child: PrimaryInputWidget(
            controller: controller.birthdateController,
            label: Strings.dateOfBirth,
            hint: Strings.enterDateOfBirth,
            isValidator: true,
          ),
        ),
      ),
    );
  }

  Obx _identityType(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropDown<IdentityTypeModel>(
            dropDownHeight: Dimensions.inputBoxHeight * 0.9,
            items: controller.identityTypeList,
            title: Strings.identityType,
            hint: controller.selectIdentityType.value!.label,
            onChanged: (value) {
              controller.selectIdentityType.value = value!;
            },
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingHorizontalSize * 0.25,
            ),
            titleTextColor: CustomColor.primaryLightTextColor,
            borderEnable: true,
            dropDownFieldColor: Colors.transparent,
            dropDownIconColor: CustomColor.primaryLightTextColor,
          ),
          verticalSpace(Dimensions.heightSize * 0.7),
        ],
      ),
    );
  }
}
