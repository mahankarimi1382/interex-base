class MarketplaceInfoModel {
  Message message;
  Data data;

  MarketplaceInfoModel({required this.message, required this.data});

  factory MarketplaceInfoModel.fromJson(Map<String, dynamic> json) =>
      MarketplaceInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Trads trads;

  Data({required this.trads});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(trads: Trads.fromJson(json["trads"]));
}

class Trads {
  int currentPage;
  int lastPage;
  List<Datum> data;

  Trads({
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory Trads.fromJson(Map<String, dynamic> json) => Trads(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );
}

class Datum {
  String imagePath;
  String defaultImage;
  String baseUr;
  int id;
  String exchangeRate;
  double amount;
  double rate;
  ECurrency saleCurrency;
  ECurrency rateCurrency;
  User user;

  Datum({
    required this.imagePath,
    required this.defaultImage,
    required this.baseUr,
    required this.id,
    required this.exchangeRate,
    required this.amount,
    required this.rate,
    required this.saleCurrency,
    required this.rateCurrency,
    required this.user,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    imagePath: json["image_path"],
    defaultImage: json["default_image"],
    baseUr: json["base_ur"],
    id: json["id"],
    exchangeRate: json["exchange_rate"],
    amount: double.parse(json["amount"].toString()),
    rate: double.parse(json["rate"].toString()),
    saleCurrency: ECurrency.fromJson(json["sale_currency"]),
    rateCurrency: ECurrency.fromJson(json["rate_currency"]),
    user: User.fromJson(json["user"]),
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

class User {
  int id;
  dynamic image;
  String name;
  int emailVerified;
  int kycVerified;

  User({
    required this.id,
    this.image,
    required this.name,
    required this.emailVerified,
    required this.kycVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    image: json["image"] ?? '',
    name: json["name"],
    emailVerified: json["email_verified"],
    kycVerified: json["kyc_verified"],
  );
}

class Link {
  dynamic url;
  String label;
  bool active;

  Link({this.url, required this.label, required this.active});

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] ?? '',
    label: json["label"],
    active: json["active"],
  );
}

class Message {
  List<String> success;

  Message({required this.success});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(success: List<String>.from(json["success"].map((x) => x)));
}
