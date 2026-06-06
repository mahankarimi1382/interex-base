
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:qrpaypro/backend/utils/no_data_widget.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';

import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/animation/custom_listview_animation.dart';
import '../controller/get_offer_controller.dart';
import '../widget/get_offer_widget.dart';

class GetOfferMobileScreenLayout extends StatelessWidget {
  const GetOfferMobileScreenLayout({
    super.key,
    required this.controller,
  });

  final GetOfferController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: Strings.offer),
      body: Obx(
        () => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context),
      ),
    );
  }

  RefreshIndicator _bodyWidget(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        controller.getOffersProcessApi();
      },
      child: AnimationLimiter(
        child: controller.getOfferModel.data!.getoffers!.isEmpty
            ? NoDataWidget()
            : ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: List.generate(
                  controller.getOfferModel.data!.getoffers!.length,
                  (index) => CustomListViewAnimation(
                    index: index,
                    child: GetOfferWidget(
                      index: index,
                      getOffer: controller.getOfferModel.data!.getoffers![index]!,
                      imagePath: controller.getOfferModel.data!.imagepath!,
                      defaultImage: controller.getOfferModel.data!.defaultimage!,
                      controller: controller,
                    ),
                  ),
                ),
              ),
      ).paddingSymmetric(horizontal: Dimensions.marginSizeHorizontal * 0.8),
    );
  }
}
