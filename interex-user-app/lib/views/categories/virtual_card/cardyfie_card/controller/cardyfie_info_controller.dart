import 'package:intl/intl.dart';

import '../../../../../backend/local_storage/local_storage.dart';
import '../../../../../backend/model/common/common_success_model.dart';
import '../../../../../backend/services/api_endpoint.dart';
import '../../../../../backend/utils/request_process.dart';
import '../../../../../controller/categories/remaing_balance_controller/remaing_balance_controller.dart';
import '../../../../../controller/navbar/dashboard_controller.dart';
import '../../../../../language/language_controller.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/basic_screen_imports.dart';
import '../model/card_create_info_model_cardyfie.dart';
import '../model/my_card_model_cardyfie.dart';

class VirtualCardyfieCardController extends GetxController {
  final dashboardController = Get.put(DashBoardController());
  // final updateProfileController = Get.put(UpdateProfileController());
  final fundAmountController = TextEditingController();
  final remainingController = Get.put(RemaingBalanceController());
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final identifyNumberController = TextEditingController();
  final houseNumberController = TextEditingController();
  final stateController = TextEditingController();
  final zipcodeController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  // final addWithdrawController = Get.put(CardyfieWithdrawFundController());
  // final addFundController = Get.put(CardyfieAddFundController());
  final cardHolderNameController = TextEditingController();
  final idNumberController = TextEditingController();
  final phoneController = TextEditingController();
  final lineController = TextEditingController();
  final countryController = TextEditingController();
  final idTypeController = TextEditingController();
  RxString baseCurrency = "".obs;
  RxString cardCurrency = "".obs;
  RxString cardyfieCardUIId = "".obs;
  RxInt activeIndicatorIndex = 0.obs;

  RxDouble remainingDailyLimit = 0.0.obs;
  RxDouble remainingMonthLyLimit = 0.0.obs;

  RxDouble totalCharge = 0.0.obs;
  RxDouble totalPay = 0.00.obs;
  RxDouble percentCharge = 0.00.obs;
  RxDouble minLimit = 0.00.obs;
  RxDouble maxLimit = 0.00.obs;
  RxString walletCurrencyCode = "".obs;
  // RxDouble amount = 0.00.obs;

  RxString selectedCountry = 'Select Country'.obs;
  RxString countryISO2 = ''.obs;
  final RxString selectTypeName = 'Select Type'.obs;
  final RxString selectTypeSlug = ''.obs;
  // for customer create
  final List<Map<String, String>> identityList = [
    {'name': 'National ID Card (NID)', 'slug': 'nid'},
    {'name': 'Passport', 'slug': 'passport'},
    {'name': 'Bank Verification Number', 'slug': 'bvn'},
  ];

  // for card tier
  final RxString selectTierName = 'Select Card Tier'.obs;
  final RxString selectTierSlug = ''.obs;
  final List<Map<String, String>> cardTierList = [
    {'name': 'Universal', 'slug': 'universal'},
    {'name': 'Platinum', 'slug': 'platinum'},
  ];
  // for card type
  final RxString selectCardTypeName = 'Select Card Type'.obs;
  final RxString selectCardTypeSlug = ''.obs;
  final List<Map<String, String>> cardTypeList = [
    {'name': 'Visa', 'slug': 'visa'},
    {'name': 'MasterCard', 'slug': 'masterCard'},
  ];
  RxList<String> listImagePath = <String>[].obs;
  RxList<String> listFieldName = <String>[].obs;

  RxBool hasFile = false.obs;
  RxString appBarTitle = "".obs;

  //from currency
  RxDouble fromCurrencyRate = 0.0.obs;
  RxDouble exchangeRate = 0.0.obs;
  RxString fromCurrency = "".obs;
  Rxn<UserWallet> selectMainWallet = Rxn<UserWallet>();
  List<UserWallet> walletsList = [];

  //supported currency
  RxString supportedCurrencyCode = "".obs;
  Rxn<SupportedCurrency> selectSupportedCurrency = Rxn<SupportedCurrency>();
  List<SupportedCurrency> supportedCurrencyList = [];

  @override
  void onInit() {
      if (LocalStorages.getCardType() == 'cardyfie') {
      cardyfieCardCreatePageInfo();
      getCardyfieCardData();
    }

 
    super.onInit();
  }

  void changeIndicator(int value) {
    activeIndicatorIndex.value = value;
  }

