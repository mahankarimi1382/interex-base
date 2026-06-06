import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../backend/utils/custom_loading_api.dart';
import '../../../../../backend/utils/custom_snackbar.dart';
import '../../../../../controller/navbar/dashboard_controller.dart';
import '../../../../../custom_assets/assets.gen.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/basic_screen_imports.dart';
import '../../../../../widgets/text_labels/title_heading5_widget.dart';
import '../../../../others/custom_image_widget.dart';
import '../cardyfie_details/widget/custom_switch_loading_api.dart';
import '../controller/cardyfie_info_controller.dart';

part '../widget/card_widget.dart';
part '../widget/cardyfie_card_slider.dart';
part '../widget/cardyfie_category_widget.dart';
part '../widget/categorie_widget.dart';

class CardyfieCardScreen extends StatelessWidget {
  const CardyfieCardScreen({super.key, required this.controller});
  final VirtualCardyfieCardController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? const CustomLoadingAPI()
          : _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return _cardyfieCardWidget(context);
  }

  Column _cardyfieCardWidget(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius * 2),
            color: CustomColor.primaryLightColor,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeHorizontal * 0.8,
            vertical: Dimensions.marginSizeVertical * 0.4,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSize * 0.4,
            vertical: Dimensions.paddingSize * 0.4,
          ),
          child: Column(
            mainAxisAlignment: mainCenter,
            mainAxisSize: mainMin,
            children: [CardyfieCardSlider(), CardyfieCategoryWidget()],
          ),
        ),
        _buttonWidget(context),
      ],
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 2,
        horizontal: Dimensions.marginSizeHorizontal * 0.8,
      ),
      child: PrimaryButton(
        borderColor: Get.isDarkMode
            ? CustomColor.primaryDarkColor
            : CustomColor.primaryLightColor,
        buttonColor: Get.isDarkMode
            ? CustomColor.primaryDarkColor
            : CustomColor.primaryLightColor,

        title: Strings.createANewCard,
        onPressed: () {
          Get.toNamed(Routes.crateCardyfieScreen);
        },
      ),
    );
  }
}
