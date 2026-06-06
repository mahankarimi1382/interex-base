import '../../../../widgets/payment_link/custom_drop_down.dart';

class MarketplaceBuyModel {
  Message message;
  Data data;

  MarketplaceBuyModel({required this.message, required this.data});

  factory MarketplaceBuyModel.fromJson(Map<String, dynamic> json) =>
      MarketplaceBuyModel(
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
    totalCharge: double.parse(json["total_charge"]),
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
  String subTotal;
  String seller;
  Wallet userWallet;
  ECurrency saleCurrency;
  ECurrency rateCurrency;
  int userId;

  Trade({
    required this.id,
    required this.subTotal,
    required this.seller,
    required this.userWallet,
    required this.saleCurrency,
    required this.rateCurrency,
    required this.userId,
  });

  factory Trade.fromJson(Map<String, dynamic> json) => Trade(
    id: json["id"],
    subTotal: json["subtotal"],
    seller: json["seller"],
    userWallet: Wallet.fromJson(json["userwallet"]),
    saleCurrency: ECurrency.fromJson(json["sale_currency"]),
    rateCurrency: ECurrency.fromJson(json["rate_currency"]),
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
      Wallet(id: json["id"], balance: double.parse(json["balance"].toString()));
}

class Message {
  List<String> success;

  Message({required this.success});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(success: List<String>.from(json["success"].map((x) => x)));
}