  /// Get Cardyfie Card Data
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late MyCardCardyfieModel _cardyfieCardModel;
  MyCardCardyfieModel get cardyfieCardModel => _cardyfieCardModel;

  Future<MyCardCardyfieModel?> getCardyfieCardData() async {
    return RequestProcess().request<MyCardCardyfieModel>(
      fromJson: MyCardCardyfieModel.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieMyCards,
      isLoading: _isLoading,
      method: HttpMethod.GET,
      showSuccessMessage: false,
      showResult: true,
      onSuccess: (value) {
        _cardyfieCardModel = value!;

        // Set default card ID
        if (_cardyfieCardModel.data.myCards.isNotEmpty) {
          cardyfieCardUIId.value = _cardyfieCardModel.data.myCards.first.ulid;
        }

        // Set currency and wallet data
        baseCurrency.value = _cardyfieCardModel.data.baseCurr;
        fromCurrency.value =
            _cardyfieCardModel.data.userWallet.first.currency.code;
        selectMainWallet.value = _cardyfieCardModel.data.userWallet.first;

        // Populate user wallets
        walletsList.clear();
        for (var element in _cardyfieCardModel.data.userWallet) {
          walletsList.add(
            UserWallet(
              balance: element.balance,
              status: element.status,
              currency: element.currency,
            ),
          );
        }

        // Supported currencies
        supportedCurrencyList.clear();
        supportedCurrencyCode.value =
            _cardyfieCardModel.data.supportedCurrency.first.code;
        selectSupportedCurrency.value =
            _cardyfieCardModel.data.supportedCurrency.first;

        for (var element in _cardyfieCardModel.data.supportedCurrency) {
          supportedCurrencyList.add(
            SupportedCurrency(
              rate: element.rate,
              status: element.status,
              id: element.id,
              code: element.code,
              country: element.country,
              currencyImage: element.currencyImage,
              flag: element.flag,
              name: element.name,
              supportedCurrencyDefault: element.supportedCurrencyDefault,
              symbol: element.symbol,
              type: element.type,
            ),
          );
        }
        minLimit.value = double.parse(
          _cardyfieCardModel.data.cardCharge.minLimit.toString(),
        );
        maxLimit.value = double.parse(
          _cardyfieCardModel.data.cardCharge.maxLimit.toString(),
        );

        remainingController.transactionType.value =
            _cardyfieCardModel.data.getRemainingFields.transactionType;
        remainingController.attribute.value =
            _cardyfieCardModel.data.getRemainingFields.attribute;
        remainingController.cardId.value = 1;
        remainingController.senderAmount.value = '0';
        remainingController.senderCurrency.value = supportedCurrencyCode.value;

        remainingController.getRemainingBalanceProcess();

        // Optional: trigger remaining calculation
        // calculation();
      },
    );
  }

  /// Buy / Issue Card Process
  final _isBuyCardLoading = false.obs;
  bool get isBuyCardLoading => _isBuyCardLoading.value;

  late CommonSuccessModel _buyCardModel;
  CommonSuccessModel get buyCardModel => _buyCardModel;

  Future<CommonSuccessModel?> issueCardProcess(BuildContext context) async {
    Map<String, dynamic> inputBody = {
      "name_on_card": cardHolderNameController.text,
      "card_tier": selectTierSlug.value,
      "card_type": selectCardTypeSlug.value,
      "currency": supportedCurrencyCode.value,
      "from_currency": fromCurrency.value,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieCreateCard,
      isLoading: _isBuyCardLoading,
      method: HttpMethod.POST,
      body: inputBody,
      showSuccessMessage: true,
      showResult: true,
      onSuccess: (value) {
        _buyCardModel = value!;
        Get.offAllNamed(Routes.bottomNavBarScreen);
      },
    );
  }

  // void calculation() {
  //   double amount = 0.0;

  //   if (fundAmountController.text.isNotEmpty) {
  //     try {
  //       amount = double.parse(fundAmountController.text);
  //     } catch (e) {
  //       // print('Error parsing double: $e');
  //     }
  //   }
  //   SupportedCurrency data = _cardyfieCardModel.data.supportedCurrency.first;
  //   exchangeRate.value = fromCurrencyRate.value / double.parse(data.rate);

  //   totalCharge.value =
  //       percentCharge.value +
  //       (double.parse(data.fees.cardyfieCardDepositFixedFee) *
  //           exchangeRate.value);
  //   totalPay.value = amount + totalCharge.value;
  // }

