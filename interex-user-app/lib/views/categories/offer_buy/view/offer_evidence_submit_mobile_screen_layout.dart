import 'package:qrpaypro/backend/utils/custom_loading_api.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';

import '../../../../utils/basic_screen_imports.dart';
import '../../get_offer/controller/offer_buy_preview_controller.dart';

class OfferEvidenceMobileScreenLayout extends StatelessWidget {
  OfferEvidenceMobileScreenLayout({super.key, required this.controller});

  final OfferBuyPreviewController controller;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: Strings.evidenceNote),
      body: _bodyWidget(context),
    );
  }

  Padding _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize * 0.7,
        vertical: Dimensions.paddingSize * 0.7,
      ),
      child: Form(
        key: formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ...controller.inputFields.map((element) {
              return element;
            }),
            _buttonWidget(context),
          ],
        ),
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical),
      child: Obx(
        () => controller.isSubmitLoading
            ? CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.submit,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.onSubmit;
                  }
                },
              ),
      ),
    );
  }
}
