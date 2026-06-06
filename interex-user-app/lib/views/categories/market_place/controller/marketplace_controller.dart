import '../../../../utils/basic_screen_imports.dart';
import '../model/marketplace_info_model.dart';
import '../service/marketplace_api_services.dart';

class MarketplaceController extends GetxController {
  // final currency = Get.put(CurrencyController());
  RxDouble amount = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxBool isFilter = false.obs;
  @override
  void onInit() {
    marketplaceInfoGetProcessApi();

    /// =>> Pagination
    scrollController = ScrollController()..addListener(scrollListener);
    super.onInit();
  }

  // controller: controller.scrollController, ///=> Call It On ListView controller
  late ScrollController scrollController;
  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      debugPrint('Scrolled to the bottom');
      marketplaceInfoMoreApi();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final _isLoading = false.obs;
  late MarketplaceInfoModel _marketplaceInfoModel;

  bool get isLoading => _isLoading.value;
  MarketplaceInfoModel get marketplaceInfoModel => _marketplaceInfoModel;

  final _isMoreLoading = false.obs;
  bool get isMoreLoading => _isMoreLoading.value;

  int page = 1;
  RxBool hasNextPage = true.obs;
  RxList<Datum> userList = <Datum>[].obs;

  Future<MarketplaceInfoModel> marketplaceInfoGetProcessApi() async {
    userList.clear();
    hasNextPage.value = true;
    page = 1;

    _isLoading.value = true;
    update();
    await MarketplaceApiServices.getMarketplaceProcessApi(
          amount.toString(),
          rate.toString(),
          "",
          isFilter: isFilter.value,
          page: page.toString(),
        )
        .then((value) {
          _marketplaceInfoModel = value!;

          if (_marketplaceInfoModel.data.trads.lastPage > 1) {
            hasNextPage.value = true;
          } else {
            hasNextPage.value = false;
          }

          userList.addAll(_marketplaceInfoModel.data.trads.data);

          // if (LocalStorage.getDeepLink()) {
          //   onResetFilterValue();
          //   Routes.filterItemsScreen.offAllNamed;
          // }
          onResetFilterValue();
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _marketplaceInfoModel;
  }

  Future<MarketplaceInfoModel> marketplaceInfoMoreApi() async {
    page++;

    if (hasNextPage.value && !_isMoreLoading.value) {
      _isMoreLoading.value = true;
      update();

      await MarketplaceApiServices.getMarketplaceProcessApi(
            amount.toString(),
            rate.toString(),
            "",
            isFilter: isFilter.value,
            page: page.toString(),
          )
          .then((value) {
            _marketplaceInfoModel = value!;
            // if (LocalStorage.getDeepLink()) {
            //   onResetFilterValue();
            //   Routes.filterItemsScreen.offAllNamed;
            // }

            var data = _marketplaceInfoModel.data.trads.lastPage;
            userList.addAll(_marketplaceInfoModel.data.trads.data);

            if (page >= data) {
              hasNextPage.value = false;
            }

            _isMoreLoading.value = false;

            onResetFilterValue();
            update();
          })
          .catchError((onError) {
            log.e(onError);
          });
    }
    _isMoreLoading.value = false;
    update();
    return _marketplaceInfoModel;
  }

  /// -----------------------------------

  void onResetFilterValue() {
    rate.value = 0.0;
    amount.value = 0.0;
    isFilter.value = false;
    debugPrint(
      '<<<<<<<<<<<<<< clear rate amount or deep link value >>>>>>>>>>>>>',
    );
    update();
  }
}
