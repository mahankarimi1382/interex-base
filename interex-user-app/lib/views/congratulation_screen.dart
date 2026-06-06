import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/dimensions.dart';
import '../../custom_assets/assets.gen.dart';
import '../../language/english.dart';
import '../../utils/size.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/text_labels/title_subtitle_widget.dart';

class CongratulationScreen extends StatelessWidget {
  const CongratulationScreen({
    super.key,
    required this.title,
    required this.subTitle,
    required this.route,
  });
  final String title, subTitle, route;
  @override
  Widget build(BuildContext context) {
    Future<bool> willPop() {
      Get.offNamedUntil(route, (route) => false);
      return Future.value(true);
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(body: _bodyWidget(context)),
    );
  }

  // body widget containing all widget elements
  SizedBox _bodyWidget(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _congratulationImageWidget(context),
          verticalSpace(Dimensions.heightSize * 2),
          _congratulationInfoWidget(context),
          verticalSpace(Dimensions.heightSize * 1.33),
          _buttonWidget(context),
        ],
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.marginSizeHorizontal),
      child: PrimaryButton(
        title: Strings.okay,
        onPressed: () {
          Get.offNamedUntil(route, (route) => false);
        },
      ),
    );
  }

  SvgPicture _congratulationImageWidget(BuildContext context) {
    return SvgPicture.asset(Assets.clipart.confirmation);
  }

  Container _congratulationInfoWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.marginSizeHorizontal),
      child: Column(
        children: [
          TitleSubTitleWidget(
            title: title,
            subtitle: subTitle,
            crossAxisAlignment: crossCenter,
          ),
        ],
      ),
    );
  }
}
