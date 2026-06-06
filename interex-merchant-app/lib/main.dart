// ignore_for_file: deprecated_member_use
// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qrpay/backend/utils/network_check/dependency_injection.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/strings.dart';
import 'backend/services/notification_service.dart';
import 'backend/utils/maintenance_dialog.dart';
import 'controller/app_settings/app_settings_controller.dart';
import 'language/language_controller.dart';
import 'utils/theme.dart';
import 'package:pusher_beams/pusher_beams.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  NotificationService.init();
  // Locking Device Orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  InternetCheckDependencyInjection.init();

  GetStorage.init();
  // main app
  runApp(const MyApp());
}

// This widget is the root of your application.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initPusherBeams();
    super.initState();
  }

 Future<void>  initPusherBeams() async {
    if (!kIsWeb) {
  await PusherBeams.instance.onInterestChanges(
    (interests) => {debugPrint('Interests: $interests')},
  );

  await PusherBeams.instance
      .onMessageReceivedInTheForeground(_onMessageReceivedInTheForeground);
    }
    await _checkForInitialMessage();
  }

  Future<void> _checkForInitialMessage() async {
    final initialMessage = await PusherBeams.instance.getInitialMessage();
    if (initialMessage != null) {}
  }

  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data) {
    NotificationService.showLocalNotificationPusher(
      title: data["title"].toString(),
      body: data["body"].toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (_, child) => GetMaterialApp(
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: Themes().theme,
        navigatorKey: Get.key,
        initialRoute: Routes.splashScreen,
        getPages: Routes.list,
        initialBinding: BindingsBuilder(() {
          Get.put(LanguageController());
          Get.put(AppSettingsController(), permanent: true);
          Get.put(SystemMaintenanceController());
        }),
        builder: (context, widget) {
          ScreenUtil.init(context);
          final languageController = Get.find<LanguageController>();
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (_) => Obx(
                  () => MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: Directionality(
                      textDirection: languageController.isLoading
                          ? TextDirection.ltr
                          : languageController.languageDirection,
                      child: widget!,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
