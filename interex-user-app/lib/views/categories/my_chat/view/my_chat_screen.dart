import 'package:intl/intl.dart';
import 'package:qrpaypro/backend/utils/custom_loading_api.dart';
import 'package:qrpaypro/utils/basic_screen_imports.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';

import '../../../../backend/utils/custom_snackbar.dart';
import '../../../../routes/routes.dart';
import '../../../../widgets/text_labels/title_heading5_widget.dart';
import '../controller/my_chat_controller.dart';

class MyChatScreen extends StatelessWidget {
  MyChatScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  final controller = Get.put(MyChatController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: !showAppBar ? null : const AppBarWidget(text: Strings.myChat),
        body: Obx(
          () => (controller.isLoading || controller.isCreateLoading)
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),

        floatingActionButton: !showAppBar
            ? null
            : Obx(
                () => Visibility(
                  visible: !controller.isLoading,
                  child: FloatingActionButton(
                    elevation: 3,
                    backgroundColor: CustomColor.primaryLightColor,
                    shape: const CircleBorder(),
                    onPressed: () {
                      _openBottomSheet(context);
                    },
                    child: Icon(
                      Icons.add,
                      size: Dimensions.iconSizeLarge,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Column _bodyWidget(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView.separated(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSize * 0.6,
                ),
                shrinkWrap: true,
                itemCount: controller.userList.length,
                itemBuilder: (context, index) {
                  var user = controller.userList[index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.chatScreen, arguments: [user]);
                    },
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 1.2,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingHorizontalSize * .4,
                        vertical: Dimensions.paddingVerticalSize * .3,
                      ),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? CustomColor.whiteColor.withValues(alpha: .05)
                            : CustomColor.whiteColor,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius * 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              user.senderImage.image,
                            ),
                          ),
                          horizontalSpace(
                            Dimensions.paddingHorizontalSize * .3,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: crossStart,
                              children: [
                                TitleHeading3Widget(
                                  text: user.senderImage.fullname,
                                ),
                                TitleHeading4Widget(
                                  text: user.senderImage.email,
                                ),
                              ],
                            ),
                          ),
                          horizontalSpace(
                            Dimensions.paddingHorizontalSize * .3,
                          ),
                          Column(
                            crossAxisAlignment: crossEnd,
                            children: [
                              TitleHeading5Widget(
                                text: DateFormat(
                                  'hh:mm a',
                                ).format(user.updatedAt),
                              ),
                              TitleHeading5Widget(
                                text: DateFormat(
                                  'dd MMMM, yyyy',
                                ).format(user.updatedAt),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, i) =>
                    verticalSpace(Dimensions.paddingVerticalSize * .4),
              ),

              Obx(
                () => controller.isMoreLoading
                    ? const CustomLoadingAPI()
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openBottomSheet(BuildContext context) {
    controller.phoneNumberController.clear();
    controller.emailController.clear();
    controller.searchField.value = false;

    showModalBottomSheet(
      // isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingHorizontalSize * .6,
              vertical: Dimensions.paddingVerticalSize * .5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius * 1.6),
              ),
            ),
            child: Obx(
              () => Column(
                mainAxisSize: mainMin,
                crossAxisAlignment: crossStart,
                children: [
                  verticalSpace(Dimensions.paddingVerticalSize * .3),
                  Row(
                    children: [
                      TitleHeading2Widget(text: Strings.searchUser),
                      horizontalSpace(Dimensions.paddingHorizontalSize * .3),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          controller.isEmail.value = !controller.isEmail.value;
                          controller.searchField.value = false;
                          controller.phoneNumberController.clear();
                          controller.emailController.clear();
                        },
                        borderRadius: BorderRadius.circular(Dimensions.radius),
                        child: Container(
                          height: Dimensions.buttonHeight * .7,
                          width: Dimensions.widthSize * 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius,
                            ),
                            border: Border.all(
                              color: CustomColor.primaryLightColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: controller.isEmail.value
                                ? mainStart
                                : mainEnd,
                            children: [
                              controller.isEmail.value
                                  ? SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment: mainCenter,
                                      children: [
                                        TitleHeading5Widget(
                                          text: Strings.email,
                                          textAlign: TextAlign.center,
                                          color: CustomColor.primaryLightColor,
                                        ),
                                        horizontalSpace(10),
                                      ],
                                    ),
                              Container(
                                width: Dimensions.widthSize * 8,
                                height: Dimensions.buttonHeight * .7,
                                decoration: BoxDecoration(
                                  color: CustomColor.primaryLightColor,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(
                                      !controller.isEmail.value
                                          ? 0
                                          : Dimensions.radius,
                                    ),
                                    right: Radius.circular(
                                      !controller.isEmail.value
                                          ? Dimensions.radius
                                          : 0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: mainCenter,
                                  children: [
                                    TitleHeading5Widget(
                                      text: controller.isEmail.value
                                          ? Strings.email
                                          : Strings.phone,
                                      textAlign: TextAlign.center,
                                      color: CustomColor.whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                              !controller.isEmail.value
                                  ? SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment: mainCenter,
                                      children: [
                                        horizontalSpace(10),
                                        TitleHeading5Widget(
                                          text: Strings.phone,
                                          textAlign: TextAlign.center,
                                          color: CustomColor.primaryLightColor,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(Dimensions.paddingVerticalSize * .3),
                  controller.isEmail.value
                      ? SizedBox.shrink()
                      : PrimaryInputWidget(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.toString().isNotEmpty &&
                                value.toString().length.isGreaterThan(4)) {
                              controller.searchField.value = true;
                              // if(!controller.isSearchLoading){
                              controller.userSearchApi();
                              // }
                            } else {
                              controller.searchField.value = false;
                            }
                          },
                          controller: controller.phoneNumberController,
                          hint: Strings.phoneNumber,
                          label: Strings.phoneNumber,
                        ),
                  // verticalSpace(Dimensions.paddingVerticalSize * .3),
                  !controller.isEmail.value
                      ? SizedBox.shrink()
                      : PrimaryInputWidget(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            if (value.toString().isNotEmpty &&
                                GetUtils.isEmail(value.toString())) {
                              controller.searchField.value = true;
                              // if(!controller.isSearchLoading){
                              controller.userSearchApi();
                              // }
                            } else {
                              controller.searchField.value = false;
                            }
                          },
                          controller: controller.emailController,
                          hint: Strings.userEmail,
                          label: Strings.userEmail,
                        ),
                  !controller.searchField.value
                      ? SizedBox.shrink()
                      : Column(
                          children: [
                            verticalSpace(Dimensions.paddingVerticalSize * .2),
                            TitleHeading5Widget(
                              color: controller.userFound.value
                                  ? Colors.green
                                  : Colors.orange,
                              text: controller.userFound.value
                                  ? controller
                                        .userSearchModel
                                        .message
                                        .success
                                        .first
                                  : Strings.userNotFound,
                            ),
                            !controller.userFound.value
                                ? SizedBox.shrink()
                                : TitleHeading5Widget(
                                    color: Colors.green,
                                    text: controller.userSearchModel.data.name,
                                  ),
                          ],
                        ),
                  verticalSpace(Dimensions.paddingVerticalSize * .6),
                  PrimaryButton(
                    title: Strings.startChat,
                    onPressed: () {
                      if (controller.userFound.value) {
                        controller.createChatApi();
                      } else {
                        CustomSnackBar.error(Strings.userNotFound);
                      }
                    },
                  ),
                  verticalSpace(Dimensions.paddingVerticalSize),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
