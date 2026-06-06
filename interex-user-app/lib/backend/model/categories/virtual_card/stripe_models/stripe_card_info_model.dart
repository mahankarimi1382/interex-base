import '../../../../../widgets/payment_link/custom_drop_down.dart';

class StripeCardInfoModel {
  Message message;
  Data data;

  StripeCardInfoModel({required this.message, required this.data});

  factory StripeCardInfoModel.fromJson(Map<String, dynamic> json) =>
      StripeCardInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  String baseCurr;
  CardBasicInfo cardBasicInfo;
  List<MyCard> myCard;
  CardCharge cardCharge;
  List<Transaction> transactions;
  List<SupportedCurrency> supportedCurrency;

  Data({
    required this.baseCurr,
    required this.cardBasicInfo,
    required this.myCard,
    required this.cardCharge,
    required this.transactions,
    required this.supportedCurrency,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    baseCurr: json["base_curr"],
    cardBasicInfo: CardBasicInfo.fromJson(json["card_basic_info"]),
    myCard: List<MyCard>.from(json["myCard"].map((x) => MyCard.fromJson(x))),
    cardCharge: CardCharge.fromJson(json["cardCharge"]),
    transactions: List<Transaction>.from(
      json["transactions"].map((x) => Transaction.fromJson(x)),
    ),
    supportedCurrency: List<SupportedCurrency>.from(
      json["supported_currency"].map((x) => SupportedCurrency.fromJson(x)),
    ),
  );
}

class CardBasicInfo {
  String cardBackDetails;
  String cardBg;
  String siteTitle;
  String siteLogo;
  String siteFav;

  CardBasicInfo({
    required this.cardBackDetails,
    required this.cardBg,
    required this.siteTitle,
    required this.siteLogo,
    required this.siteFav,
  });

  factory CardBasicInfo.fromJson(Map<String, dynamic> json) => CardBasicInfo(
    cardBackDetails: json["card_back_details"],
    cardBg: json["card_bg"],
    siteTitle: json["site_title"],
    siteLogo: json["site_logo"],
    siteFav: json["site_fav"],
  );
}

class CardCharge {
  int id;
  String slug;
  String title;
  double fixedCharge;
  double percentCharge;
  double minLimit;
  double maxLimit;

  CardCharge({
    required this.id,
    required this.slug,
    required this.title,
    required this.fixedCharge,
    required this.percentCharge,
    required this.minLimit,
    required this.maxLimit,
  });

  factory CardCharge.fromJson(Map<String, dynamic> json) => CardCharge(
    id: json["id"],
    slug: json["slug"],
    title: json["title"],
    fixedCharge: double.parse((json["fixed_charge"] ?? "0").toString()),
    percentCharge: double.parse((json["percent_charge"] ?? "0").toString()),
    minLimit: double.parse((json["min_limit"] ?? "0").toString()),
    maxLimit: double.parse((json["max_limit"] ?? "0").toString()),
  );
}

class MyCard {
  int id;
  String cardId;
  String currency;
  String cardHolder;
  String brand;
  String type;
  String cardPan;
  String expiryMonth;
  String expiryYear;
  String cvv;
  String cardBackDetails;
  String siteTitle;
  String siteLogo;
  bool status;
  bool isDefault;
  MyCardStatusInfo statusInfo;

  MyCard({
    required this.id,
    required this.cardId,
    required this.currency,
    required this.cardHolder,
    required this.brand,
    required this.type,
    required this.cardPan,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.cardBackDetails,
    required this.siteTitle,
    required this.siteLogo,
    required this.status,
    required this.isDefault,
    required this.statusInfo,
  });

  factory MyCard.fromJson(Map<String, dynamic> json) => MyCard(
    id: json["id"],
    cardId: json["card_id"],
    currency: json["currency"],
    cardHolder: json["card_holder"],
    brand: json["brand"],
    type: json["type"],
    cardPan: json["card_pan"],
    expiryMonth: json["expiry_month"],
    expiryYear: json["expiry_year"],
    cvv: json["cvv"],
    cardBackDetails: json["card_back_details"],
    siteTitle: json["site_title"],
    siteLogo: json["site_logo"],
    status: json["status"],
    isDefault: json["is_default"],
    statusInfo: MyCardStatusInfo.fromJson(json["status_info"]),
  );
}

class MyCardStatusInfo {
  int active;
  int inactive;

  MyCardStatusInfo({required this.active, required this.inactive});

  factory MyCardStatusInfo.fromJson(Map<String, dynamic> json) =>
      MyCardStatusInfo(active: json["active"], inactive: json["inactive"]);
}

class Transaction {
  int id;
  String trx;
  String transactionType;
  String requestAmount;
  String payable;
  String totalCharge;
  String cardAmount;
  String cardNumber;
  String currentBalance;
  String status;
  DateTime dateTime;
  TransactionStatusInfo statusInfo;

  Transaction({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.totalCharge,
    required this.cardAmount,
    required this.cardNumber,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    trx: json["trx"],
    transactionType: json["transaction_type"],
    requestAmount: json["request_amount"],
    payable: json["payable"],
    totalCharge: json["total_charge"],
    cardAmount: json["card_amount"],
    cardNumber: json["card_number"],
    currentBalance: json["current_balance"],
    status: json["status"],
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: TransactionStatusInfo.fromJson(json["status_info"]),
  );
}

class TransactionStatusInfo {
  int success;
  int pending;
  int rejected;

  TransactionStatusInfo({
    required this.success,
    required this.pending,
    required this.rejected,
  });

  factory TransactionStatusInfo.fromJson(Map<String, dynamic> json) =>
      TransactionStatusInfo(
        success: json["success"],
        pending: json["pending"],
        rejected: json["rejected"],
      );
}

class Message {
  List<String> success;

  Message({required this.success});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(success: List<String>.from(json["success"].map((x) => x)));
}

class SupportedCurrency implements DropdownModel {
  int id;
  String country;
  String name;
  String code;
  String type;
  dynamic rate;
  int status;
  // DateTime createdAt;
  String currencyImage;

  SupportedCurrency({
    required this.id,
    required this.country,
    required this.name,
    required this.code,
    required this.type,
    required this.rate,
    required this.status,
    // required this.createdAt,
    required this.currencyImage,
  });

  factory SupportedCurrency.fromJson(Map<String, dynamic> json) =>
      SupportedCurrency(
        id: json["id"],
        country: json["country"],
        name: json["name"],
        code: json["code"],
        type: json["type"],
        rate: double.parse(json["rate"] ?? "0.0"),
        status: json["status"],
        // createdAt: DateTime.parse(json["created_at"]),
        currencyImage: json["currencyImage"],
      );

  @override
  String get title => name;
}
