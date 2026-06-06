class RemittanceInfoModel {
  final Message message;
  final Data data;

  RemittanceInfoModel({
    required this.message,
    required this.data,
  });

  factory RemittanceInfoModel.fromJson(Map<String, dynamic> json) =>
      RemittanceInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  final String fromCountryFlugPath;
  final String toCountryFlugPath;
  final String defaultImage;
  // final AgentWallet agentWallet;
  final List<TransactionType> transactionTypes;
   GetRemainingFields getRemainingFields;

  final RemittanceCharge remittanceCharge;
  final List<Country> fromCountry;
  final List<Country> toCountries;
  final List<ErRecipient> senderRecipients;
  final List<ErRecipient> receiverRecipients;
  final List<dynamic> transactions;

  Data({
    required this.fromCountryFlugPath,
    required this.toCountryFlugPath,
    required this.defaultImage,
    // required this.agentWallet,
    required this.transactionTypes,
      required this.getRemainingFields,

    required this.remittanceCharge,
    required this.fromCountry,
    required this.toCountries,
    required this.senderRecipients,
    required this.receiverRecipients,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        fromCountryFlugPath: json["fromCountryFlugPath"],
        toCountryFlugPath: json["toCountryFlugPath"],
        defaultImage: json["default_image"],
        // agentWallet: AgentWallet.fromJson(json["agentWallet"]),
        transactionTypes: List<TransactionType>.from(
            json["transactionTypes"].map((x) => TransactionType.fromJson(x))),
        getRemainingFields: GetRemainingFields.fromJson(json["get_remaining_fields"]),

        remittanceCharge: RemittanceCharge.fromJson(json["remittanceCharge"]),
        fromCountry: List<Country>.from(
            json["fromCountry"].map((x) => Country.fromJson(x))),
        toCountries: List<Country>.from(
            json["toCountries"].map((x) => Country.fromJson(x))),
        senderRecipients: List<ErRecipient>.from(
            json["sender_recipients"].map((x) => ErRecipient.fromJson(x))),
        receiverRecipients: List<ErRecipient>.from(
            json["receiver_recipients"].map((x) => ErRecipient.fromJson(x))),
        transactions: List<dynamic>.from(json["transactions"].map((x) => x)),
      );
}class GetRemainingFields {
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

class Country {
  final int id;
  final String country;
  final String name;
  final String code;
  final String symbol;
  final dynamic flag;
  final double rate;
  final int status;
  final dynamic type;

  Country(
      {required this.id,
      required this.country,
      required this.name,
      required this.code,
      required this.symbol,
      this.flag,
      required this.rate,
      required this.status,
      required this.type});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        country: json["country"],
        name: json["name"],
        code: json["code"],
        symbol: json["symbol"],
        flag: json["flag"] ?? "",
        rate: double.parse(json["rate"] ?? "0.0"),
        status: json["status"],
        type: json["type"] ?? '',
      );
}

class ErRecipient {
  final int id;
  final int country;
  final String countryName;
  final String trxType;
  final String recipientType;
  final String trxTypeName;
  final String alias;
  final String firstname;
  final String lastname;
  final String email;
  final String mobileCode;
  final String mobile;
  final String city;
  final String state;
  final String address;
  final String zipCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  ErRecipient({
    required this.id,
    required this.country,
    required this.countryName,
    required this.trxType,
    required this.recipientType,
    required this.trxTypeName,
    required this.alias,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.mobileCode,
    required this.mobile,
    required this.city,
    required this.state,
    required this.address,
    required this.zipCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ErRecipient.fromJson(Map<String, dynamic> json) => ErRecipient(
        id: json["id"],
        country: json["country"],
        countryName: json["country_name"],
        trxType: json["trx_type"],
        recipientType: json["recipient_type"],
        trxTypeName: json["trx_type_name"],
        alias: json["alias"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        mobileCode: json["mobile_code"],
        mobile: json["mobile"],
        city: json["city"],
        state: json["state"],
        address: json["address"],
        zipCode: json["zip_code"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "country_name": countryName,
        "trx_type": trxType,
        "recipient_type": recipientType,
        "trx_type_name": trxTypeName,
        "alias": alias,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "mobile_code": mobileCode,
        "mobile": mobile,
        "city": city,
        "state": state,
        "address": address,
        "zip_code": zipCode,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class RemittanceCharge {
  final int id;
  final String slug;
  final String title;
  final dynamic fixedCharge;
  final dynamic percentCharge;
  final dynamic minLimit;
  final dynamic maxLimit;
  final dynamic monthlyLimit;
  final dynamic dailyLimit;
  final dynamic agentFixedCommissions;
  final dynamic agentPercentCommissions;
  final bool agentProfit;

  RemittanceCharge({
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

  factory RemittanceCharge.fromJson(Map<String, dynamic> json) =>
      RemittanceCharge(
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
