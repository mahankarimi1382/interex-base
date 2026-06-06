class SaveRecipientInfoModel {
  final Message message;
  final Data data;

  SaveRecipientInfoModel({
    required this.message,
    required this.data,
  });

  factory SaveRecipientInfoModel.fromJson(Map<String, dynamic> json) =>
      SaveRecipientInfoModel(
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
  final String countryFlugPath;
  final String defaultImage;
  final List<TransactionType> transactionTypes;
  final List<ReceiverCountry> receiverCountries;
  final List<Bank> banks;
  final List<Bank> cashPickupsPoints;

  Data({
    required this.baseCurr,
    required this.countryFlugPath,
    required this.defaultImage,
    required this.transactionTypes,
    required this.receiverCountries,
    required this.banks,
    required this.cashPickupsPoints,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        countryFlugPath: json["countryFlugPath"],
        defaultImage: json["default_image"],
        transactionTypes: List<TransactionType>.from(
            json["transactionTypes"].map((x) => TransactionType.fromJson(x))),
        receiverCountries: List<ReceiverCountry>.from(
            json["receiverCountries"].map((x) => ReceiverCountry.fromJson(x))),
        banks: List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
        cashPickupsPoints: List<Bank>.from(
            json["cashPickupsPoints"].map((x) => Bank.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "countryFlugPath": countryFlugPath,
        "default_image": defaultImage,
        "transactionTypes":
            List<dynamic>.from(transactionTypes.map((x) => x.toJson())),
        "receiverCountries":
            List<dynamic>.from(receiverCountries.map((x) => x.toJson())),
        "banks": List<dynamic>.from(banks.map((x) => x.toJson())),
        "cashPickupsPoints":
            List<dynamic>.from(cashPickupsPoints.map((x) => x.toJson())),
      };
}

class Bank {
  final int id;
  final int adminId;
  final String name;
  final String alias;
  final int status;

  final String editData;

  Bank({
    required this.id,
    required this.adminId,
    required this.name,
    required this.alias,
    required this.status,

    required this.editData,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        adminId: json["admin_id"],
        name: json["name"],
        alias: json["alias"],
        status: json["status"],

        editData: json["editData"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "admin_id": adminId,
        "name": name,
        "alias": alias,
        "status": status,

        "editData": editData,
      };
}

class ReceiverCountry {
  final int id;
  final String country;
  final String name;
  final String code;
  final dynamic mobileCode;
  final String symbol;
  final dynamic flag;
  final double rate;
  final int status;



  ReceiverCountry({
    required this.id,
    required this.country,
    required this.name,
    required this.code,
    required this.mobileCode,
    required this.symbol,
    this.flag,
    required this.rate,
    required this.status,


  });

  factory ReceiverCountry.fromJson(Map<String, dynamic> json) =>
      ReceiverCountry(
        id: json["id"],
        country: json["country"],
        name: json["name"],
        code: json["code"],
        mobileCode: json["mobile_code"] ?? '',
        symbol: json["symbol"],
        flag: json["flag"] ?? "",
        rate: double.parse(json["rate"] ?? "0.0"),
        status: json["status"],


      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "name": name,
        "code": code,
        "mobile_code": mobileCode,
        "symbol": symbol,
        "flag": flag,
        "rate": rate,
        "status": status,


      };
}

class TransactionType {
  final int id;
  final String fieldName;
  final String labelName;

  TransactionType({
    required this.id,
    required this.fieldName,
    required this.labelName,
  });

  factory TransactionType.fromJson(Map<String, dynamic> json) =>
      TransactionType(
        id: json["id"],
        fieldName: json["field_name"],
        labelName: json["label_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "field_name": fieldName,
        "label_name": labelName,
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
