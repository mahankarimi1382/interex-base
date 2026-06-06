
class CardInfoModel {
  Data data;

  CardInfoModel({
    required this.data,
  });

  factory CardInfoModel.fromJson(Map<String, dynamic> json) => CardInfoModel(
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  String baseCurr;
  // String baseCurrRate;
  List<SupportedCurrency> supportedCurrency;
  bool cardCreateAction;
  // CardBasicInfo cardBasicInfo;
  List<MyCard> myCard;
  CardCharge cardCharge;
  List<Transaction> transactions;

  Data({
    required this.baseCurr,
    // required this.baseCurrRate,
    required this.supportedCurrency,
    required this.cardCreateAction,
    // required this.cardBasicInfo,
    required this.myCard,
    required this.cardCharge,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        // baseCurrRate: json["base_curr_rate"],
        supportedCurrency: List<SupportedCurrency>.from(
            json["supported_currency"]
                .map((x) => SupportedCurrency.fromJson(x))),
        cardCreateAction: json["card_create_action"],
        // cardBasicInfo: CardBasicInfo.fromJson(json["card_basic_info"]),
        myCard:
            List<MyCard>.from(json["myCard"].map((x) => MyCard.fromJson(x))),
        cardCharge: CardCharge.fromJson(json["cardCharge"]),
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
      );
}

class CardCharge {
  // int id;
  // String slug;
  String title;
  dynamic fixedCharge;
  dynamic percentCharge;
  dynamic minLimit;
  dynamic maxLimit;

  CardCharge({
    // required this.id,
    // required this.slug,
    required this.title,
    this.fixedCharge,
    this.percentCharge,
    this.minLimit,
    this.maxLimit,
  });

  factory CardCharge.fromJson(Map<String, dynamic> json) => CardCharge(
        // id: json["id"],
        // slug: json["slug"],
        title: json["title"],
        fixedCharge: double.parse(json["fixed_charge"] ?? "0.0"),
        percentCharge: double.parse(json["percent_charge"] ?? "0.0"),
        minLimit: double.parse(json["min_limit"] ?? "0.0"),
        maxLimit: double.parse(json["max_limit"] ?? "0.0"),
      );
}

class SupportedCurrency {
  int id;
  String country;
  String name;
  String code;
  String type;
  dynamic rate;
  int supportedCurrencyDefault;
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
    required this.supportedCurrencyDefault,
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
        supportedCurrencyDefault: json["default"],
        status: json["status"],
        // createdAt: DateTime.parse(json["created_at"] ),
        currencyImage: json["currencyImage"],
      );
}

class Transaction {
  int id;
  String trx;
  String transactionType;
  String requestAmount;
  String payable;
  String exchangeRate;
  String totalCharge;
  String cardAmount;
  String cardNumber;
  String currentBalance;
  String status;
  DateTime dateTime;
  // StatusInfo statusInfo;

  Transaction({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.cardAmount,
    required this.cardNumber,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    // required this.statusInfo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        trx: json["trx"],
        transactionType: json["transaction_type"],
        requestAmount: json["request_amount"],
        payable: json["payable"],
        exchangeRate: json["exchange_rate"],
        totalCharge: json["total_charge"],
        cardAmount: json["card_amount"],
        cardNumber: json["card_number"],
        currentBalance: json["current_balance"],
        status: json["status"],
        dateTime: DateTime.parse(json["date_time"]),
        // statusInfo: StatusInfo.fromJson(json["status_info"]),
      );

}

class MyCard {
  final int id;
  final String name;
  final String cardPan;
  final String cardId;
  final String expiration;
  final String cvv;
  final int amount;
  final int status;
  final dynamic isDefault;
  // final MyCardStatusInfo statusInfo;

  MyCard({
    required this.id,
    required this.name,
    required this.cardPan,
    required this.cardId,
    required this.expiration,
    required this.cvv,
    required this.amount,
    required this.status,
    this.isDefault,
    // required this.statusInfo,
  });

  factory MyCard.fromJson(Map<String, dynamic> json) => MyCard(
        id: json["id"],
        name: json["name"],
        cardPan: json["card_pan"],
        cardId: json["card_id"],
        expiration: json["expiration"],
        cvv: json["cvv"],
        amount: json["amount"],
        status: json["status"],
        isDefault: json["is_default"] ?? false,
        // statusInfo: MyCardStatusInfo.fromJson(json["status_info"]),
      );

}