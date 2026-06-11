import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/text_labels/title_heading3_widget.dart';
import 'package:qrpay/widgets/text_labels/title_heading5_widget.dart';
import '../../backend/model/api_key/api_key_model.dart';
import '../../controller/drawer/api_key_controller.dart';
import '../../custom_assets/assets.gen.dart';
import '../../utils/size.dart';
import '../../utils/strings.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/inputs/copy_with_input.dart';
import '../../widgets/inputs/primary_input_filed.dart';

class APIKeyScreen extends StatelessWidget {
  APIKeyScreen({super.key});

  final controller = Get.put(ApiKeyController());
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        floatingActionButton: _addApiKeyButton(context),
        appBar: AppBarWidget(text: Strings.apiKey.tr),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return controller.apiKeyModel!.data.keys.isEmpty
        ? const Center(
            child: TitleHeading3Widget(
              text: Strings.noRecordFound,
              color: CustomColor.primaryLightColor,
            ),
          )
        : ListView(
            children: List.generate(controller.apiKeyModel!.data.keys.length, (
              index,
            ) {
              return _keyWidget(
                context,
                controller.apiKeyModel!.data.keys[index],
                index,
              );
            }),
          );
  }

  Column _keyWidget(BuildContext context, KeyModel data, index) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeHorizontal * 0.7,
            vertical: Dimensions.marginSizeVertical * 0.2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(Dimensions.radius * 02),
          ),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.paddingSize * 0.5),
            child: Column(
              crossAxisAlignment: crossStart,
              children: [
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading3Widget(
                      text: data.name,
                      color: !Get.isDarkMode
                          ? CustomColor.blackColor.withValues(alpha: 0.7)
                          : Colors.white,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return deleteAlertDialog(
                              context,
                              data.id.toString(),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingHorizontalSize * 0.4,
                          vertical: Dimensions.paddingVerticalSize * 0.15,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColor.redColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius * 0.5,
                          ),
                        ),
                        child: TitleHeading5Widget(
                          text: Strings.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(Dimensions.heightSize * 0.5),
                CopyInputWidget(
                  suffixIcon: Assets.icon.copy,
                  readOnly: true,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: data.clientId)).then((
                      _,
                    ) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(Strings.copiedToClipBoard.tr)),
                      );
                    });
                  },
                  controller: TextEditingController(text: data.clientId),
                  hint: '9DnRgZjiYyVV6OEORBp',
                  label: Strings.primaryKey,
                ),
                verticalSpace(Dimensions.heightSize * 0.3),
                CopyInputWidget(
                  suffixIcon: Assets.icon.copy,
                  readOnly: true,
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: data.clientSecret),
                    ).then((_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(Strings.copiedToClipBoard.tr)),
                      );
                    });
                  },
                  controller: TextEditingController(text: data.clientSecret),
                  hint: '9DnRgZjiYyVV6OEORBp',
                  label: Strings.secretKey.tr,
                ),
                verticalSpace(Dimensions.heightSize * 0.3),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading3Widget(
                      text: data.mode,
                      color: !Get.isDarkMode
                          ? CustomColor.blackColor.withValues(alpha: 0.5)
                          : Colors.white,
                    ),
                    controller.selectedIndex.value == index &&
                            controller.isConfirmLoading
                        ? Padding(
                            padding: EdgeInsets.all(
                              Dimensions.paddingSize * 0.5,
                            ),
                            child: const CustomLoadingAPI(),
                          )
                        : Switch(
                            value: data.mode != "SANDBOX",
                            onChanged: (v) {
                              controller.selectedIndex.value = index;
                              controller.changeProductionModeProcess(
                                data.id.toString(),
                              );
                            },
                            activeThumbColor: CustomColor.primaryLightColor,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  FloatingActionButton _addApiKeyButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _addApiKeySheet(context);
          },
        );
      },
      backgroundColor: CustomColor.primaryLightColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius * 10),
      ),
      child: const Icon(Icons.add_rounded, color: Colors.white),
    );
  }

  Dialog _addApiKeySheet(BuildContext context) {
    return Dialog(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                backgroundColor: CustomColor.primaryLightColor,
                child: Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.paddingSize),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: mainMin,
                children: [
                  Row(
                    mainAxisAlignment: mainCenter,
                    children: [
                      TitleHeading3Widget(
                        text: Strings.createNewApiKey,
                        color: Get.isDarkMode
                            ? Colors.white
                            : CustomColor.blackColor,
                      ),
                    ],
                  ),
                  verticalSpace(Dimensions.heightSize),
                  PrimaryInputWidget(
                    controller: controller.apiKeyController,
                    hint: Strings.enterName,
                    label: Strings.name,
                  ),
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.marginSizeVertical,
                      ),
                      child: controller.isCreateLoading
                          ? const CustomLoadingAPI()
                          : PrimaryButton(
                              title: Strings.create,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.createApiKeyProcess().then((
                                    value,
                                  ) {
                                    controller.apiKeyController.clear();
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                  });
                                }
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Dialog deleteAlertDialog(BuildContext context, String id) {
    return Dialog(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                backgroundColor: CustomColor.primaryLightColor,
                child: Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.paddingSize),
            child: Column(
              mainAxisSize: mainMin,
              children: [
                TitleHeading3Widget(
                  text: Strings.deleteAlert,
                  color: Get.isDarkMode ? Colors.white : CustomColor.blackColor,
                  textAlign: TextAlign.center,
                ),
                verticalSpace(Dimensions.heightSize * 0.6),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.marginSizeVertical * 0.5,
                  ),
                  child: Obx(
                    () => controller.isDeleteLoading
                        ? const CustomLoadingAPI()
                        : Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  title: Strings.cancel,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              horizontalSpace(Dimensions.widthSize * 1.5),
                              Expanded(
                                child: PrimaryButton(
                                  title: Strings.delete,
                                  onPressed: () {
                                    controller.deleteApiKeyProcess(id).then((
                                      value,
                                    ) {
                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                    });
                                  },
                                  borderColor: CustomColor.redColor,
                                  buttonColor: CustomColor.redColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
