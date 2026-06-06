import 'package:qrpaypro/widgets/payment_link/custom_drop_down.dart';

class MyTradeModel {
  final Data data;

  MyTradeModel({
    required this.data,
  });

  factory MyTradeModel.fromJson(Map<String, dynamic> json) => MyTradeModel(
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  final String baseUrl;
  final String defaultImage;
  final String imagePath;
  final List<Trade> trade;
  final List<ECurrency> rateCurrency;
  final List<ECurrency> saleCurrency;
  final List<Wallet> wallet;
  final TradeCharge tradeCharge;

  Data({
    required this.baseUrl,
    required this.defaultImage,
    required this.imagePath,
    required this.trade,
    required this.rateCurrency,
    required this.saleCurrency,
    required this.wallet,
    required this.tradeCharge,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseUrl: json["base_url"],
        defaultImage: json["default_image"],
        imagePath: json["image_path"],
        trade: List<Trade>.from(json["trade"].map((x) => Trade.fromJson(x))),
        rateCurrency: List<ECurrency>.from(
            json["rate_currency"].map((x) => ECurrency.fromJson(x))),
        saleCurrency: List<ECurrency>.from(
            json["sale_currency"].map((x) => ECurrency.fromJson(x))),
        wallet:
            List<Wallet>.from(json["wallet"].map((x) => Wallet.fromJson(x))),
        tradeCharge: TradeCharge.fromJson(json["trade_Charge"]),
      );
}

class ECurrency extends DropdownModel {
  final int id;
  final String code;
  final String symbol;
  final String flag;
  final String type;
  final double rate;

  ECurrency({
    required this.id,
    required this.code,
    required this.symbol,
    required this.flag,
    required this.type,
    required this.rate,
  });

  factory ECurrency.fromJson(Map<String, dynamic> json) => ECurrency(
        id: json["id"],
        code: json["code"],
        symbol: json["symbol"],
        flag: json["flag"] ?? "",
        type: json["type"] ?? "FIAT",
        rate: double.parse(json["rate"]),
      );

  @override
  String get title => code;
}

class Trade {
  final int id;
  final int tradeId;
  final String trx;
  final String transactinType;
  final String requestAmount;
  final String payable;
  final String totalCharge;
  final String buyerWillPay;
  final String buyerWillGet;
  final String saleCurrency;
  final String rateCurrency;
  final String status;
  final int statusId;
  final String rejectionReason;
  final DateTime createdAt;

  Trade({
    required this.id,
    required this.tradeId,
    required this.trx,
    required this.transactinType,
    required this.requestAmount,
    required this.payable,
    required this.totalCharge,
    required this.buyerWillPay,
    required this.buyerWillGet,
    required this.saleCurrency,
    required this.rateCurrency,
    required this.status,
    required this.statusId,
    required this.rejectionReason,
    required this.createdAt,
  });

  factory Trade.fromJson(Map<String, dynamic> json) => Trade(
        id: json["id"],
        tradeId: json["trade_id"],
        trx: json["trx"],
        transactinType: json["transactin_type"],
        requestAmount: json["request_amount"],
        payable: json["payable"],
        totalCharge: json["total_charge"],
        buyerWillPay: json["buyer_will_pay"],
        buyerWillGet: json["buyer_will_get"],
        saleCurrency: json["sale_currency"],
        rateCurrency: json["rate_currency"],
        status: json["status"],
        statusId: json["status_id"],
        rejectionReason: json["rejection_reason"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}

class TradeCharge {
  final int id;
  final String slug;
  final String title;
  final List<Interval> intervals;
  final double monthlyLimit;
  final double dailyLimit;

  TradeCharge({
    required this.id,
    required this.slug,
    required this.title,
    required this.intervals,
    required this.monthlyLimit,
    required this.dailyLimit,
  });

  factory TradeCharge.fromJson(Map<String, dynamic> json) => TradeCharge(
        id: json["id"],
        slug: json["slug"],
        title: json["title"],
        intervals: List<Interval>.from(
            json["intervals"].map((x) => Interval.fromJson(x))),
        monthlyLimit: double.parse(json["monthly_limit"]),
        dailyLimit: double.parse(json["daily_limit"]),
      );
}

class Interval {
  final double minLimit;
  final double maxLimit;
  final double charge;
  final double percent;

  Interval({
    required this.minLimit,
    required this.maxLimit,
    required this.charge,
    required this.percent,
  });

  factory Interval.fromJson(Map<String, dynamic> json) => Interval(
        minLimit: double.parse(json["min_limit"] ?? "0"),
        maxLimit: double.parse(json["max_limit"] ?? "0"),
        charge: double.parse(json["charge"] ?? "0"),
        percent: double.parse(json["percent"] ?? "0"),
      );
}

class Wallet {
  final int id;
  final String flag;
  final String code;
  final String name;
  final String balance;

  Wallet({
    required this.id,
    required this.flag,
    required this.code,
    required this.name,
    required this.balance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        flag: json["flag"] ?? "",
        code: json["code"],
        name: json["name"],
        balance: json["balance"],
      );
}
