import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/inputs/phone_number_with_contry_code_input.dart';

import '../../backend/utils/custom_loading_api.dart';
import '../../controller/profile/update_profile_controller.dart';
import '../../routes/routes.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../widgets/inputs/country_picker_input_widget.dart';
import '../../widgets/inputs/primary_input_filed.dart';
import '../../widgets/others/congratulation_widget.dart';
import '../../widgets/others/image_picker/image_picker.dart';
import '../../widgets/text_labels/custom_title_heading_widget.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final controller = Get.put(UpdateProfileController());
  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(
          text: Strings.updateProfile.tr,
        ),
        body: _bodyWidget(context),
      ),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.9,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _imgWidget(context),
        _inputWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  ImagePickerWidget _imgWidget(BuildContext context) {
    return ImagePickerWidget();
  }

  Form _inputWidget(BuildContext context) {
    return Form(
      key: _fromKey,
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Row(
            children: [
              Expanded(
                child: PrimaryInputWidget(
                  hint: Strings.enterFirstName.tr,
                  label: Strings.firstName.tr,
                  controller: controller.firstNameController,
                ),
              ),
              horizontalSpace(Dimensions.widthSize),
              Expanded(
                child: PrimaryInputWidget(
                  hint: Strings.enterLastName.tr,
                  label: Strings.lastName.tr,
                  controller: controller.lastNameController,
                ),
              ),
            ],
          ),
          verticalSpace(Dimensions.heightSize),
          PrimaryInputWidget(
            controller: controller.businessNameController,
            hint: Strings.enterBusinessName.tr,
            label: Strings.businessName.tr,
          ),
          verticalSpace(Dimensions.heightSize),
          PrimaryInputWidget(
            controller: controller.emailController,
            hint: Strings.enterEmailAddress.tr,
            label: Strings.emailAddress.tr,
            readOnly: true,
          ),
          verticalSpace(Dimensions.heightSize),
          CustomTitleHeadingWidget(
            text: Strings.country.tr,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor
                  : CustomColor.primaryTextColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.5),
          ProfileCountryCodePickerWidget(
            initialSelection: controller.countryName.value,
            onChanged: (value) {
              controller.countryName.value = value.name.toString();
              controller.phoneCode.value = value.toString();
            },
            controller: controller.countryController,
          ),
          PhoneNumberInputWidget(
            countryCode: controller.phoneCode,
            controller: controller.phoneController,
            hint: Strings.enterPhone.tr,
            label: Strings.phoneNumber.tr,
          ),
          verticalSpace(
            Dimensions.heightSize,
          ),
          Row(
            children: [
              Expanded(
                child: PrimaryInputWidget(
                  hint: Strings.enterCity.tr,
                  label: Strings.city.tr,
                  controller: controller.cityController,
                ),
              ),
              horizontalSpace(Dimensions.widthSize),
              Expanded(
                child: PrimaryInputWidget(
                  hint: Strings.enterZipCode.tr,
                  label: Strings.zipCode.tr,
                  controller: controller.zipCodeController,
                ),
              ),
            ],
          ),
          verticalSpace(Dimensions.heightSize),
        ],
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical,
      ),
      child: Obx(
        () => controller.isUpdateLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.updateProfile.tr,
                onPressed: () {
                  if (_fromKey.currentState!.validate()) {
                    if (controller.imageController.isImagePathSet.value) {
                      controller
                          .profileUpdateWithImageProcess()
                          .then((value) => StatusScreen.show(
                              context: context,
                              subTitle: value.message.success.first,
                              onPressed: () {
                                Get.offAllNamed(Routes.bottomNavBarScreen);
                              }));
                    } else {
                      controller
                          .profileUpdateWithOutImageProcess()
                          .then((value) => StatusScreen.show(
                              context: context,
                              subTitle: value.message.success.first,
                              onPressed: () {
                                Get.offAllNamed(Routes.bottomNavBarScreen);
                              }));
                    }
                  }
                },
              ),
      ),
    );
  }
}
