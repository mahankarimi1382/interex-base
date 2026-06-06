import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../controller/trade_controller.dart';

class TopButtons extends StatelessWidget {
  TopButtons({super.key});

  final controller = Get.find<TradeController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            title: Strings.marketplace,
            onPressed: () {
              Get.toNamed(Routes.marketplaceScreen);
            },
          ),
        ),
        horizontalSpace(Dimensions.paddingHorizontalSize * .4),
        Expanded(
          child: PrimaryButton(
            title: Strings.getOffer,
            onPressed: () {
              Get.toNamed(Routes.getOfferScreen);
            },
          ),
        ),
      ],
    );
  }
}