  String getDay(String value) {
    DateTime startDate = DateTime.parse(value);
    var date = DateFormat('dd').format(startDate);
    return date.toString();
  }

  String getMonth(String value) {
    DateTime startDate = DateTime.parse(value);
    var date = DateFormat('MMMM').format(startDate);
    return date.toString();
  }

  ///  Make Card Default
  final _isMakeDefaultLoading = false.obs;
  bool get isMakeDefaultLoading => _isMakeDefaultLoading.value;

  late CommonSuccessModel _cardDefaultModel;
  CommonSuccessModel get cardDefaultModel => _cardDefaultModel;

  Future<CommonSuccessModel?> makeCardDefaultProcess(String cardId) async {
    Map<String, dynamic> inputBody = {'card_id': cardId};

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieMakeRemoveDefault,
      isLoading: _isMakeDefaultLoading,
      method: HttpMethod.POST,
      body: inputBody,
      showSuccessMessage: true,
      showResult: true,
      onSuccess: (value) {
        _cardDefaultModel = value!;
        getCardyfieCardData();
      },
    );
  }

  /// Create Card Info
  final _isCreateCardInfoLoading = false.obs;
  bool get isCreateCardInfoLoading => _isCreateCardInfoLoading.value;

  late CreateCardInfoModelCardyfie _createCardPageInfoModelCardyfie;
  CreateCardInfoModelCardyfie get createCardPageInfoModelCardyfie =>
      _createCardPageInfoModelCardyfie;

  Future<CreateCardInfoModelCardyfie?> cardyfieCardCreatePageInfo() async {
    return RequestProcess().request<CreateCardInfoModelCardyfie>(
      fromJson: CreateCardInfoModelCardyfie.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieCreatePageInfo,
      isLoading: _isCreateCardInfoLoading,
      method: HttpMethod.GET, // or POST if the API requires
      showSuccessMessage: false,
      showResult: true,
      onSuccess: (value) {
        _createCardPageInfoModelCardyfie = value!;

        final isCustomerExist =
            _createCardPageInfoModelCardyfie.data.customerExistStatus;

        if (isCustomerExist) {
          appBarTitle.value = Strings.createCard;
        } else {
          appBarTitle.value = Get.find<LanguageController>().getTranslation(
            Strings.createCardCustomer,
          );
        }
      },
    );
  }

  /// Customer Create
  final _isCustomerCreateLoading = false.obs;
  bool get isCustomerCreateLoading => _isCustomerCreateLoading.value;

  late CommonSuccessModel _commonSuccessModel;
  CommonSuccessModel get commonSuccessModel => _commonSuccessModel;

  Future<CommonSuccessModel?> customerCreateProcess() async {
    Map<String, dynamic> inputBody = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'date_of_birth': dateOfBirthController.text,
      'identity_type': selectTypeSlug.value,
      'identity_number': identifyNumberController.text,
      'house_number': houseNumberController.text,
      'country': countryISO2.value,
      'city': cityController.text,
      'state': stateController.text,
      'zip_code': zipcodeController.text,
      'address': addressController.text,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieCreateCustomer,
      isLoading: _isCustomerCreateLoading,
      method: HttpMethod.POST,
      fieldList: listFieldName,
      pathList: listImagePath,
      showSuccessMessage: true,
      showResult: true,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        Get.offAllNamed(Routes.bottomNavBarScreen);
      },
    );
  }

  // Closing Ticket

  final _isCloseLoading = false.obs;
  bool get isCloseLoading => _isCloseLoading.value;

  late CommonSuccessModel _closeModel;
  CommonSuccessModel get closeModel => _closeModel;

  Future<CommonSuccessModel?> closeProcess() async {
    Map<String, dynamic> inputBody = {'card_id': cardyfieCardUIId.value};

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieCloseCard,
      isLoading: _isCloseLoading,
      method: HttpMethod.POST,
      showSuccessMessage: true,
      showResult: true,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        Get.offAllNamed(Routes.bottomNavBarScreen);
      },
    );
  }

  //
  void updateImageData(String fieldName, String imagePath) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      listImagePath[itemIndex] = imagePath;
    } else {
      listFieldName.add(fieldName);
      listImagePath.add(imagePath);
    }
    update();
  }

  String? getImagePath(String fieldName) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      return listImagePath[itemIndex];
    }
    return null;
  }
}
