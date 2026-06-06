import '../../../../utils/basic_screen_imports.dart';
import '../../../../utils/responsive_layout.dart';
import '../controller/marketplace_controller.dart';
import 'marketplace_mobile_screen_layout.dart';

class MarketplaceScreen extends StatelessWidget {
  MarketplaceScreen({super.key});
  final controller = Get.put(MarketplaceController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: MarketplaceMobileScreenLayout(controller: controller),
    );
  }
}
