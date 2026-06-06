import '../../../../utils/basic_screen_imports.dart';
import '../../../../utils/responsive_layout.dart';
import '../../get_offer/controller/offer_buy_preview_controller.dart';
import 'offer_evidence_submit_mobile_screen_layout.dart';

class OfferEvidenceSubmitScreen extends StatelessWidget {
  OfferEvidenceSubmitScreen({super.key});
  final controller = Get.put(OfferBuyPreviewController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: OfferEvidenceMobileScreenLayout(controller: controller),
    );
  }
}
