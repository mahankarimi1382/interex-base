import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../controller/trade_controller.dart';

class TradeAddButton extends StatelessWidget {
  TradeAddButton({super.key});

  final controller = Get.find<TradeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !controller.isLoading,
        child: FloatingActionButton(
          elevation: 3,
          backgroundColor: CustomColor.primaryLightColor,
          shape: const CircleBorder(),
          onPressed: () {
            Get.toNamed(Routes.tradeSubmitScreen);
          },
          child: Icon(
            Icons.add,
            size: Dimensions.iconSizeLarge,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
