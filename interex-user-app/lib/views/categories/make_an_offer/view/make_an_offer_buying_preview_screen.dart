import '../../../../utils/basic_screen_imports.dart';
import '../../../../utils/responsive_layout.dart';
import '../controller/make_an_offer_controller.dart';
import 'make_an_offer_mobile_screen_layout.dart';

class MakeAnOfferBuyingPreviewScreen extends StatelessWidget {
  MakeAnOfferBuyingPreviewScreen({super.key});
  final controller = Get.put(MakeAnOfferController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: MakeAnOfferPreviewMobileScreenLayout(
        controller: controller,
      ),
    );
  }
}
