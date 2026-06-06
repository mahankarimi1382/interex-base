class MoneyExchangeInfoModel {
  Message message;
  Data data;

  MoneyExchangeInfoModel({
    required this.message,
    required this.data,
  });

  factory MoneyExchangeInfoModel.fromJson(Map<String, dynamic> json) =>
      MoneyExchangeInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String baseCurr;
  String baseCurrRate;
    GetRemainingFields getRemainingFields;

  Charges charges;
  List<Transaction> transactions;

  Data({
    required this.baseCurr,
    required this.baseCurrRate,
        required this.getRemainingFields,

    required this.charges,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        baseCurrRate: json["base_curr_rate"],
        getRemainingFields: GetRemainingFields.fromJson(json["get_remaining_fields"]),

        charges: Charges.fromJson(json["charges"]),
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "base_curr_rate": baseCurrRate,
        "get_remaining_fields": getRemainingFields.toJson(),

        "charges": charges.toJson(),
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
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
  int id;
  String slug;
  String title;
  String fixedCharge;
  String percentCharge;
  dynamic minLimit;
  dynamic maxLimit;
  String monthlyLimit;
  String dailyLimit;

  Charges({
    required this.id,
    required this.slug,
    required this.title,
    required this.fixedCharge,
    required this.percentCharge,
    required this.minLimit,
    required this.maxLimit,
    required this.monthlyLimit,
    required this.dailyLimit,
  });

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        id: json["id"],
        slug: json["slug"],
        title: json["title"],
        fixedCharge: json["fixed_charge"],
        percentCharge: json["percent_charge"],
        minLimit: json["min_limit"],
        maxLimit: json["max_limit"],
        monthlyLimit: json["monthly_limit"],
        dailyLimit: json["daily_limit"],
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

class Transaction {
  int id;
  String type;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String payable;
  String exchangeRate;
  String totalCharge;
  String exchangeableAmount;
  String currentBalance;
  String status;
  int statusValue;
  DateTime dateTime;
  StatusInfo statusInfo;

  Transaction({
    required this.id,
    required this.type,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.exchangeableAmount,
    required this.currentBalance,
    required this.status,
    required this.statusValue,
    required this.dateTime,
    required this.statusInfo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        type: json["type"],
        trx: json["trx"],
        transactionType: json["transaction_type"],
        transactionHeading: json["transaction_heading"],
        requestAmount: json["request_amount"],
        payable: json["payable"],
        exchangeRate: json["exchange_rate"],
        totalCharge: json["total_charge"],
        exchangeableAmount: json["exchangeable_amount"],
        currentBalance: json["current_balance"],
        status: json["status"],
        statusValue: json["status_value"],
        dateTime: DateTime.parse(json["date_time"]),
        statusInfo: StatusInfo.fromJson(json["status_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "trx": trx,
        "transaction_type": transactionType,
        "transaction_heading": transactionHeading,
        "request_amount": requestAmount,
        "payable": payable,
        "exchange_rate": exchangeRate,
        "total_charge": totalCharge,
        "exchangeable_amount": exchangeableAmount,
        "current_balance": currentBalance,
        "status": status,
        "status_value": statusValue,
        "date_time": dateTime.toIso8601String(),
        "status_info": statusInfo.toJson(),
      };
}

class StatusInfo {
  int success;
  int pending;
  int rejected;

  StatusInfo({
    required this.success,
    required this.pending,
    required this.rejected,
  });

  factory StatusInfo.fromJson(Map<String, dynamic> json) => StatusInfo(
        success: json["success"],
        pending: json["pending"],
        rejected: json["rejected"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "pending": pending,
        "rejected": rejected,
      };
}

class Message {
  List<String> success;

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
