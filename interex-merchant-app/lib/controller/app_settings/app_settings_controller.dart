import 'dart:async';

import 'package:get/get.dart';

import '../../backend/extentions/custom_extentions.dart';
import '../../backend/local_storage/local_storage.dart';
import '../../backend/model/app_settings/app_settings_model.dart';
import '../../backend/services/api_services.dart';
import '../../utils/strings.dart';

class AppSettingsController extends GetxController {
  final List<OnboardScreen> onboardScreen = [];

  RxString splashImagePath = ''.obs;
  RxString appBasicLogoWhite = ''.obs;
  RxString appBasicLogoDark = ''.obs;
  RxString privacyPolicy = ''.obs;
  RxString contactUs = ''.obs;
  RxString aboutUs = ''.obs;
  RxString path = ''.obs;
  RxInt cryptoValue = 8.obs;
  RxInt fiatValue = 2.obs;
  RxBool isVisible = false.obs;
  RxString baseUrl = ''.obs;
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
  AppSettingsModel? get appSettingsModel => _appSettingsModel;

  Future<AppSettingsModel?> getSplashAndOnboardData() async {
    _isLoading.value = true;
    update();

    await ApiServices.appSettingsApi()
        .then((value) {
          final model = value!;
          _appSettingsModel = model;
          baseUrl.value = model.data.baseUrl.resolveBackendHost();
          splashImagePath.value =
              "${baseUrl.value}/${model.data.screenImagePath}/${model.data.appSettings.merchant.splashScreen.splashScreenImage}";

          for (var element
              in model.data.appSettings.merchant.onboardScreen) {
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

          path.value = "${baseUrl.value}/${model.data.logoImagePath}/";

          if (model.data.appSettings.merchant.basicSettings.siteLogo == '') {
            appBasicLogoWhite.value =
                "${baseUrl.value}/${model.data.defaultImage}";
            appBasicLogoDark.value = appBasicLogoWhite.value;
          } else {
            appBasicLogoWhite.value =
                "${baseUrl.value}/${model.data.logoImagePath}/${model.data.appSettings.merchant.basicSettings.siteLogo}";
            appBasicLogoDark.value =
                "${baseUrl.value}/${model.data.logoImagePath}/${model.data.appSettings.merchant.basicSettings.siteLogoDark}";
          }
          final data = model.data.appSettings.merchant.basicSettings;
          cryptoValue.value = data.cryptoPrecisionValue;
          fiatValue.value = data.fiatPrecisionValue;
          Strings.appName =
              model.data.appSettings.merchant.basicSettings.siteName;

          LocalStorages.saveFiatPrecision(
            value: model
                .data
                .appSettings
                .merchant
                .basicSettings
                .fiatPrecisionValue,
          );
          LocalStorages.saveCryptoPrecision(
            value: model
                .data
                .appSettings
                .merchant
                .basicSettings
                .cryptoPrecisionValue,
          );
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
    return _appSettingsModel;
  }
}
