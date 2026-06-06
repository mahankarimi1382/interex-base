import 'dart:convert';

WithdrawInfoModel withdrawInfoModelFromJson(String str) =>
    WithdrawInfoModel.fromJson(json.decode(str));

class WithdrawInfoModel {
  final Message message;
  final Data data;

  WithdrawInfoModel({
    required this.message,
    required this.data,
  });

  factory WithdrawInfoModel.fromJson(Map<String, dynamic> json) =>
      WithdrawInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  final String baseCurr;
  GetRemainingFields getRemainingFields;

  final String defaultImage;
  final String imagePath;
  final List<Gateway> gateways;
  final List<dynamic> transactions;

  Data({
    required this.baseCurr,
    required this.getRemainingFields,
    required this.defaultImage,
    required this.imagePath,
    required this.gateways,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        getRemainingFields:
            GetRemainingFields.fromJson(json["get_remaining_fields"]),
        defaultImage: json["default_image"],
        imagePath: json["image_path"],
        gateways: List<Gateway>.from(
            json["gateways"].map((x) => Gateway.fromJson(x))),
        transactions: List<dynamic>.from(json["transactions"].map((x) => x)),
      );
}

class GetRemainingFields {
  String transactionType;
  String attribute;

  GetRemainingFields({
    required this.transactionType,
    required this.attribute,
  });

  factory GetRemainingFields.fromJson(Map<String, dynamic> json) =>
      GetRemainingFields(
        transactionType: json["transaction_type"],
        attribute: json["attribute"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_type": transactionType,
        "attribute": attribute,
      };
}

class Gateway {
  final int id;
  final String name;
  final dynamic image;
  final String slug;
  final int code;
  final String type;
  final String alias;
  final List<String> supportedCurrencies;
  final dynamic inputFields;
  final int status;
  final List<Currency> currencies;

  Gateway({
    required this.id,
    required this.name,
    this.image,
    required this.slug,
    required this.code,
    required this.type,
    required this.alias,
    required this.supportedCurrencies,
    this.inputFields,
    required this.status,
    required this.currencies,
  });

  factory Gateway.fromJson(Map<String, dynamic> json) => Gateway(
        id: json["id"],
        name: json["name"],
        image: json["image"] ?? '',
        slug: json["slug"],
        code: json["code"],
        type: json["type"],
        alias: json["alias"],
        supportedCurrencies:
            List<String>.from(json["supported_currencies"].map((x) => x)),
        inputFields: json["input_fields"],
        status: json["status"],
        currencies: List<Currency>.from(
            json["currencies"].map((x) => Currency.fromJson(x))),
      );
}

class Currency {
  final int id;
  final int paymentGatewayId;
  final String type;
  final String name;
  final String alias;
  final String currencyCode;
  final String currencySymbol;
  final int crypto;
  final dynamic image;
  final dynamic minLimit;
  final dynamic maxLimit;
  final dynamic percentCharge;
  final dynamic fixedCharge;
  final dynamic dailyLimit;
  final dynamic monthlyLimit;
  final dynamic rate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Currency(
      {required this.id,
      required this.paymentGatewayId,
      required this.type,
      required this.name,
      required this.alias,
      required this.currencyCode,
      required this.currencySymbol,
      this.image,
      required this.minLimit,
      required this.maxLimit,
      required this.percentCharge,
      required this.fixedCharge,
      required this.dailyLimit,
      required this.monthlyLimit,
      required this.rate,
      required this.createdAt,
      required this.updatedAt,
      required this.crypto});

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        paymentGatewayId: json["payment_gateway_id"],
        type: json["type"],
        name: json["name"],
        alias: json["alias"],
        currencyCode: json["currency_code"],
        currencySymbol: json["currency_symbol"],
        image: json["image"] ?? '',
        minLimit: json["min_limit"],
        maxLimit: json["max_limit"],
        percentCharge: json["percent_charge"],
        fixedCharge: json["fixed_charge"],
        dailyLimit: json["daily_limit"],
        monthlyLimit: json["monthly_limit"],
        rate: json["rate"],
        crypto: json["crypto"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}

class UserWallet {
  final dynamic balance;
  final String currency;

  UserWallet({
    required this.balance,
    required this.currency,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
        balance: json["balance"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "currency": currency,
      };
}

class Message {
  final List<String> success;

  Message({
    required this.success,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
      };
}
