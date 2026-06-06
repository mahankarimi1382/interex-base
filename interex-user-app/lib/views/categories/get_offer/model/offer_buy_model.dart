import '../../../../widgets/payment_link/custom_drop_down.dart';

class OfferBuyModel {
  Message message;
  Data data;

  OfferBuyModel({required this.message, required this.data});

  factory OfferBuyModel.fromJson(Map<String, dynamic> json) => OfferBuyModel(
    message: Message.fromJson(json["message"]),
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  List<PaymentGateway> paymentGatewaies;
  // List<Wallet> wallet;
  double totalCharge;
  Trade trade;
  String target;

  Data({
    required this.paymentGatewaies,
    // required this.wallet,
    required this.totalCharge,
    required this.trade,
    required this.target,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    paymentGatewaies: List<PaymentGateway>.from(
      json["payment_gatewaies"].map((x) => PaymentGateway.fromJson(x)),
    ),
    // wallet:
    //     List<Wallet>.from(json["wallet"].map((x) => Wallet.fromJson(x))),
    totalCharge: double.parse(
      (json["total_charge"] ?? 0).toString(),
    ).toDouble(),
    trade: Trade.fromJson(json["trade"]),
    target: json["target"],
  );
}

class PaymentGateway implements DropdownModel {
  int id;
  String name;

  PaymentGateway({required this.id, required this.name});

  factory PaymentGateway.fromJson(Map<String, dynamic> json) =>
      PaymentGateway(id: json["id"], name: json["name"]);

  @override
  String get title => name;
}

class Trade {
  int id;
  String amount;
  String rate;
  ECurrency saleCurrency;
  ECurrency rateCurrency;
  Wallet userWallet;
  int userId;

  Trade({
    required this.id,
    required this.amount,
    required this.rate,
    required this.saleCurrency,
    required this.rateCurrency,
    required this.userWallet,
    required this.userId,
  });

  factory Trade.fromJson(Map<String, dynamic> json) => Trade(
    id: json["id"],
    amount: json["amount"],
    rate: json["rate"],
    saleCurrency: ECurrency.fromJson(json["sale_currency"]),
    rateCurrency: ECurrency.fromJson(json["rate_currency"]),
    userWallet: Wallet.fromJson(json["userwallet"]),
    userId: json["user_id"],
  );
}

class ECurrency {
  int id;
  String code;
  String symbol;
  String flag;
  String rate;

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

class Wallet {
  int id;
  double balance;

  Wallet({required this.id, required this.balance});

  factory Wallet.fromJson(Map<String, dynamic> json) =>
      Wallet(id: json["id"], balance: json["balance"].toDouble());
}

class Message {
  List<String> success;

  Message({required this.success});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(success: List<String>.from(json["success"].map((x) => x)));
}
