import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrpay/utils/dimensions.dart';

class CustomLoadingAPI extends StatelessWidget {
  const CustomLoadingAPI({super.key, this.colors});
  final Color? colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: colors ?? Theme.of(context).primaryColor,
        size: Dimensions.heightSize * 2.6,
      ),
    );
  }
}
