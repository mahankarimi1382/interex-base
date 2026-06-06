
import '../../../../utils/basic_screen_imports.dart';
import '../../../../utils/responsive_layout.dart';
import '../controller/get_offer_controller.dart';
import 'get_offer_mobile_screen_layout.dart';


class GetOfferScreen extends StatelessWidget {
  GetOfferScreen({super.key});
  final controller = Get.put(GetOfferController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: GetOfferMobileScreenLayout(
        controller: controller,
      ),
    );
  }
}
