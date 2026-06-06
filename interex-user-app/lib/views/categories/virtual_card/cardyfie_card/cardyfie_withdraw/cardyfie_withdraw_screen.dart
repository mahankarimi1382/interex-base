import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../backend/utils/custom_loading_api.dart';
import '../../../../../backend/utils/custom_snackbar.dart';

import '../../../../../utils/basic_screen_imports.dart';
import '../../../../../utils/responsive_layout.dart';
import '../../../../../widgets/appbar/appbar_widget.dart';
import '../../../../../widgets/payment_link/custom_drop_down.dart';
import '../../../../../widgets/text_labels/title_heading5_widget.dart';
import '../../../../set_up_pin/controller/set_up_pin_controller.dart';
import '../controller/cardyfie_info_controller.dart';
import '../controller/cardyfie_withdraw_controller.dart';
import '../model/my_card_model_cardyfie.dart';

part '../cardyfie_withdraw/widget/cardyfire_withdraw_keyboard_widget.dart';

class CardyfieWithdrawScreen extends StatelessWidget {
  CardyfieWithdrawScreen({super.key});
  final controller = Get.put(VirtualCardyfieCardController());
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.withdraw),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [CardyfieWithdrawFundWidget(buttonText: 'Withdraw')],
    );
  }
}
