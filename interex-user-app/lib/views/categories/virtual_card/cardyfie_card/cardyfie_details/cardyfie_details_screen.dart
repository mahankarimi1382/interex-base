import '../../../../../backend/utils/custom_loading_api.dart';
import '../../../../../utils/basic_screen_imports.dart';
import '../../../../../utils/custom_switch_loading_api.dart';
import '../../../../../utils/responsive_layout.dart';
import '../../../../../widgets/appbar/appbar_widget.dart';
import '../../../../../widgets/text_labels/title_heading5_widget.dart';
import '../controller/cardyfie_details_controller.dart';

part '../cardyfie_details/widget/address_widget_cardyfie.dart';
part '../cardyfie_details/widget/details_widget.dart';

class CardyfieDetailsScreen extends StatelessWidget {
  CardyfieDetailsScreen({super.key});
  final controller = Get.put(CardyfieDetailsController());
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        // backgroundColor: CustomColor.blackColor,
        appBar: const AppBarWidget(text: Strings.details),

        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Padding _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.9),
      child: SingleChildScrollView(
        child: Column(
          children: [AddressWidgetCardyfie(), CardyfieDetailsWidget()],
        ),
      ),
    );
  }
}
