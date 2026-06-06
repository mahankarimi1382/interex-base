class WalletsModel {
  Message message;
  Data data;

  WalletsModel({required this.message, required this.data});

  factory WalletsModel.fromJson(Map<String, dynamic> json) => WalletsModel(
    message: Message.fromJson(json["message"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  List<UserWallet> userWallets;

  Data({required this.userWallets});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userWallets: List<UserWallet>.from(
      json["userWallets"].map((x) => UserWallet.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "userWallets": List<dynamic>.from(userWallets.map((x) => x.toJson())),
  };
}

class UserWallet {
  dynamic balance;
  dynamic status;
  Currency currency;

  UserWallet({
    required this.balance,
    required this.status,
    required this.currency,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
    balance: json["balance"]?.toDouble(),
    status: json["status"],
    currency: Currency.fromJson(json["currency"]),
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "status": status,
    "currency": currency.toJson(),
  };
}

class Currency {
  int id;
  String code;
  dynamic rate;
  dynamic flag;
  dynamic symbol;
  String type;
  dynamic currencyDefault;
  String country;
  bool both;
  bool senderCurrency;
  bool receiverCurrency;
  String editData;
  String currencyImage;

  Currency({
    required this.id,
    required this.code,
    required this.rate,
    required this.flag,
    required this.symbol,
    required this.type,
    required this.currencyDefault,
    required this.country,
    required this.both,
    required this.senderCurrency,
    required this.receiverCurrency,
    required this.editData,
    required this.currencyImage,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    code: json["code"],
    rate: json["rate"],
    flag: json["flag"],
    symbol: json["symbol"],
    type: json["type"],
    currencyDefault: json["default"],
    country: json["country"],
    both: json["both"],
    senderCurrency: json["senderCurrency"],
    receiverCurrency: json["receiverCurrency"],
    editData: json["editData"],
    currencyImage: json["currencyImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "rate": rate,
    "flag": flag,
    "symbol": symbol,
    "type": type,
    "default": currencyDefault,
    "country": country,
    "both": both,
    "senderCurrency": senderCurrency,
    "receiverCurrency": receiverCurrency,
    "editData": editData,
    "currencyImage": currencyImage,
  };
}

class Message {
  List<String> success;

  Message({required this.success});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(success: List<String>.from(json["success"].map((x) => x)));

  Map<String, dynamic> toJson() => {
    "success": List<dynamic>.from(success.map((x) => x)),
  };
}
