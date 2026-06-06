import 'package:qrpaypro/backend/utils/custom_loading_api.dart';
import 'package:qrpaypro/utils/basic_screen_imports.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';

import '../controller/trade_controller.dart';
import '../widget/top_buttons.dart';
import '../widget/trade_add_button.dart';
import '../widget/trades_list.dart';

class TradeScreen extends StatelessWidget {
  TradeScreen({super.key, this.showAppBar = true});

  final bool showAppBar;
  final controller = Get.put(TradeController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: !showAppBar ? null : const AppBarWidget(text: Strings.p2pTrade),
        body: Obx(
          () =>
              controller.isLoading ? CustomLoadingAPI() : _bodyWidget(context),
        ),
        floatingActionButton: TradeAddButton(),
      ),
    );
  }

  Padding _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingHorizontalSize * .7,
        vertical: Dimensions.paddingVerticalSize * .4,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          TopButtons(),
          verticalSpace(Dimensions.paddingVerticalSize * .6),
          TradesList(),
        ],
      ),
    );
  }

  //
  // void _openBottomSheet(BuildContext context) {
  //   controller.phoneNumberController.clear();
  //   controller.emailController.clear();
  //   controller.searchField.value = false;
  //
  //   showModalBottomSheet(
  //     // isDismissible: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         width: double.infinity,
  //         padding: EdgeInsets.symmetric(
  //             horizontal: Dimensions.paddingHorizontalSize * .6,
  //             vertical: Dimensions.paddingVerticalSize * .5),
  //         decoration: BoxDecoration(
  //             color: Theme.of(context).scaffoldBackgroundColor,
  //             borderRadius: BorderRadius.vertical(
  //                 top: Radius.circular(Dimensions.radius * 1.6))),
  //         child: Obx(() => Column(
  //               mainAxisSize: mainMin,
  //               crossAxisAlignment: crossStart,
  //               children: [
  //                 verticalSpace(Dimensions.paddingVerticalSize * .3),
  //                 Row(
  //                   children: [
  //                     TitleHeading2Widget(text: Strings.searchUser),
  //                     horizontalSpace(Dimensions.paddingHorizontalSize * .3),
  //                     Spacer(),
  //                     InkWell(
  //                       onTap: () {
  //                         controller.isEmail.value = !controller.isEmail.value;
  //                         controller.searchField.value = false;
  //                         controller.phoneNumberController.clear();
  //                         controller.emailController.clear();
  //                       },
  //                       borderRadius: BorderRadius.circular(Dimensions.radius),
  //                       child: Container(
  //                         height: Dimensions.buttonHeight * .7,
  //                         width: Dimensions.widthSize * 15,
  //                         decoration: BoxDecoration(
  //                             borderRadius:
  //                                 BorderRadius.circular(Dimensions.radius),
  //                             border: Border.all(
  //                                 color: CustomColor.primaryLightColor)),
  //                         child: Row(
  //                           mainAxisAlignment:
  //                               controller.isEmail.value ? mainStart : mainEnd,
  //                           children: [
  //                             controller.isEmail.value
  //                                 ? SizedBox.shrink()
  //                                 : Row(
  //                                     mainAxisAlignment: mainCenter,
  //                                     children: [
  //                                       TitleHeading5Widget(
  //                                         text: Strings.email,
  //                                         textAlign: TextAlign.center,
  //                                         color: CustomColor.primaryLightColor,
  //                                       ),
  //                                       horizontalSpace(10),
  //                                     ],
  //                                   ),
  //                             Container(
  //                               width: Dimensions.widthSize * 8,
  //                               height: Dimensions.buttonHeight * .7,
  //                               decoration: BoxDecoration(
  //                                 color: CustomColor.primaryLightColor,
  //                                 borderRadius: BorderRadius.horizontal(
  //                                   left: Radius.circular(
  //                                       !controller.isEmail.value
  //                                           ? 0
  //                                           : Dimensions.radius),
  //                                   right: Radius.circular(
  //                                       !controller.isEmail.value
  //                                           ? Dimensions.radius
  //                                           : 0),
  //                                 ),
  //                               ),
  //                               child: Column(
  //                                 mainAxisAlignment: mainCenter,
  //                                 children: [
  //                                   TitleHeading5Widget(
  //                                     text: controller.isEmail.value
  //                                         ? Strings.email
  //                                         : Strings.phone,
  //                                     textAlign: TextAlign.center,
  //                                     color: CustomColor.whiteColor,
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             !controller.isEmail.value
  //                                 ? SizedBox.shrink()
  //                                 : Row(
  //                                     mainAxisAlignment: mainCenter,
  //                                     children: [
  //                                       horizontalSpace(10),
  //                                       TitleHeading5Widget(
  //                                         text: Strings.phone,
  //                                         textAlign: TextAlign.center,
  //                                         color: CustomColor.primaryLightColor,
  //                                       ),
  //                                     ],
  //                                   ),
  //                           ],
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 verticalSpace(Dimensions.paddingVerticalSize * .3),
  //                 controller.isEmail.value
  //                     ? SizedBox.shrink()
  //                     : PrimaryInputWidget(
  //                         keyboardType: TextInputType.number,
  //                         onChanged: (value) {
  //                           if (value.toString().isNotEmpty &&
  //                               value.toString().length.isGreaterThan(4)) {
  //                             controller.searchField.value = true;
  //                             // if(!controller.isSearchLoading){
  //                             controller.userSearchApi();
  //                             // }
  //                           } else {
  //                             controller.searchField.value = false;
  //                           }
  //                         },
  //                         controller: controller.phoneNumberController,
  //                         hint: Strings.phoneNumber,
  //                         label: Strings.phoneNumber),
  //                 // verticalSpace(Dimensions.paddingVerticalSize * .3),
  //                 !controller.isEmail.value
  //                     ? SizedBox.shrink()
  //                     : PrimaryInputWidget(
  //                         keyboardType: TextInputType.emailAddress,
  //                         onChanged: (value) {
  //                           if (value.toString().isNotEmpty &&
  //                               GetUtils.isEmail(value.toString())) {
  //                             controller.searchField.value = true;
  //                             // if(!controller.isSearchLoading){
  //                             controller.userSearchApi();
  //                             // }
  //                           } else {
  //                             controller.searchField.value = false;
  //                           }
  //                         },
  //                         controller: controller.emailController,
  //                         hint: Strings.userEmail,
  //                         label: Strings.userEmail),
  //                 !controller.searchField.value
  //                     ? SizedBox.shrink()
  //                     : Column(
  //                         children: [
  //                           verticalSpace(Dimensions.paddingVerticalSize * .2),
  //                           TitleHeading5Widget(
  //                               color: controller.userFound.value
  //                                   ? Colors.green
  //                                   : Colors.orange,
  //                               text: controller.userFound.value
  //                                   ? controller
  //                                       .userSearchModel.message.success.first
  //                                   : Strings.userNotFound),
  //                           !controller.userFound.value
  //                               ? SizedBox.shrink()
  //                               : TitleHeading5Widget(
  //                                   color: Colors.green,
  //                                   text: controller.userSearchModel.data.name)
  //                         ],
  //                       ),
  //                 verticalSpace(Dimensions.paddingVerticalSize * .6),
  //                 PrimaryButton(title: Strings.startChat, onPressed: () {
  //                   if(controller.userFound.value){
  //                     controller.createChatApi();
  //                   }else{
  //                     CustomSnackBar.error(Strings.userNotFound);
  //                   }
  //                 }),
  //                 verticalSpace(Dimensions.paddingVerticalSize),
  //               ],
  //             )),
  //       );
  //     },
  //   );
  // }
}
