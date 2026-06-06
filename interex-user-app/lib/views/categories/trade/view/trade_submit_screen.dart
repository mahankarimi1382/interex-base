import 'package:qrpaypro/backend/utils/custom_loading_api.dart';
import 'package:qrpaypro/utils/basic_screen_imports.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';
import 'package:qrpaypro/widgets/others/limit_widget.dart';
import 'package:qrpaypro/widgets/payment_link/custom_drop_down.dart';
import '../../../../backend/local_storage/local_storage.dart';
import '../../../../routes/routes.dart';
import '../../../../widgets/others/limit_information_widget.dart';
import '../../../../widgets/text_labels/title_heading5_widget.dart';
import '../../../set_up_pin/controller/set_up_pin_controller.dart';
import '../controller/trade_controller.dart';
import '../model/my_trade_model.dart';

class TradeSubmitScreen extends StatelessWidget {
  TradeSubmitScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final controller = Get.find<TradeController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(
          text: Strings.tradeCreate,
        ),
        body: Obx(() => controller.isSubmitLoading
            ? CustomLoadingAPI()
            : _bodyWidget(context)),
      ),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingHorizontalSize * .7,
        vertical: Dimensions.paddingVerticalSize * .4,
      ),
      children: [
        _exchangeRateWidget(),
        _inputWidget(),
        verticalSpace(Dimensions.paddingVerticalSize * .2),
        LimitWidget(
            feeText: Strings.availabeBlance,
            limitText: Strings.charge,
            fee:
                "${controller.myTradeModel.data.wallet.firstWhere((value) => value.code == controller.selectedSaleCurrency.value.code).balance} ${controller.selectedSaleCurrency.value.code}",
            limit:
                "${controller.fixedCharge.value.toStringAsFixed(2)} ${controller.selectedSaleCurrency.value.code}  + ${controller.percCharge.value.toStringAsFixed(2)}%"),
        // verticalSpace(Dimensions.paddingVerticalSize * 1),

        _limitInformation(context),

        // verticalSpace(Dimensions.paddingVerticalSize * 1),
        PrimaryButton(
            title: Strings.continuee,
            onPressed: () {
              if(formKey.currentState!.validate()){
                Get.find<SetUpPinController>().showPinDialog(context, onSuccess: (){
                Get.toNamed(Routes.tradeSubmitPreviewScreen);
                });
              }
            })
      ],
    );
  }

  Form _inputWidget() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          verticalSpace(Dimensions.paddingVerticalSize * .8),
          Directionality(
            textDirection: TextDirection.ltr,
            child: PrimaryInputWidget(
              controller: controller.sellingAmountController,
              hint: "0.0",
              label: Strings.sellingAmount,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.toString().isNotEmpty) {
                  controller.calculation();
                }
              },
              suffixIcon: Container(
                  height: Dimensions.buttonHeight,
                  width: Dimensions.widthSize * 10,
                  decoration: BoxDecoration(
                      color: CustomColor.primaryLightColor,
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(Dimensions.radius * .8))),
                  child: CustomDropDown<ECurrency>(
                      isExpanded: false,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingHorizontalSize * .2),
                      dropDownIconColor: CustomColor.whiteColor,
                      titleTextColor: CustomColor.whiteColor,
                      borderColor: Colors.transparent,
                      items: controller.myTradeModel.data.saleCurrency,
                      hint: controller.selectedSaleCurrency.value.code,
                      isCurrencyDropDown: true,
                      onChanged: (value) {
                        controller.selectedSaleCurrency.value = value!;
                        controller.calculation();
                      })),
            ),
          ),
          verticalSpace(Dimensions.paddingVerticalSize * .5),
          Directionality(
            textDirection: TextDirection.ltr,
            child: PrimaryInputWidget(
              controller: controller.askingRateController,
              hint: "0.0",
              keyboardType: TextInputType.number,
              label: Strings.askingRate,
              onChanged: (value) {
                if (value.toString().isNotEmpty) {
                  controller.calculation();
                }
              },
              suffixIcon: Container(
                  height: Dimensions.buttonHeight,
                  width: Dimensions.widthSize * 10,
                  decoration: BoxDecoration(
                      color: CustomColor.primaryLightColor,
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(Dimensions.radius * .8))),
                  child: CustomDropDown<ECurrency>(
                      isExpanded: false,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingHorizontalSize * .2),
                      dropDownIconColor: CustomColor.whiteColor,
                      titleTextColor: CustomColor.whiteColor,
                      borderColor: Colors.transparent,
                      items: controller.myTradeModel.data.rateCurrency,
                      hint: controller.selectedRateCurrency.value.code,
                      isCurrencyDropDown: true,
                      onChanged: (value) {
                        controller.selectedRateCurrency.value = value!;
                        controller.calculation();
                      })),
            ),
          ),
        ],
      ),
    );
  }

  InkWell _exchangeRateWidget() {
    return InkWell(
      onTap: () {
        // Get.toNamed(Routes.moneyExchange);
      },
      child: Container(
        height: Dimensions.buttonHeight * 2,
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? CustomColor.whiteColor.withValues(alpha: .05)
                : CustomColor.whiteColor.withValues(alpha: 1),
            borderRadius: BorderRadius.circular(Dimensions.radius * 1.2)),
        child: Column(
          crossAxisAlignment: crossCenter,
          mainAxisAlignment: mainCenter,
          children: [
            TitleHeading5Widget(
                text: Strings.sellingExchangeRate,
                fontWeight: FontWeight.normal),
            verticalSpace(Dimensions.paddingVerticalSize * .3),
            TitleHeading3Widget(
                text:
                    "1 ${controller.selectedSaleCurrency.value.code} = ${controller.exchangeRate.value.toStringAsFixed(4)} ${controller.selectedRateCurrency.value.code}"),
          ],
        ),
      ),
    );
  }


  LimitInformationWidget _limitInformation(BuildContext context) {

    int precision = controller.selectedSaleCurrency.value.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();

    return LimitInformationWidget(
      showDailyLimit: controller.dailyLimit.value == 0.0 ? false : true,
      showMonthlyLimit: controller.monthlyLimit.value == 0.0 ? false : true,
      transactionLimit:
      '${controller.minLimit.value.toStringAsFixed(precision)} - ${controller.maxLimit.value.toStringAsFixed(precision)} ${controller.selectedSaleCurrency.value.code}',
      dailyLimit:
      '${controller.dailyLimit.value.toStringAsFixed(precision)} ${controller.selectedSaleCurrency.value.code}',
      monthlyLimit:
      '${controller.monthlyLimit.value.toStringAsFixed(precision)} ${controller.selectedSaleCurrency.value.code}',
      remainingMonthLimit:
      '${controller.remainingController.remainingMonthLyLimit.value.toStringAsFixed(precision)} ${controller.selectedSaleCurrency.value.code}',
      remainingDailyLimit:
      '${controller.remainingController.remainingDailyLimit.value.toStringAsFixed(precision)} ${controller.selectedSaleCurrency.value.code}',
    );
  }
}
