import 'package:intl/intl.dart';
import 'package:qrpaypro/views/categories/virtual_card/cardyfie_card/model/country_model.dart';

import '../../../../../backend/utils/custom_loading_api.dart';
import '../../../../../controller/profile/update_profile_controller.dart';
import '../../../../../utils/basic_screen_imports.dart';
import '../../../../../widgets/appbar/appbar_widget.dart';
import '../../../../../widgets/inputs/custom_country_drop_down.dart';
import '../cardyfie_create_card_screen/widget/kyc_dynamic_dropdown.dart';
import '../cardyfie_create_card_screen/widget/selected_image_widget.dart';
import '../controller/cardyfie_update_customer_controller.dart';

class UpdateCustomerScreen extends StatelessWidget {
  UpdateCustomerScreen({super.key});
  final controller = Get.put(UpdateCustomerCardyfieController());
  final profileController = Get.put(UpdateProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: Strings.updateCustomer),
      body: Obx(
        () => controller.isCreateCardInfoLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context),
      ),
    );
  }

  Padding _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: crossStart,
          children: [_inputWidget(context), _buttonWidget(context)],
        ),
      ),
    );
  }

  Column _inputWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        verticalSpace(Dimensions.heightSize),
        Row(
          children: [
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.firstNameController,
                hint: Strings.firstName,
                label: Strings.firstName,
              ),
            ),

            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.lastNameController,
                hint: Strings.lastName,
                label: Strings.lastName,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        PrimaryInputWidget(
          readOnly: true,
          controller: controller.emailController,
          hint: Strings.emailAddress,
          label: Strings.emailAddress,
        ),
        verticalSpace(Dimensions.heightSize),

        PrimaryInputWidget(
          controller: controller.identifyNumberController,
          hint: Strings.identity,
          label: Strings.identity,
          keyboardType: TextInputType.number,
        ),
        verticalSpace(Dimensions.heightSize),
        PrimaryInputWidget(
          controller: controller.houseNumberController,
          hint: Strings.houseNumber,
          keyboardType: TextInputType.number,
          label: Strings.houseNumber,
        ),
        verticalSpace(Dimensions.heightSize),
        CustomTitleHeadingWidget(
          text: Strings.country,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.6)
                : CustomColor.primaryLightTextColor,
          ),
        ),
        verticalSpace(Dimensions.heightSize),

        CustomCountryDropDown<Country>(
          dropDownHeight: Dimensions.heightSize * 3.5,
          hintTitle: profileController.countries.first.name,
          // isShowCountryCode: true,
          isShowImage: true,
          flag: profileController.countries.first.flag.toLowerCase(),
          items: profileController.countries,
          onChanged: (v) {
            controller.selectedCountry.value = v!.name;
            controller.countryISO2.value = v.iso2;
          },
        ),

        verticalSpace(Dimensions.heightSize),

        Row(
          children: [
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.cityController,
                hint: Strings.city,
                label: Strings.city,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.stateController,
                hint: Strings.state,
                label: Strings.state,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        Row(
          children: [
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.addressController,
                hint: Strings.address,
                label: Strings.address,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.zipcodeController,
                hint: Strings.zipCode,
                label: Strings.zipCode,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),

        //date of birth
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(1930),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              final DateFormat formatter = DateFormat('MM/dd/yyyy');
              final String formattedDate = formatter.format(pickedDate);

              controller.dateOfBirthController.text = formattedDate;
            }

            print(controller.dateOfBirthController.text);
          },
          child: AbsorbPointer(
            child: PrimaryInputWidget(
              controller: controller.dateOfBirthController,
              optionalLabel: Strings.shouldMatchYourID,
              label: Strings.dateOfBirth,
              hint: Strings.dateOfBirth,
              isValidator: true,
            ),
          ),
        ),
        verticalSpace(Dimensions.heightSize),
        //dropdown select type
        CustomTitleHeadingWidget(
          text: Strings.identityType,
          style: CustomStyle.lightHeading4TextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.6)
                : CustomColor.primaryLightTextColor,
          ),
        ),
        SizedBox(height: Dimensions.marginBetweenInputTitleAndBox),
        KycDynamicDropDown(
          selectMethod: controller.selectTypeName,
          itemsList: controller.identityList.map((e) => e['name']!).toList(),
          onChanged: (value) {
            // Set name
            controller.selectTypeName.value = value!;

            // Find and set slug
            final selectedItem = controller.identityList.firstWhere(
              (item) => item['name'] == value,
            );
            controller.selectTypeSlug.value = selectedItem['slug']!;
          },
        ),

        verticalSpace(Dimensions.heightSize * 1.2),

        // image picker
        Row(
          children: [
            Expanded(
              child: SelectedImageWidget(
                //  getImage: controller.fontImage.value ,
                imageUrl: controller.fontImage.value,

                labelName: Strings.IdCardImageFont,
                fieldName: "id_front_image",
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: SelectedImageWidget(
                // getImage: controller.backImage.value ,
                imageUrl: controller.backImage.value,

                labelName: Strings.IdCardImageBack,
                fieldName: "id_back_image",
              ),
            ),
          ],
        ),

        verticalSpace(Dimensions.heightSize * 1.3),

        SelectedImageWidget(
          imageUrl: controller.userPhoto.value,
          labelName: Strings.yourPhoto,
          fieldName: "user_image",
        ),
      ],
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.paddingSize * 1.4,
        bottom: Dimensions.paddingSize * 4.8,
      ),
      child: Obx(
        () => controller.isConfirmLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.submit,
                onPressed: () {
                  print(controller.listFieldName);
                  print(controller.listImagePath);

                  controller.updateCustomerKyc();
                },
                borderColor: CustomColor.primaryLightColor,
                buttonColor: CustomColor.primaryLightColor,
              ),
      ),
    );
  }
}
