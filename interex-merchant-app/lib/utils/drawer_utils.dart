import 'package:qrpay/utils/strings.dart';

import '../custom_assets/assets.gen.dart';
import '../routes/routes.dart';

class DrawerUtils {
  static List items = [
    {
      'title': Strings.settings,
      'icon': Assets.icon.settings,
      'route': Routes.settingScreen,
    },
    {
      'title': Strings.helpCenter,
      'icon': Assets.icon.helpCenter,
      'route': Routes.helpCenterScreen,
    },
    {
      'title': Strings.privacyPolicy,
      'icon': Assets.icon.privacy,
      'route': Routes.privacyScreen,
    },
    {
      'title': Strings.aboutUs,
      'icon': Assets.icon.about,
      'route': Routes.aboutUsScreen,
    },
  ];
}
