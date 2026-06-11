import 'dart:async';

import 'package:qrpay/backend/local_storage/local_storage.dart';
import 'package:qrpay/extentions/custom_extentions.dart';
import 'package:qrpay/utils/basic_screen_imports.dart';

import '../../backend/model/app_settings/app_settings_model.dart';
import '../../backend/services/api_services.dart';

class AppSettingsController extends GetxController {
  final List<OnboardScreen> onboardScreen = [];

  RxString splashImagePath = ''.obs;
  RxString appBasicLogoWhite = ''.obs;
  RxString appBasicLogoDark = ''.obs;
  RxString privacyPolicy = ''.obs;
  RxString contactUs = ''.obs;
  RxString aboutUs = ''.obs;
  RxString path = ''.obs;

  RxString baseUrl = ''.obs;

  RxBool isVisible = false.obs;
  @override
  void onInit() {
    getSplashAndOnboardData().then((value) {
      Timer(const Duration(seconds: 4), () {
        isVisible.value = true;
      });
    });
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  AppSettingsModel? _appSettingsModel;
  AppSettingsModel get appSettingsModel => _appSettingsModel!;

  Future<AppSettingsModel> getSplashAndOnboardData() async {
    _isLoading.value = true;
    update();

    await ApiServices.appSettingsApi()
        .then((value) {
          _appSettingsModel = value!;
          LocalStorage.saveFiatPrecision(
            value: _appSettingsModel!
                .data
                .appSettings
                .agent
                .basicSettings
                .fiatPrecisionValue,
          );
          LocalStorage.saveCryptoPrecision(
            value: _appSettingsModel!
                .data
                .appSettings
                .agent
                .basicSettings
                .cryptoPrecisionValue,
          );
          splashImagePath.value =
              "${_appSettingsModel!.data.baseUrl}/${_appSettingsModel!.data.screenImagePath}/${_appSettingsModel!.data.appSettings.agent.splashScreen.splashScreenImage}"
                  .fixHost();
          debugPrint(splashImagePath.value);
          for (var element
              in _appSettingsModel!.data.appSettings.agent.onboardScreen) {
            onboardScreen.add(
              OnboardScreen(
                id: element.id,
                title: element.title,
                subTitle: element.subTitle,
                image: element.image,
                status: element.status,
                createdAt: element.createdAt,
                updatedAt: element.updatedAt,
              ),
            );
          }
          baseUrl.value = _appSettingsModel!.data.baseUrl.fixHost();

          path.value =
              "${baseUrl.value}/${_appSettingsModel!.data.logoImagePath}/";

          if (_appSettingsModel!.data.appSettings.agent.basicSettings.siteLogo ==
              '') {
            appBasicLogoWhite.value =
                "${baseUrl.value}/${_appSettingsModel!.data.defaultImage}";
            appBasicLogoDark.value = appBasicLogoWhite.value;
          } else {
            appBasicLogoWhite.value =
                "${baseUrl.value}/${_appSettingsModel!.data.logoImagePath}/${_appSettingsModel!.data.appSettings.agent.basicSettings.siteLogo}";
            appBasicLogoDark.value =
                "${baseUrl.value}/${_appSettingsModel!.data.logoImagePath}/${_appSettingsModel!.data.appSettings.agent.basicSettings.siteLogoDark}";
          }

          Strings.appName =
              _appSettingsModel!.data.appSettings.agent.basicSettings.siteName;
          update();
          _isLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
          _isLoading.value = false;
        });
    _isLoading.value = false;
    update();
    return _appSettingsModel!;
  }
}
