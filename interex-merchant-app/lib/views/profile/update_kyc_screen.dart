import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/text_labels/title_heading4_widget.dart';

import '../../backend/utils/status_data_widget.dart';
import '../../controller/profile/update_kyc_controller.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';

class UpdateKycScreen extends StatelessWidget {
  UpdateKycScreen({super.key});

  final controller = Get.put(UpdateKycController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: Strings.updateKYC),
      body: Obx(
        () => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context),
      ),
    );
  }

  StatelessWidget _bodyWidget(BuildContext context) {
    final data = controller.kycModelData.data.kycStatus;
    return data == 2
        ? const StatusDataWidget(text: "Pending", icon: Icons.hourglass_empty)
        : data == 1
        ? const StatusDataWidget(
            text: "Verified",
            icon: Icons.check_circle_outline,
          )
        : Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSize * 0.8,
              vertical: Dimensions.paddingSize * 0.6,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                verticalSpace(Dimensions.heightSize * 0.5),
                Visibility(
                  visible: controller.inputFileFields.isNotEmpty,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 10.0, // Spacing between columns
                            mainAxisSpacing: 10.0, // Spacing between rows
                          ),
                      itemCount: controller.inputFileFields.length,
                      // Number of items in the grid
                      itemBuilder: (BuildContext context, int index) {
                        return controller.inputFileFields[index];
                      },
                    ),
                  ),
                ),
                Obx(() {
                  return Form(
                    key: formKey,
                    child: Column(
                      children: [
                        ...controller.inputFields.map((element) {
                          return element;
                        }),
                      ],
                    ),
                  );
                }),
                _buttonWidget(context),
              ],
            ),
          );
  }

  // ignore: unused_element
  Column _imageWidget(BuildContext context) {
    return Column(
      children: [
        verticalSpace(Dimensions.heightSize * 0.5),
        FittedBox(
          child: TitleHeading4Widget(
            text: Strings.uploadPassport.tr,
            fontSize: Dimensions.headingTextSize5,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
          ),
        ),
        verticalSpace(Dimensions.heightSize),
      ],
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 2),
      child: Obx(
        () => controller.isUpdateLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.updateKYCForm,
                onPressed: (() {
                  if (formKey.currentState!.validate()) {
                    controller.kycSubmitProcess();
                  }
                }),
              ),
      ),
    );
  }
}
