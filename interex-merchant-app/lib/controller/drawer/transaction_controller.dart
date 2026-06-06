import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/model/common/common_success_model.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/text_labels/title_heading2_widget.dart';

import '../../backend/model/transaction_log/transaction_log_model.dart';
import '../../backend/services/api_services.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../../views/set_up_pin/controller/set_up_pin_controller.dart';

class TransactionController extends GetxController {
  @override
  void onInit() {
    getTransactionData();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late TransactionLogModel _transactionLogModel;
  TransactionLogModel get transactionModel => _transactionLogModel;

  Future<TransactionLogModel> getTransactionData() async {
    _isLoading.value = true;
    update();

    // calling  from api service
    await ApiServices.getTransactionLogAPi().then((value) {
      _transactionLogModel = value!;

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    update();
    return _transactionLogModel;
  }

  ///--------------

  final _isRefundLoading = false.obs;
  bool get isRefundLoading => _isRefundLoading.value;

  late CommonSuccessModel _refundModel;
  CommonSuccessModel get refundModel => _refundModel;

  Future<CommonSuccessModel> refundProcess({
    required String endPoint,
    required String targetId,
  }) async {
    _isRefundLoading.value = true;
    update();

    // calling  from api service
    await ApiServices.refundApi(body: {"target": targetId}, endPoint: endPoint)
        .then((value) {
      _refundModel = value!;
      getTransactionData();
      _isRefundLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
      _isRefundLoading.value = false;
    });
    update();
    return _refundModel;
  }

  /// dialog ----------

  void showRefundConfirmationDialog(
    BuildContext context, {
    required String endPoint,
    required String targetId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Title Text
                TitleHeading2Widget(
                  text: Strings.areYouSureToRefundBalance,
                ),

                verticalSpace(Dimensions.heightSize),

                /// Button Row
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () => Navigator.pop(context),
                        title: Strings.cancel,
                        buttonColor: CustomColor.redColor,
                      ),
                    ),
                    horizontalSpace(Dimensions.marginSizeHorizontal * .5),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Get.find<SetUpPinController>().showPinDialog(context,
                              onSuccess: () {
                            refundProcess(
                                endPoint: endPoint, targetId: targetId);
                            debugPrint("Refund confirmed");
                          });
                        },
                        title: Strings.refund,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
