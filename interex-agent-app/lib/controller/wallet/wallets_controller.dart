import 'package:get/get.dart';

import '../../backend/model/wallet/wallets_model.dart';
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
  Future<WalletsModel> getWalletsInfoProcess() async {
    _isLoading.value = true;
    update();
    await ApiServices.walletsInfoApi()
        .then((value) {
          _walletsInfoModel = value!;
          final double currencyRate = double.parse(
            _walletsInfoModel.data.userWallets.first.currency.rate,
          );
          exchangeRate.value = (currencyRate * currencyRate);
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
    return _walletsInfoModel;
  }
}
