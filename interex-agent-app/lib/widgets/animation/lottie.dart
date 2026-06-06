import 'package:lottie/lottie.dart';

import '../../utils/basic_screen_imports.dart';

class LottieAnimation extends StatelessWidget {
  const LottieAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.paddingSize * 2),
      child: Lottie.asset(
        'assets/animation/no_history.json',
      ),
    );
  }
}
