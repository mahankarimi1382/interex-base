import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  Message message;
  Data data;

  DashboardModel({
    required this.message,
    required this.data,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  final PusherCredentials pusherCredentials;
  String baseCurr;
  final ModuleAccess moduleAccess;
  List<UserWallet> userWallets;
  String defaultImage;
  String imagePath;
  bool pinVerification;
  Merchant merchant;
  String totalMoneyOut;
  String receiveMoney;
  String gatewayAmount;
  List<Transaction> transactions;

  Data({
    required this.pusherCredentials,
    required this.baseCurr,
    required this.moduleAccess,
    required this.userWallets,
    required this.defaultImage,
    required this.imagePath,
    required this.pinVerification,
    required this.merchant,
    required this.totalMoneyOut,
    required this.receiveMoney,
    required this.gatewayAmount,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pusherCredentials:
            PusherCredentials.fromJson(json["pusher_credentials"]),
        baseCurr: json["base_curr"],
        moduleAccess: ModuleAccess.fromJson(json["module_access"]),
        userWallets: List<UserWallet>.from(
            json["userWallets"].map((x) => UserWallet.fromJson(x))),
        defaultImage: json["default_image"],
        imagePath: json["image_path"],
        merchant: Merchant.fromJson(json["merchant"]),
        totalMoneyOut: json["totalMoneyOut"],
        pinVerification: json["pin_verification"],
        receiveMoney: json["receiveMoney"],
        gatewayAmount: json["gateway_amount"],
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pusher_credentials": pusherCredentials.toJson(),
        "base_curr": baseCurr,
        "module_access": moduleAccess.toJson(),
        "userWallets": List<dynamic>.from(userWallets.map((x) => x.toJson())),
        "default_image": defaultImage,
        "image_path": imagePath,
        "merchant": merchant.toJson(),
        "totalMoneyOut": totalMoneyOut,
        "receiveMoney": receiveMoney,
        "gateway_amount": gatewayAmount,
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
      };
}

class Merchant {
  int id;
  String firstname;
  String lastname;
  String businessName;
  String username;
  String email;
  String mobileCode;
  String mobile;
  String fullMobile;
  dynamic image;
  int status;
  bool pinStatus;
  int pinCode;
  Address address;
  int emailVerified;
  int smsVerified;
  int kycVerified;
  int twoFactorVerified;
  int twoFactorStatus;

  String fullname;
  String userImage;

  Merchant({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.businessName,
    required this.username,
    required this.email,
    required this.mobileCode,
    required this.mobile,
    required this.fullMobile,
    required this.image,
    required this.status,
    required this.pinStatus,
    required this.pinCode,
    required this.address,
    required this.emailVerified,
    required this.smsVerified,
    required this.kycVerified,
    required this.twoFactorVerified,
    required this.twoFactorStatus,
    required this.fullname,
    required this.userImage,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        businessName: json["business_name"],
        username: json["username"],
        email: json["email"],
        mobileCode: json["mobile_code"],
        mobile: json["mobile"],
        fullMobile: json["full_mobile"],
        image: json["image"] ?? '',
        status: json["status"],
        pinStatus: json["pin_status"],
        pinCode: json["pin_code"] ?? 0,
        address: Address.fromJson(json["address"]),
        emailVerified: json["email_verified"],
        smsVerified: json["sms_verified"],
        kycVerified: json["kyc_verified"],
        twoFactorVerified: json["two_factor_verified"],
        twoFactorStatus: json["two_factor_status"],
        fullname: json["fullname"],
        userImage: json["userImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "business_name": businessName,
        "username": username,
        "email": email,
        "mobile_code": mobileCode,
        "mobile": mobile,
        "full_mobile": fullMobile,
        "image": image,
        "status": status,
        "address": address.toJson(),
        "email_verified": emailVerified,
        "sms_verified": smsVerified,
        "kyc_verified": kycVerified,
        "two_factor_verified": twoFactorVerified,
        "two_factor_status": twoFactorStatus,
        "fullname": fullname,
        "userImage": userImage,
      };
}

class Address {
  String address;
  String city;
  String zip;
  String country;
  String state;

  Address({
    required this.address,
    required this.city,
    required this.zip,
    required this.country,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"],
        city: json["city"],
        zip: json["zip"],
        country: json["country"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "zip": zip,
        "country": country,
        "state": state,
      };
}

class Transaction {
  int id;
  String type;
  String trx;
  String transactionType;
  dynamic requestAmount;
  dynamic payable;
  String status;
  String remark;
  DateTime dateTime;

  Transaction({
    required this.id,
    required this.type,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.status,
    required this.remark,
    required this.dateTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        type: json["type"],
        trx: json["trx"],
        transactionType: json["transaction_type"],
        requestAmount: json["request_amount"],
        payable: json["payable"],
        status: json["status"],
        remark: json["remark"],
        dateTime: DateTime.parse(json["date_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "trx": trx,
        "transaction_type": transactionType,
        "request_amount": requestAmount,
        "payable": payable,
        "status": status,
        "remark": remark,
        "date_time": dateTime.toIso8601String(),
      };
}

class StatusInfo {
  int success;
  int pending;
  int rejected;

  StatusInfo({
    required this.success,
    required this.pending,
    required this.rejected,
  });

  factory StatusInfo.fromJson(Map<String, dynamic> json) => StatusInfo(
        success: json["success"],
        pending: json["pending"],
        rejected: json["rejected"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "pending": pending,
        "rejected": rejected,
      };
}

class UserWallet {
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
}

class ModuleAccess {
  final bool receiveMoney;
  final bool withdrawMoney;
  final bool developerApiKey;
  final bool gatewaySetting;
  final bool payLink;

  ModuleAccess({
    required this.receiveMoney,
    required this.withdrawMoney,
    required this.developerApiKey,
    required this.gatewaySetting,
    required this.payLink,
  });

  factory ModuleAccess.fromJson(Map<String, dynamic> json) => ModuleAccess(
        receiveMoney: json["receive_money"],
        withdrawMoney: json["withdraw_money"],
        developerApiKey: json["developer_api_key"],
        gatewaySetting: json["gateway_setting"],
        payLink: json["pay_link"],
      );

  Map<String, dynamic> toJson() => {
        "receive_money": receiveMoney,
        "withdraw_money": withdrawMoney,
        "developer_api_key": developerApiKey,
        "gateway_setting": gatewaySetting,
        "pay_link": payLink,
      };
}

class Message {
  List<String> success;

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

class PusherCredentials {
  final String instanceId;
  final String secretKey;

  PusherCredentials({
    required this.instanceId,
    required this.secretKey,
  });

  factory PusherCredentials.fromJson(Map<String, dynamic> json) =>
      PusherCredentials(
        instanceId: json["instanceId"],
        secretKey: json["secretKey"],
      );

  Map<String, dynamic> toJson() => {
        "instanceId": instanceId,
        "secretKey": secretKey,
      };
}

class Currency {
  int id;
  String code;
  dynamic country;
  dynamic rate;
  String? flag;
  String symbol;
  String type;
  int currencyDefault;
  bool both;
  bool senderCurrency;
  bool receiverCurrency;
  String? editData;
  String currencyImage;

  Currency({
    required this.id,
    required this.code,
    this.country,
    required this.rate,
    this.flag,
    required this.symbol,
    required this.type,
    required this.currencyDefault,
    required this.both,
    required this.senderCurrency,
    required this.receiverCurrency,
    this.editData,
    required this.currencyImage,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        code: json["code"],
        country: json["country"] ?? '',
        rate: json["rate"],
        flag: json["flag"] ?? "",
        symbol: json["symbol"],
        type: json["type"],
        currencyDefault: json["default"],
        both: json["both"],
        senderCurrency: json["senderCurrency"],
        receiverCurrency: json["receiverCurrency"],
        editData: json["editData"],
        currencyImage: json["currencyImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "country": country,
        "rate": rate,
        "flag": flag,
        "symbol": symbol,
        "type": type,
        "default": currencyDefault,
        "both": both,
        "senderCurrency": senderCurrency,
        "receiverCurrency": receiverCurrency,
        "editData": editData,
        "currencyImage": currencyImage,
      };
}
