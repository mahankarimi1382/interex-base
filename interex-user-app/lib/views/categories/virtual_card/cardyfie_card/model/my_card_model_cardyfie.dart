// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final myCardCardyfieModel = myCardCardyfieModelFromJson(jsonString);

import 'dart:convert';

import '../../../../../widgets/payment_link/custom_drop_down.dart';

MyCardCardyfieModel myCardCardyfieModelFromJson(String str) =>
    MyCardCardyfieModel.fromJson(json.decode(str));

String myCardCardyfieModelToJson(MyCardCardyfieModel data) =>
    json.encode(data.toJson());

class MyCardCardyfieModel {
  Message message;
  Data data;

  MyCardCardyfieModel({required this.message, required this.data});

  factory MyCardCardyfieModel.fromJson(Map<String, dynamic> json) =>
      MyCardCardyfieModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  String baseCurr;
  int baseCurrRate;
  GetRemainingFields getRemainingFields;
  List<SupportedCurrency> supportedCurrency;
  bool cardCreateAction;
  bool customerCreateStatus;
  CardBasicInfo cardBasicInfo;
  List<MyCard> myCards;
  User user;
  List<UserWallet> userWallet;
  CardCharge cardCharge;
  List<dynamic> transactions;

  Data({
    required this.baseCurr,
    required this.baseCurrRate,
    required this.getRemainingFields,
    required this.supportedCurrency,
    required this.cardCreateAction,
    required this.customerCreateStatus,
    required this.cardBasicInfo,
    required this.myCards,
    required this.user,
    required this.userWallet,
    required this.cardCharge,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    baseCurr: json["base_curr"],
    baseCurrRate: json["base_curr_rate"],
    getRemainingFields: GetRemainingFields.fromJson(
      json["get_remaining_fields"],
    ),
    supportedCurrency: List<SupportedCurrency>.from(
      json["supported_currency"].map((x) => SupportedCurrency.fromJson(x)),
    ),
    cardCreateAction: json["card_create_action"],
    customerCreateStatus: json["customer_create_status"],
    cardBasicInfo: CardBasicInfo.fromJson(json["card_basic_info"]),
    myCards: List<MyCard>.from(json["myCards"].map((x) => MyCard.fromJson(x))),

    user: User.fromJson(json["user"]),
    userWallet: List<UserWallet>.from(
      json["userWallet"].map((x) => UserWallet.fromJson(x)),
    ),
    cardCharge: CardCharge.fromJson(json["cardCharge"]),
    transactions: List<dynamic>.from(json["transactions"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "base_curr": baseCurr,
    "base_curr_rate": baseCurrRate,
    "get_remaining_fields": getRemainingFields.toJson(),
    "supported_currency": List<dynamic>.from(
      supportedCurrency.map((x) => x.toJson()),
    ),
    "card_create_action": cardCreateAction,
    "customer_create_status": customerCreateStatus,
    "card_basic_info": cardBasicInfo.toJson(),
    "myCards": List<dynamic>.from(myCards.map((x) => x.toJson())),
    "user": user.toJson(),
    "userWallet": List<dynamic>.from(userWallet.map((x) => x.toJson())),
    "cardCharge": cardCharge.toJson(),
    "transactions": List<dynamic>.from(transactions.map((x) => x)),
  };
}

class CardBasicInfo {
  int cardCreateLimit;
  String cardBackDetails;
  String cardBg;
  String siteTitle;
  String siteLogo;
  String siteFav;

  CardBasicInfo({
    required this.cardCreateLimit,
    required this.cardBackDetails,
    required this.cardBg,
    required this.siteTitle,
    required this.siteLogo,
    required this.siteFav,
  });

  factory CardBasicInfo.fromJson(Map<String, dynamic> json) => CardBasicInfo(
    cardCreateLimit: json["card_create_limit"],
    cardBackDetails: json["card_back_details"],
    cardBg: json["card_bg"],
    siteTitle: json["site_title"],
    siteLogo: json["site_logo"],
    siteFav: json["site_fav"],
  );

  Map<String, dynamic> toJson() => {
    "card_create_limit": cardCreateLimit,
    "card_back_details": cardBackDetails,
    "card_bg": cardBg,
    "site_title": siteTitle,
    "site_logo": siteLogo,
    "site_fav": siteFav,
  };
}

class CardCharge {
  int universalCardIssuesFee;
  int platinumCardIssuesFee;
  int cardDepositFixedFee;
  int cardWithdrawFixedFee;
  int cardDepositPercentFee;
  int cardWithdrawPercentFee;
  int minLimit;
  int maxLimit;
  int dailyLimit;
  int monthlyLimit;

  CardCharge({
    required this.universalCardIssuesFee,
    required this.platinumCardIssuesFee,
    required this.cardDepositFixedFee,
    required this.cardWithdrawFixedFee,
    required this.cardDepositPercentFee,
    required this.cardWithdrawPercentFee,
    required this.minLimit,
    required this.maxLimit,
    required this.dailyLimit,
    required this.monthlyLimit,
  });

  factory CardCharge.fromJson(Map<String, dynamic> json) => CardCharge(
    universalCardIssuesFee: json["universal_card_issues_fee"],
    platinumCardIssuesFee: json["platinum_card_issues_fee"],
    cardDepositFixedFee: json["card_deposit_fixed_fee"],
    cardWithdrawFixedFee: json["card_withdraw_fixed_fee"],
    cardDepositPercentFee: json["card_deposit_percent_fee"],
    cardWithdrawPercentFee: json["card_withdraw_percent_fee"],
    minLimit: json["min_limit"],
    maxLimit: json["max_limit"],
    dailyLimit: json["daily_limit"],
    monthlyLimit: json["monthly_limit"],
  );

  Map<String, dynamic> toJson() => {
    "universal_card_issues_fee": universalCardIssuesFee,
    "platinum_card_issues_fee": platinumCardIssuesFee,
    "card_deposit_fixed_fee": cardDepositFixedFee,
    "card_withdraw_fixed_fee": cardWithdrawFixedFee,
    "card_deposit_percent_fee": cardDepositPercentFee,
    "card_withdraw_percent_fee": cardWithdrawPercentFee,
    "min_limit": minLimit,
    "max_limit": maxLimit,
    "daily_limit": dailyLimit,
    "monthly_limit": monthlyLimit,
  };
}

class GetRemainingFields {
  String transactionType;
  String attribute;

  GetRemainingFields({required this.transactionType, required this.attribute});

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

class MyCard {
  int id;
  String referenceId;
  String ulid;
  String customerUlid;
  String cardName;
  int amount;
  String currency;
  String cardTier;
  String cardType;
  String cardExpTime;
  String maskedPan;
  String address;
  String status;
  String env;
  bool isDefault;
  MyCardStatusInfo statusInfo;

  MyCard({
    required this.id,
    required this.referenceId,
    required this.ulid,
    required this.customerUlid,
    required this.cardName,
    required this.amount,
    required this.currency,
    required this.cardTier,
    required this.cardType,
    required this.cardExpTime,
    required this.maskedPan,
    required this.address,
    required this.status,
    required this.env,
    required this.isDefault,
    required this.statusInfo,
  });

  factory MyCard.fromJson(Map<String, dynamic> json) => MyCard(
    id: json["id"],
    referenceId: json["reference_id"],
    ulid: json["ulid"],
    customerUlid: json["customer_ulid"],
    cardName: json["card_name"],
    amount: json["amount"],
    currency: json["currency"],
    cardTier: json["card_tier"],
    cardType: json["card_type"],
    cardExpTime: json["card_exp_time"],
    maskedPan: json["masked_pan"],
    address: json["address"],
    status: json["status"],
    env: json["env"],
    isDefault: json["is_default"],
    statusInfo: MyCardStatusInfo.fromJson(json["status_info"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference_id": referenceId,
    "ulid": ulid,
    "customer_ulid": customerUlid,
    "card_name": cardName,
    "amount": amount,
    "currency": currency,
    "card_tier": cardTier,
    "card_type": cardType,
    "card_exp_time": cardExpTime,
    "masked_pan": maskedPan,
    "address": address,
    "status": status,
    "env": env,
    "is_default": isDefault,
    "status_info": statusInfo.toJson(),
  };
}

class MyCardStatusInfo {
  String processing;
  String enabled;
  String freeze;
  String closed;

  MyCardStatusInfo({
    required this.processing,
    required this.enabled,
    required this.freeze,
    required this.closed,
  });

  factory MyCardStatusInfo.fromJson(Map<String, dynamic> json) =>
      MyCardStatusInfo(
        processing: json["PROCESSING"],
        enabled: json["ENABLED"],
        freeze: json["FREEZE"],
        closed: json["CLOSED"],
      );

  Map<String, dynamic> toJson() => {
    "PROCESSING": processing,
    "ENABLED": enabled,
    "FREEZE": freeze,
    "CLOSED": closed,
  };
}

class SupportedCurrency implements DropdownModel {
  int id;
  String country;
  String name;
  String code;
  String symbol;
  String type;
  String flag;
  String rate;
  int supportedCurrencyDefault;
  int status;
  String currencyImage;

  SupportedCurrency({
    required this.id,
    required this.country,
    required this.name,
    required this.code,
    required this.symbol,
    required this.type,
    required this.flag,
    required this.rate,
    required this.supportedCurrencyDefault,
    required this.status,
    required this.currencyImage,
  });

  factory SupportedCurrency.fromJson(Map<String, dynamic> json) =>
      SupportedCurrency(
        id: json["id"],
        country: json["country"],
        name: json["name"],
        code: json["code"],
        symbol: json["symbol"],
        type: json["type"],
        flag: json["flag"],
        rate: json["rate"],
        supportedCurrencyDefault: json["default"],
        status: json["status"],
        currencyImage: json["currencyImage"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country": country,
    "name": name,
    "code": code,
    "symbol": symbol,
    "type": type,
    "flag": flag,
    "rate": rate,
    "default": supportedCurrencyDefault,
    "status": status,
    "currencyImage": currencyImage,
  };

  @override
  String get title => code;
}

class User {
  int id;
  String firstname;
  String lastname;
  String username;
  String email;
  String mobileCode;
  String mobile;
  String fullMobile;
  bool pinStatus;
  // int pinCode;
  // String referralId;
  dynamic currentReferralLevelId;
  dynamic image;
  int status;
  Address address;
  int emailVerified;
  int smsVerified;
  int kycVerified;
  dynamic verCode;
  dynamic verCodeSendAt;
  int twoFactorVerified;
  int twoFactorStatus;
  dynamic twoFactorSecret;
  dynamic deviceId;
  dynamic emailVerifiedAt;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic sudoCustomer;
  dynamic sudoAccount;
  dynamic stripeCardHolders;
  dynamic stripeTestCardHolder;
  dynamic stripeConnectedAccount;
  dynamic stripeFinancialAccount;
  dynamic strowalletCustomer;
  String registeredBy;
  String fullname;
  String userImage;
  StringStatus stringStatus;
  String lastLogin;
  StringStatus kycStringStatus;
  List<CardyfieCardCustomer> cardyfieCardCustomer;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.mobileCode,
    required this.mobile,
    required this.fullMobile,
    required this.pinStatus,
    // required this.pinCode,
    // required this.referralId,
    required this.currentReferralLevelId,
    required this.image,
    required this.status,
    required this.address,
    required this.emailVerified,
    required this.smsVerified,
    required this.kycVerified,
    required this.verCode,
    required this.verCodeSendAt,
    required this.twoFactorVerified,
    required this.twoFactorStatus,
    required this.twoFactorSecret,
    required this.deviceId,
    required this.emailVerifiedAt,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.sudoCustomer,
    required this.sudoAccount,
    required this.stripeCardHolders,
    required this.stripeTestCardHolder,
    required this.stripeConnectedAccount,
    required this.stripeFinancialAccount,
    required this.strowalletCustomer,
    required this.registeredBy,
    required this.fullname,
    required this.userImage,
    required this.stringStatus,
    required this.lastLogin,
    required this.kycStringStatus,
    required this.cardyfieCardCustomer,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
    email: json["email"],
    mobileCode: json["mobile_code"],
    mobile: json["mobile"],
    fullMobile: json["full_mobile"],
    pinStatus: json["pin_status"],
    // pinCode: json["pin_code"],
    // referralId: json["referral_id"],
    currentReferralLevelId: json["current_referral_level_id"],
    image: json["image"],
    status: json["status"],
    address: Address.fromJson(json["address"]),
    emailVerified: json["email_verified"],
    smsVerified: json["sms_verified"],
    kycVerified: json["kyc_verified"],
    verCode: json["ver_code"],
    verCodeSendAt: json["ver_code_send_at"],
    twoFactorVerified: json["two_factor_verified"],
    twoFactorStatus: json["two_factor_status"],
    twoFactorSecret: json["two_factor_secret"],
    deviceId: json["device_id"],
    emailVerifiedAt: json["email_verified_at"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    sudoCustomer: json["sudo_customer"],
    sudoAccount: json["sudo_account"],
    stripeCardHolders: json["stripe_card_holders"],
    stripeTestCardHolder: json["stripe_test_card_holder"],
    stripeConnectedAccount: json["stripe_connected_account"],
    stripeFinancialAccount: json["stripe_financial_account"],
    strowalletCustomer: json["strowallet_customer"],
    registeredBy: json["registered_by"],
    fullname: json["fullname"],
    userImage: json["userImage"],
    stringStatus: StringStatus.fromJson(json["stringStatus"]),
    lastLogin: json["lastLogin"],
    kycStringStatus: StringStatus.fromJson(json["kycStringStatus"]),
    cardyfieCardCustomer: List<CardyfieCardCustomer>.from(
      json["cardyfie_card_customer"].map(
        (x) => CardyfieCardCustomer.fromJson(x),
      ),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "email": email,
    "mobile_code": mobileCode,
    "mobile": mobile,
    "full_mobile": fullMobile,
    "pin_status": pinStatus,
    // "pin_code": pinCode,
    // "referral_id": referralId,
    "current_referral_level_id": currentReferralLevelId,
    "image": image,
    "status": status,
    "address": address.toJson(),
    "email_verified": emailVerified,
    "sms_verified": smsVerified,
    "kyc_verified": kycVerified,
    "ver_code": verCode,
    "ver_code_send_at": verCodeSendAt,
    "two_factor_verified": twoFactorVerified,
    "two_factor_status": twoFactorStatus,
    "two_factor_secret": twoFactorSecret,
    "device_id": deviceId,
    "email_verified_at": emailVerifiedAt,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "sudo_customer": sudoCustomer,
    "sudo_account": sudoAccount,
    "stripe_card_holders": stripeCardHolders,
    "stripe_test_card_holder": stripeTestCardHolder,
    "stripe_connected_account": stripeConnectedAccount,
    "stripe_financial_account": stripeFinancialAccount,
    "strowallet_customer": strowalletCustomer,
    "registered_by": registeredBy,
    "fullname": fullname,
    "userImage": userImage,
    "stringStatus": stringStatus.toJson(),
    "lastLogin": lastLogin,
    "kycStringStatus": kycStringStatus.toJson(),
    "cardyfie_card_customer": List<dynamic>.from(
      cardyfieCardCustomer.map((x) => x.toJson()),
    ),
  };
}

class Address {
  String country;
  String city;
  String zip;
  String state;
  String address;

  Address({
    required this.country,
    required this.city,
    required this.zip,
    required this.state,
    required this.address,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    country: json["country"],
    city: json["city"],
    zip: json["zip"],
    state: json["state"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "city": city,
    "zip": zip,
    "state": state,
    "address": address,
  };
}

class CardyfieCardCustomer {
  int id;
  String userType;
  int userId;
  String ulid;
  String referenceId;
  String firstName;
  String lastName;
  String email;
  // DateTime dateOfBirth;
  String idType;
  String idNumber;
  String? idFrontImage;
  String cardyfieCardCustomerIdBackImage;
  String cardyfieCardCustomerUserImage;
  String houseNumber;
  String addressLine1;
  String city;
  String state;
  String zipCode;
  String country;
  String status;
  String env;
  dynamic meta;
  DateTime createdAt;
  DateTime updatedAt;
  String idFontImage;
  String idBackImage;
  String userImage;

  CardyfieCardCustomer({
    required this.id,
    required this.userType,
    required this.userId,
    required this.ulid,
    required this.referenceId,
    required this.firstName,
    required this.lastName,
    required this.email,
    // required this.dateOfBirth,
    required this.idType,
    required this.idNumber,
    this.idFrontImage,
    required this.cardyfieCardCustomerIdBackImage,
    required this.cardyfieCardCustomerUserImage,
    required this.houseNumber,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.status,
    required this.env,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
    required this.idFontImage,
    required this.idBackImage,
    required this.userImage,
  });

  factory CardyfieCardCustomer.fromJson(Map<String, dynamic> json) =>
      CardyfieCardCustomer(
        id: json["id"],
        userType: json["user_type"],
        userId: json["user_id"],
        ulid: json["ulid"],
        referenceId: json["reference_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        // dateOfBirth: DateTime.parse(json["date_of_birth"]),
        idType: json["id_type"],
        idNumber: json["id_number"],
        idFrontImage: json["id_front_image"] ?? '',
        cardyfieCardCustomerIdBackImage: json["id_back_image"],
        cardyfieCardCustomerUserImage: json["user_image"],
        houseNumber: json["house_number"],
        addressLine1: json["address_line_1"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zip_code"],
        country: json["country"],
        status: json["status"],
        env: json["env"],
        meta: json["meta"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        idFontImage: json["idFontImage"],
        idBackImage: json["idBackImage"],
        userImage: json["userImage"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_type": userType,
    "user_id": userId,
    "ulid": ulid,
    "reference_id": referenceId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    // "date_of_birth":
    //     "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "id_type": idType,
    "id_number": idNumber,
    "id_front_image": idFrontImage ?? '',
    "id_back_image": cardyfieCardCustomerIdBackImage,
    "user_image": cardyfieCardCustomerUserImage,
    "house_number": houseNumber,
    "address_line_1": addressLine1,
    "city": city,
    "state": state,
    "zip_code": zipCode,
    "country": country,
    "status": status,
    "env": env,
    "meta": meta,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "idFontImage": idFontImage,
    "idBackImage": idBackImage,
    "userImage": userImage,
  };
}

class StringStatus {
  String stringStatusClass;
  String value;

  StringStatus({required this.stringStatusClass, required this.value});

  factory StringStatus.fromJson(Map<String, dynamic> json) =>
      StringStatus(stringStatusClass: json["class"], value: json["value"]);

  Map<String, dynamic> toJson() => {"class": stringStatusClass, "value": value};
}

class UserWallet implements DropdownModel {
  dynamic balance;
  int status;
  Currency currency;

  UserWallet({
    required this.balance,
    required this.status,
    required this.currency,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
    balance: json["balance"],
    status: json["status"],
    currency: Currency.fromJson(json["currency"]),
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "status": status,
    "currency": currency.toJson(),
  };

  @override
  String get title => currency.name;
}

class Currency {
  int id;
  String code;
  String rate;
  String? flag;
  String symbol;
  String type;
  int currencyDefault;
  String country;
  String name;
  bool both;
  bool senderCurrency;
  bool receiverCurrency;
  String? editData;
  String currencyImage;

  Currency({
    required this.id,
    required this.code,
    required this.rate,
    this.flag,
    required this.symbol,
    required this.type,
    required this.currencyDefault,
    required this.country,
    required this.name,
    required this.both,
    required this.senderCurrency,
    required this.receiverCurrency,
    this.editData,
    required this.currencyImage,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    code: json["code"],
    rate: json["rate"],
    flag: json["flag"] ?? "",
    symbol: json["symbol"],
    type: json["type"],
    currencyDefault: json["default"],
    country: json["country"],
    name: json["name"],
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
    "flag": flag ?? "",
    "symbol": symbol,
    "type": type,
    "default": currencyDefault,
    "country": country,
    "name": name,
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
