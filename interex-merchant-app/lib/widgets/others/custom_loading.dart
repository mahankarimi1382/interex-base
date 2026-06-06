import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/dimensions.dart';


class CustomSwitchLoading extends StatelessWidget {
  const CustomSwitchLoading({
    super.key,
    this.color = Colors.white,
  });
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: color,
        size: Dimensions.heightSize * 2.1,
      ),
    );
  }
}
