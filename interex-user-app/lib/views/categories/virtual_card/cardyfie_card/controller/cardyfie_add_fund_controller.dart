import 'package:qrpaypro/views/categories/virtual_card/cardyfie_card/model/my_card_model_cardyfie.dart';

import '../../../../../backend/model/common/common_success_model.dart';
import '../../../../../backend/services/api_endpoint.dart';
import '../../../../../backend/utils/request_process.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/basic_screen_imports.dart';
import '../../../../../widgets/others/congratulation_widget.dart';
import 'cardyfie_info_controller.dart';

class CardyfieAddFundController extends GetxController {
  final amountTextController = TextEditingController();
  List<String> totalAmount = [];

  RxDouble fromCurrencyRate = 0.0.obs;
  RxDouble exchangeRate = 0.0.obs;
  RxDouble totalCharge = 0.0.obs;
  RxDouble totalPay = 0.00.obs;
  RxDouble percentCharge = 0.00.obs;
    RxDouble depositCharge = 0.00.obs;
  RxDouble fromAmount = 0.00.obs;

  final controller = Get.put(VirtualCardyfieCardController());

  @override
  void onInit() {
    super.onInit();
    fromCurrencyRate.value = double.parse(
      controller.walletsList.first.currency.rate.toString(),
    );
    amountTextController.addListener(() {
      calculation();
    });
  }

  @override
  void dispose() {
    amountTextController.dispose();

    super.dispose();
  }

  /// Add Fund Process
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late CommonSuccessModel _addMoneyModel;
  CommonSuccessModel get addMoneyModel => _addMoneyModel;

  Future<CommonSuccessModel?> addFundProcess(BuildContext context) async {
    Map<String, dynamic> inputBody = {
      'card_id': controller.cardyfieCardUIId.value,
      'deposit_amount': int.parse(amountTextController.text.trim()),
      'currency': controller.supportedCurrencyCode.value,
      'from_currency': controller.fromCurrency.value,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieDepositCard,
      isLoading: _isLoading,
      method: HttpMethod.POST,
      body: inputBody,
      showSuccessMessage: true,
      showResult: true,
      onSuccess: (value) {
        _addMoneyModel = value!;

        StatusScreen.show(
          context: context,
          subTitle: Strings.addMoneySuccessfully.tr,
          onPressed: () {
            Get.offAllNamed(Routes.bottomNavBarScreen);
          },
        );
        // Get.offAllNamed(Routes.mainNavigation);
        //   },
      },
    );
  }

  RxString selectItem = ''.obs;
  List<String> keyboardItemList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    '<',
  ];
  List currencyList = ['USD', 'BDT'];
  List gatewayList = ['Paypal', 'Stripe'];

  void calculation() {
    double amount = 0.0;

    if (amountTextController.text.isNotEmpty) {
      try {
        amount = double.parse(amountTextController.text);
      } catch (e) {
        // print('Error parsing double: $e');
      }
    }

    CardCharge data = controller.cardyfieCardModel.data.cardCharge;
    exchangeRate.value =
        fromCurrencyRate.value /
        double.parse(
          controller.cardyfieCardModel.data.supportedCurrency.first.rate,
        );
    fromAmount.value = amount * exchangeRate.value;

   percentCharge.value = double.parse(data.cardDepositPercentFee.toString());
    depositCharge.value =
        double.parse(data.cardDepositFixedFee.toString()) * exchangeRate.value;

    totalCharge.value =
        (double.parse(data.cardDepositFixedFee.toString()) *
            exchangeRate.value) +
        (((amount * exchangeRate.value) / 100) * percentCharge.value);

    totalPay.value = fromAmount.value + totalCharge.value;

    // percentCharge.value = ((amount / 100) * );
    // totalCharge.value =
    //     double.parse(data.universalCardIssuesFee.toString()) +
    //     percentCharge.value;
    // totalPay.value = amount + totalCharge.value;
  }

  InkWell inputItem(int index) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onLongPress: () {
        if (index == 11) {
          if (totalAmount.isNotEmpty) {
            totalAmount.clear();
            amountTextController.text = totalAmount.join('');
          } else {
            return;
          }
        }
      },
      onTap: () {
        if (index == 11) {
          if (totalAmount.isNotEmpty) {
            totalAmount.removeLast();
            amountTextController.text = totalAmount.join('');
          } else {
            return;
          }
        } else {
          if (totalAmount.contains('.') && index == 9) {
            return;
          } else {
            totalAmount.add(keyboardItemList[index]);
            amountTextController.text = totalAmount.join('');
            debugPrint(totalAmount.join(''));
          }
        }
      },
      child: Center(
        child: CustomTitleHeadingWidget(
          text: keyboardItemList[index],
          style: CustomStyle.darkHeading2TextStyle.copyWith(
            color: CustomColor.primaryLightColor,
            fontSize: Dimensions.headingTextSize3 * 2,
          ),
        ),
      ),
    );
  }
}
