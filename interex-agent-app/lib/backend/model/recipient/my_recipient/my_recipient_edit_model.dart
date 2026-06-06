class RecipientEditModel {
  final Message message;
  final Data data;

  RecipientEditModel({
    required this.message,
    required this.data,
  });

  factory RecipientEditModel.fromJson(Map<String, dynamic> json) =>
      RecipientEditModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  final Recipient recipient;
  final String baseCurr;
  final String countryFlugPath;
  final String defaultImage;
  final List<TransactionType> transactionTypes;
  final List<ReceiverCountry> receiverCountries;
  final List<Bank> banks;
  final List<Bank> cashPickupsPoints;

  Data({
    required this.recipient,
    required this.baseCurr,
    required this.countryFlugPath,
    required this.defaultImage,
    required this.transactionTypes,
    required this.receiverCountries,
    required this.banks,
    required this.cashPickupsPoints,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        recipient: Recipient.fromJson(json["recipient"]),
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
        "recipient": recipient.toJson(),
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final String editData;

  Bank({
    required this.id,
    required this.adminId,
    required this.name,
    required this.alias,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.editData,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        adminId: json["admin_id"],
        name: json["name"],
        alias: json["alias"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        editData: json["editData"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "admin_id": adminId,
        "name": name,
        "alias": alias,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "editData": editData,
      };
}

class ReceiverCountry {
  final int id;
  final String country;
  final String name;
  final String code;

  final String symbol;
  final dynamic flag;
  final double rate;
  final int status;
  final DateTime createdAt;


  ReceiverCountry({
    required this.id,
    required this.country,
    required this.name,
    required this.code,

    required this.symbol,
    this.flag,
    required this.rate,
    required this.status,
    required this.createdAt,

  });

  factory ReceiverCountry.fromJson(Map<String, dynamic> json) =>
      ReceiverCountry(
        id: json["id"],
        country: json["country"],
        name: json["name"],
        code: json["code"],

        symbol: json["symbol"],
        flag: json["flag"] ?? "",
        rate: double.parse(json["rate"] ?? "0.0"),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "name": name,
        "code": code,

        "symbol": symbol,
        "flag": flag,
        "rate": rate,
        "status": status,
        "created_at": createdAt.toIso8601String(),

      };
}

class Recipient {
  final int id;
  final int country;
  final String type;
  final String recipientType;
  final String alias;
  final String firstname;
  final String lastname;
  final String email;
  final String mobileCode;
  final String mobile;
  final String city;
  final String address;
  final String state;
  final String zipCode;
  final dynamic accountNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipient({
    required this.id,
    required this.country,
    required this.type,
    required this.recipientType,
    required this.alias,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.mobileCode,
    required this.mobile,
    required this.city,
    required this.address,
    required this.state,
    required this.zipCode,
    required this.createdAt,
    required this.updatedAt,
    this.accountNumber,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        id: json["id"],
        country: json["country"],
        type: json["type"],
        recipientType: json["recipient_type"],
        alias: json["alias"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        mobileCode: json["mobile_code"],
        mobile: json["mobile"],
        city: json["city"],
        address: json["address"],
        state: json["state"],
        zipCode: json["zip_code"],
        accountNumber: json["account_number"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "type": type,
        "recipient_type": recipientType,
        "alias": alias,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "mobile_code": mobileCode,
        "mobile": mobile,
        "city": city,
        "address": address,
        "state": state,
        "zip_code": zipCode,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
