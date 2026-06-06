import '../../../../utils/basic_screen_imports.dart';
import '../../../../utils/responsive_layout.dart';
import '../controller/make_counter_offer_controller.dart';
import 'make_counter_mobile_screen_layout.dart';

class MakeCounterOfferScreen extends StatelessWidget {
  MakeCounterOfferScreen({super.key});

  final controller = Get.put(MakeCounterOfferController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: MakeCounterOfferMobileScreenLayout(
        controller: controller,
      ),
    );
  }
}
