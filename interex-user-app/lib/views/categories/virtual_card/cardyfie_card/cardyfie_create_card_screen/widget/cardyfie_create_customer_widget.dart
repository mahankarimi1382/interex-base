part of "../cardyfie_create_card_screen.dart";

class CreateCustomerWidget extends StatelessWidget {
  CreateCustomerWidget({super.key});
  final controller = Get.put(VirtualCardyfieCardController());
  // final profileController = Get.put(UpdateProfileController());
  final profileController = Get.put(UpdateProfileController());

  final basicDataController = Get.put(BasicDataController());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        verticalSpace(Dimensions.heightSize),
        Row(
          children: [
            Expanded(
              child: PrimaryTextInputWidget(
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkColor.withValues(alpha: .1)
                    : CustomColor.primaryLightColor.withValues(alpha: .1),
                controller: controller.firstNameController,
                hint: Strings.firstName,
                labelText: Strings.firstName,
              ),
            ),

            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryTextInputWidget(
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkColor.withValues(alpha: .1)
                    : CustomColor.primaryLightColor.withValues(alpha: .1),
                controller: controller.lastNameController,
                hint: Strings.lastName,
                labelText: Strings.lastName,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        PrimaryTextInputWidget(
          color: Get.isDarkMode
              ? CustomColor.primaryDarkColor.withValues(alpha: .1)
              : CustomColor.primaryLightColor.withValues(alpha: .1),
          controller: controller.emailController,
          hint: Strings.emailAddress,
          labelText: Strings.emailAddress,
        ),
        verticalSpace(Dimensions.heightSize),

        PrimaryTextInputWidget(
          color: Get.isDarkMode
              ? CustomColor.primaryDarkColor.withValues(alpha: .1)
              : CustomColor.primaryLightColor.withValues(alpha: .1),
          controller: controller.identifyNumberController,
          hint: Strings.identity,
          labelText: Strings.identity,
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
          },
          child: AbsorbPointer(
            child: PrimaryTextInputWidget(
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkColor.withValues(alpha: .1)
                  : CustomColor.primaryLightColor.withValues(alpha: .1),
              controller: controller.dateOfBirthController,
              // optionallabelText: Strings.shouldMatchYourID,
              labelText: Strings.dateOfBirth,
              hint: Strings.dateOfBirth,
              // isValidator: true,
            ),
          ),
        ),

        verticalSpace(Dimensions.heightSize),
        //dropdown select type
        CustomTitleHeadingWidget(
          text: Strings.identityType,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomColor.primaryLightTextColor,
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
        verticalSpace(Dimensions.heightSize),

        verticalSpace(Dimensions.heightSize),

        // image picker
        Row(
          children: [
            Expanded(
              child: SelectedImageWidget(
                labelName: Strings.IdCardImageFont,
                fieldName: "id_front_image",
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: SelectedImageWidget(
                labelName: Strings.IdCardImageBack,
                fieldName: "id_back_image",
              ),
            ),
          ],
        ),

        verticalSpace(Dimensions.heightSize),

        SelectedImageWidget(
          labelName: Strings.yourPhoto,
          fieldName: "user_image",
        ),

        verticalSpace(Dimensions.heightSize),
        PrimaryTextInputWidget(
          color: Get.isDarkMode
              ? CustomColor.primaryDarkColor.withValues(alpha: .1)
              : CustomColor.primaryLightColor.withValues(alpha: .1),
          controller: controller.houseNumberController,
          hint: Strings.houseNumber,
          labelText: Strings.houseNumber,
        ),
        verticalSpace(Dimensions.heightSize),
        CustomTitleHeadingWidget(
          text: Strings.country,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor
                : CustomColor.primaryLightTextColor,
          ),
        ),
        verticalSpace(Dimensions.heightSize),

        CustomCountryDropDown<Country>(
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
              child: PrimaryTextInputWidget(
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkColor.withValues(alpha: .1)
                    : CustomColor.primaryLightColor.withValues(alpha: .1),
                controller: controller.cityController,
                hint: Strings.city,
                labelText: Strings.city,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryTextInputWidget(
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkColor.withValues(alpha: .1)
                    : CustomColor.primaryLightColor.withValues(alpha: .1),
                controller: controller.stateController,
                hint: Strings.state,
                labelText: Strings.state,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        Row(
          children: [
            Expanded(
              child: PrimaryTextInputWidget(
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkColor.withValues(alpha: .1)
                    : CustomColor.primaryLightColor.withValues(alpha: .1),
                controller: controller.addressController,
                hint: Strings.address,
                labelText: Strings.address,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryTextInputWidget(
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkColor.withValues(alpha: .1)
                    : CustomColor.primaryLightColor.withValues(alpha: .1),
                controller: controller.zipcodeController,
                hint: Strings.zipCode,
                labelText: Strings.zipCode,
              ),
            ),
          ],
        ),

        _buttonWidget(context),
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
        () => controller.isCustomerCreateLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.submit,
                onPressed: () {
                  controller.customerCreateProcess();
                },
                borderColor: CustomColor.primaryLightColor,
                buttonColor: CustomColor.primaryLightColor,
              ),
      ),
    );
  }
}
