// import 'dart:async';
//
// import 'package:get/get.dart';
//
// import '../../backend/local_storage/local_storage.dart';
// import '../../language/language_controller.dart';
// import '../../routes/routes.dart';
//
// final languageController = Get.find<LanguageController>();
//
// class SplashController extends GetxController {
//   @override
//   void onReady() async {
//     super.onReady();
//     _goToScreen();
//   }
//
//   _goToScreen() async {
//     Timer(
//       const Duration(seconds: 6),
//       () {
//         if (!languageController.isLoading) {
//           LocalStorage.isLoggedIn()
//               ? Get.offAndToNamed(Routes.signInScreen)
//               : Get.offAndToNamed(
//                   LocalStorage.isOnBoardDone()
//                       ? Routes.signInScreen
//                       : Routes.onboardScreen,
//                 );
//         }
//       },
//     );
//   }
// }
import 'package:get/get.dart';

import '../../backend/local_storage/local_storage.dart';
import '../../backend/services/navigator_plug.dart';
import '../../routes/routes.dart';


class SplashController extends GetxController {
  final navigatorPlug = NavigatorPlug();

  @override
  void onReady() {
    super.onReady();
    navigatorPlug.startListening(
        seconds: 3,
        onChanged: () {
          LocalStorage.isLoggedIn()
              ? Get.offAndToNamed(Routes.signInScreen)
              : Get.offAndToNamed(
            LocalStorage.isOnBoardDone()
                ? Routes.signInScreen
                : Routes.onboardScreen,
          );
        }

    );
  }

  @override
  void onClose() {
    navigatorPlug.stopListening();
    super.onClose();
  }
}
