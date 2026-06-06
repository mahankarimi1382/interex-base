import 'package:get/get.dart';
import 'package:qrpaypro/views/navbar/dashboard_screen.dart';
import 'package:qrpaypro/views/navbar/notification_screen.dart';

class NavbarController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final List page = [
    DashboardScreen(),
    // TradeScreen(showAppBar: false),
    // MyChatScreen(showAppBar: false),
    NotificationScreen(),
  ];

  void selectedPage(int index) {
    selectedIndex.value = index;
  }
}
