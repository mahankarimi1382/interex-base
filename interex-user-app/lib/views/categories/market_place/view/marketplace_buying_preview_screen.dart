
import '../../../../utils/basic_screen_imports.dart';
import '../../../../utils/responsive_layout.dart';
import '../controller/marketplace_buying_preview_controller.dart';
import 'marketplace_buying_preview_mobile_screen_layout.dart';


class MarketplaceBuyingPreviewScreen extends StatelessWidget {
  MarketplaceBuyingPreviewScreen({super.key});
  final controller = Get.put(MarketplaceBuyingPreviewController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: MarketplaceBuyingPreviewMobileScreenLayout(
        controller: controller,
      ),
    );
  }
}
