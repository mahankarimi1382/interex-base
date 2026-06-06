import 'dart:convert';

MoneyInInfoModel moneyInInfoModelFromJson(String str) =>
    MoneyInInfoModel.fromJson(json.decode(str));

String moneyInInfoModelToJson(MoneyInInfoModel data) =>
    json.encode(data.toJson());

class MoneyInInfoModel {
  final Message message;
  final Data data;

  MoneyInInfoModel({
    required this.message,
    required this.data,
  });

  factory MoneyInInfoModel.fromJson(Map<String, dynamic> json) =>
      MoneyInInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  final String baseCurr;
  final dynamic baseCurrRate;
  GetRemainingFields getRemainingFields;

  final MoneyInCharge moneyInCharge;
  final List<dynamic> transactions;

  Data({
    required this.baseCurr,
    this.baseCurrRate,
    required this.getRemainingFields,
    required this.moneyInCharge,
    // required this.agentWallet,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        baseCurrRate: double.parse(json["base_curr_rate"] ?? "0.0"),
        getRemainingFields:
            GetRemainingFields.fromJson(json["get_remaining_fields"]),
        moneyInCharge: MoneyInCharge.fromJson(json["moneyInCharge"]),
        // agentWallet: AgentWallet.fromJson(json["agentWallet"]),
        transactions: List<dynamic>.from(json["transactions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "base_curr_rate": baseCurrRate,
        "get_remaining_fields": getRemainingFields.toJson(),

        "moneyInCharge": moneyInCharge.toJson(),
        // "agentWallet": agentWallet.toJson(),
        "transactions": List<dynamic>.from(transactions.map((x) => x)),
      };
}

class AgentWallet {
  final double balance;
  final String currency;
  final int rate;

  AgentWallet({
    required this.balance,
    required this.currency,
    required this.rate,
  });

  factory AgentWallet.fromJson(Map<String, dynamic> json) => AgentWallet(
        balance: double.parse(json["balance"] ?? "0.0"),
        currency: json["currency"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "currency": currency,
        "rate": rate,
      };
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

class MoneyInCharge {
  final int id;
  final String slug;
  final String title;
  final dynamic fixedCharge;
  final dynamic percentCharge;
  final dynamic minLimit;
  final dynamic maxLimit;
  final dynamic dailyLimit;
  final dynamic monthlyLimit;
  final dynamic agentFixedCommissions;
  final dynamic agentPercentCommissions;
  final bool agentProfit;

  MoneyInCharge({
    required this.id,
    required this.slug,
    required this.title,
    this.fixedCharge,
    this.percentCharge,
    this.minLimit,
    this.maxLimit,
    this.monthlyLimit,
    this.dailyLimit,
    this.agentFixedCommissions,
    this.agentPercentCommissions,
    required this.agentProfit,
  });

  factory MoneyInCharge.fromJson(Map<String, dynamic> json) => MoneyInCharge(
        id: json["id"],
        slug: json["slug"],
        title: json["title"],
        fixedCharge: double.parse(json["fixed_charge"] ?? "0.0"),
        percentCharge: double.parse(json["percent_charge"] ?? "0.0"),
        minLimit: double.parse(json["min_limit"] ?? "0.0"),
        maxLimit: double.parse(json["max_limit"] ?? "0.0"),
        monthlyLimit: double.parse(json["monthly_limit"] ?? "0.0"),
        dailyLimit: double.parse(json["daily_limit"] ?? "0.0"),
        agentFixedCommissions:
            double.parse(json["agent_fixed_commissions"] ?? "0.0"),
        agentPercentCommissions:
            double.parse(json["agent_percent_commissions"] ?? "0.0"),
        agentProfit: json["agent_profit"],
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
        "agent_fixed_commissions": agentFixedCommissions,
        "agent_percent_commissions": agentPercentCommissions,
        "agent_profit": agentProfit,
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
