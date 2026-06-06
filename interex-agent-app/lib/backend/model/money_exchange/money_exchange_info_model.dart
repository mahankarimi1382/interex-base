import 'dart:convert';

MoneyExchangeInfoModel moneyExchangeInfoModelFromJson(String str) =>
    MoneyExchangeInfoModel.fromJson(json.decode(str));

String moneyExchangeInfoModelToJson(MoneyExchangeInfoModel data) =>
    json.encode(data.toJson());

class MoneyExchangeInfoModel {
  Message? message;
  Data? data;

  MoneyExchangeInfoModel({
    this.message,
    this.data,
  });

  factory MoneyExchangeInfoModel.fromJson(Map<String, dynamic> json) =>
      MoneyExchangeInfoModel(
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  String? baseCurr;
  double? baseCurrRate;
 GetRemainingFields getRemainingFields;
  Charges? charges;
  List<dynamic>? transactions;

  Data({
    this.baseCurr,
    this.baseCurrRate,
    required this.getRemainingFields,
    this.charges,
    this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        baseCurrRate: double.parse(json["base_curr_rate"] ?? "0.0"),
        getRemainingFields: GetRemainingFields.fromJson(json["get_remaining_fields"]),

        charges:
            json["charges"] == null ? null : Charges.fromJson(json["charges"]),
        transactions: json["transactions"] == null
            ? []
            : List<dynamic>.from(json["transactions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "base_curr_rate": baseCurrRate,
        "get_remaining_fields": getRemainingFields.toJson(),

        "charges": charges?.toJson(),
        "transactions": transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x)),
      };
}

class GetRemainingFields {
    String transactionType;
    String attribute;

    GetRemainingFields({
        required this.transactionType,
        required this.attribute,
    });

    factory GetRemainingFields.fromJson(Map<String, dynamic> json) => GetRemainingFields(
        transactionType: json["transaction_type"],
        attribute: json["attribute"],
    );

    Map<String, dynamic> toJson() => {
        "transaction_type": transactionType,
        "attribute": attribute,
    };
}

class Charges {
  int? id;
  String? slug;
  String? title;
  double? fixedCharge;
  double? percentCharge;
  double? minLimit;
  double? maxLimit;
  double? monthlyLimit;
  double? dailyLimit;

  Charges({
    this.id,
    this.slug,
    this.title,
    this.fixedCharge,
    this.percentCharge,
    this.minLimit,
    this.maxLimit,
    this.monthlyLimit,
    this.dailyLimit,
  });

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        id: json["id"],
        slug: json["slug"],
        title: json["title"],
        fixedCharge: double.parse(json["fixed_charge"] ?? "0.0"),
        percentCharge: double.parse(json["percent_charge"] ?? "0.0"),
        minLimit: double.parse(json["min_limit"] ?? "0.0"),
        maxLimit: double.parse(json["max_limit"] ?? "0.0"),
        monthlyLimit: double.parse(json["monthly_limit"] ?? "0.0"),
        dailyLimit: double.parse(json["daily_limit"] ?? "0.0"),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "title": title,
        "fixed_charge": fixedCharge,
        "percent_charge": percentCharge,
        "min_limit": minLimit,
        "max_limit": maxLimit,
        "monthly_limit": monthlyLimit,
        "daily_limit": dailyLimit,
      };
}

class Message {
  List<String>? success;

  Message({
    this.success,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: json["success"] == null
            ? []
            : List<String>.from(json["success"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success":
            success == null ? [] : List<dynamic>.from(success!.map((x) => x)),
      };
}
