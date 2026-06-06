import 'package:flutter/services.dart';

import '../../../../language/language_controller.dart';
import '../../../../utils/responsive_layout.dart';
import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/deposit/deposti_controller.dart';
import '../../../utils/basic_screen_imports.dart';
import '../../../widgets/appbar/appbar_widget.dart';
import '../../../widgets/card_widget.dart';
import '../../../widgets/inputs/primary_text_input_widget.dart';

class AddMoneyAuthorizedPaymentScreen extends StatelessWidget {
  AddMoneyAuthorizedPaymentScreen({super.key});

  final controller = Get.find<DepositController>();
  final authorizedKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: Strings.payWithCard),
        body: _bodyWidget(context),
      ),
    );
  }

  Column _bodyWidget(BuildContext context) {
    return Column(
      children: [
        verticalSpace(Dimensions.heightSize * 1),
        Obx(
          () => CardPreviewWidget(
            cardNumber: controller.cardNumber.value,
            expiryDate: controller.expiredDate.value,
            cvvCode: controller.cvc.value,
            onTap: () {
              controller.showBack.value = !controller.showBack.value;
            },
            showBack: controller.showBack.value,
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.marginSizeHorizontal * 0.4,
            ),
            physics: const BouncingScrollPhysics(),
            children: [_inputWidget(context), _buttonWidget(context)],
          ),
        ),
      ],
    );
  }

  Form _inputWidget(BuildContext context) {
    return Form(
      key: authorizedKey,
      child: Column(
        children: [
          verticalSpace(Dimensions.heightSize * 1),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimensions.marginSizeHorizontal * 0.5,
            ),
            child: PrimaryTextInputWidget(
              labelText: Strings.cardNumber,
              keyboardType: const TextInputType.numberWithOptions(),
              maxLine: 1,

              hint: "0000 0000 0000 0000",
              controller: controller.cardNumberController,

              validator: (value) {
                if (value!.isEmpty) {
                  return Get.find<LanguageController>().isLoading
                      ? ""
                      : Get.find<LanguageController>().getTranslation(
                          Strings.pleaseFillOutTheField,
                        );
                } else if (value
                        .toString()
                        .replaceAll(" ", "")
                        .length
                        .isLowerThan(16) &&
                    value
                        .toString()
                        .replaceAll(" ", "")
                        .length
                        .isGreaterThan(20)) {
                  return Get.find<LanguageController>().isLoading
                      ? ""
                      : Get.find<LanguageController>().getTranslation(
                          Strings.invalidCardNumber,
                        );
                }
                return null;
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(24),
                FilteringTextInputFormatter.digitsOnly,
                CardNumberFormatter2(),
              ],
              onChanged: (value) {
                controller.cardNumber.value = value;
                controller.showBack.value = false;
              },
            ),
          ),

          verticalSpace(Dimensions.heightSize * 1),

          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimensions.marginSizeHorizontal * 0.5,
            ),
            child: PrimaryTextInputWidget(
              labelText: Strings.expirationDate,
              keyboardType: const TextInputType.numberWithOptions(),
              maxLine: 1,
              hint: "YY/MM",
              controller: controller.cardExpiryController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
                ExpiryDateFormatter2(),
              ],
              onChanged: (value) {
                controller.expiredDate.value = value;
                controller.showBack.value = false;
              },
            ),
          ),
          verticalSpace(Dimensions.heightSize * 1),

          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimensions.marginSizeHorizontal * 0.5,
            ),
            child: PrimaryTextInputWidget(
              labelText: Strings.cvv,
              keyboardType: const TextInputType.numberWithOptions(),
              maxLine: 1,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly,
              ],
              hint: "123",
              controller: controller.cardCVCController,
              onChanged: (value) {
                controller.cvc.value = value;
                controller.showBack.value = true;
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.paddingVerticalSize * 2),
      child: Obx(
        () => controller.isAuthorizedSubmitLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                onPressed: () {
                  controller.showBack.value = false;
                  if (authorizedKey.currentState!.validate()) {
                    controller.authorizedSubmitProcess();
                  }
                },
                title: Strings.submit,
              ),
      ),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 2) {
      text = "${text.substring(0, 2)}/${text.substring(2)}";
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length > 20) {
      digitsOnly = digitsOnly.substring(0, 20);
    }

    final formatted = digitsOnly.replaceAllMapped(
      RegExp(r".{1,4}"),
      (match) => "${match.group(0)} ",
    );

    return TextEditingValue(
      text: formatted.trim(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateFormatter2 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    String formatted = text;
    if (text.length > 2) {
      String yy = text.substring(0, 2);
      String mm = text.substring(2);

      int? month = int.tryParse(mm);
      if (month != null) {
        if (month < 1) {
          mm = "0";
        } else if (month > 12) {
          mm = "12";
        }
      }

      formatted = "$yy/$mm";
    } else {
      String yy = text;

      int? year = int.tryParse(yy);
      if (year != null) {
        debugPrint(DateTime.now().year.toString().substring(3));

        if (year < 2) {
          yy = "2";
        }
        // else if (year <
        //     int.parse(DateTime.now().year.toString().substring(2))) {
        //   yy = "2";
        // }
      }

      formatted = yy;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CardNumberFormatter2 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(' ', '');
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digitsOnly.length) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length),
    );
  }
}
