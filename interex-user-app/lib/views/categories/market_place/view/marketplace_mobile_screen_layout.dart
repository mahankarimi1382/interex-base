// ignore_for_file: prefer_const_constructors

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';

import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/animation/custom_listview_animation.dart';
import '../controller/marketplace_controller.dart';
import '../widget/marketplace_widget.dart';

class MarketplaceMobileScreenLayout extends StatelessWidget {
  MarketplaceMobileScreenLayout({super.key, required this.controller});

  final MarketplaceController controller;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: Strings.marketplace),
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
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await controller.marketplaceInfoGetProcessApi();
      },
      child: AnimationLimiter(
        child: controller.userList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: mainCenter,
                  children: [
                    TitleHeading3Widget(text: Strings.noTradeFound),
                    verticalSpace(Dimensions.heightSize),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        controller.marketplaceInfoGetProcessApi();
                      },
                      child: Icon(
                        Icons.replay_outlined,
                        color: CustomColor.blackColor,
                      ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  ListView.separated(
                    controller: controller.scrollController,
                    padding: EdgeInsets.only(
                      top: Dimensions.paddingVerticalSize * .5,
                    ),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: controller.userList.length,
                    separatorBuilder: (_, i) => verticalSpace(0),
                    itemBuilder: (context, index) {
                      return CustomListViewAnimation(
                        index: index,
                        child: MarketplaceWidget(
                          data: controller.userList[index],
                          index: index,
                        ),
                      );
                    },
                  ),
                  Obx(
                    () => controller.isMoreLoading
                        ? const CustomLoadingAPI()
                        : const SizedBox(),
                  ),
                ],
              ),
      ),
    );
  }
}
