import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'basic_screen_imports.dart';

class CustomSwitchLoading extends StatelessWidget {
  const CustomSwitchLoading({
    super.key,
    this.color = Colors.white,
  });
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: color,
        size: Dimensions.heightSize * 2.1,
      ),
    );
  }
}
