class TradeEditInfoModel {
  final Data data;

  TradeEditInfoModel({required this.data});

  factory TradeEditInfoModel.fromJson(Map<String, dynamic> json) =>
      TradeEditInfoModel(data: Data.fromJson(json["data"]));
}

class Data {
  final int id;
  final String amount;
  final String rate;
  final ECurrency saleCurrency;
  final ECurrency rateCurrency;

  Data({
    required this.id,
    required this.amount,
    required this.rate,
    required this.saleCurrency,
    required this.rateCurrency,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    amount: json["amount"],
    rate: json["rate"],
    saleCurrency: ECurrency.fromJson(json["sale_currency"]),
    rateCurrency: ECurrency.fromJson(json["rate_currency"]),
  );
}

class ECurrency {
  final int id;
  final String code;
  final String symbol;
  final String flag;
  final String rate;

  ECurrency({
    required this.id,
    required this.code,
    required this.symbol,
    required this.flag,
    required this.rate,
  });

  factory ECurrency.fromJson(Map<String, dynamic> json) => ECurrency(
    id: json["id"],
    code: json["code"],
    symbol: json["symbol"],
    flag: json["flag"],
    rate: json["rate"],
  );
}
