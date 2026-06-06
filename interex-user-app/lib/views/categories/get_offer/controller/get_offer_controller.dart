import '../../../../utils/basic_screen_imports.dart';
import '../../market_place/controller/marketplace_buying_preview_controller.dart';
import '../model/get_offer_model.dart';
import '../service/get_offer_api_services.dart';

class GetOfferController extends GetxController {
  ///  >>> get marketplace buy controller
  final controller = Get.put(MarketplaceBuyingPreviewController());

  /// >>> get offer information
  @override
  void onInit() {
    getOffersProcessApi().then((value) => debugPrint('Process success'));
    super.onInit();
  }

  /// >> set loading process & Model
  final _isLoading = false.obs;
  late GetOfferModel _getOfferModel;

  /// >> get loading process & Model
  bool get isLoading => _isLoading.value;
  GetOfferModel get getOfferModel => _getOfferModel;

  ///* get offer info api process
  Future<GetOfferModel> getOffersProcessApi() async {
    _isLoading.value = true;
    update();

    await OfferApiServices.getOfferApiProcess()
        .then((value) {
          _getOfferModel = value!;

          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _getOfferModel;
  }
}
