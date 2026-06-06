import '../../language/english.dart';
import '../custom_assets/assets.gen.dart';
import '../routes/routes.dart';

class DrawerUtils {
  static List items = [
    {
      'title': Strings.wallets,
      'icon': Assets.icon.wallet,
      'route': Routes.walletScreen,
    },
    {
      'title': Strings.transactionLog,
      'icon': Assets.icon.tLog,
      'route': Routes.transactionLogScreen,
    },
    {
      'title': Strings.mySenders,
      'icon': Assets.icon.userRecipient,
      'route': Routes.mySenderRecipientScreen,
    },
    {
      'title': Strings.recipients,
      'icon': Assets.icon.recipientsIcon,
      'route': Routes.saveRecipientScreen,
    },
    {
      'title': Strings.moneyExchange,
      'icon': Assets.icon.requestMoney,
      'route': Routes.moneyExchange,
    },
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
