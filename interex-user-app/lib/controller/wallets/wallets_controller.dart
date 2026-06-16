import 'package:get/get.dart';

import '../../backend/model/wallets/wallets_model.dart';
import '../../backend/services/api_services.dart';

class WalletsController extends GetxController {
  RxDouble exchangeRate = 0.0.obs;

  @override
  void onInit() {
    getWalletsInfoProcess();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  late WalletsModel _walletsInfoModel;

  WalletsModel get walletsInfoModel => _walletsInfoModel;
  /// Fetches the latest wallet balances.
  ///
  /// Pass [silent] = true for background refreshes (e.g. the dashboard polling
  /// loop) so the full-screen loader is NOT shown; the data still updates and
  /// listeners are notified via [update].
  Future<WalletsModel> getWalletsInfoProcess({bool silent = false}) async {
    if (!silent) {
      _isLoading.value = true;
      update();
    }

    await ApiServices.walletsInfoApi()
        .then((value) {
          if (value == null) return;
          _walletsInfoModel = value;
          double currencyRate = double.parse(
            _walletsInfoModel.data.userWallets.first.currency.rate,
          );
          exchangeRate.value = (currencyRate * currencyRate);

          if (!silent) _isLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
          if (!silent) _isLoading.value = false;
        });
    if (!silent) _isLoading.value = false;
    update();
    return _walletsInfoModel;
  }
}
