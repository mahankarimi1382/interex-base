import 'dart:convert';

class TransactionLogModel {
  Message message;
  Data data;

  TransactionLogModel({
    required this.message,
    required this.data,
  });

  factory TransactionLogModel.fromRawJson(String str) =>
      TransactionLogModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionLogModel.fromJson(Map<String, dynamic> json) =>
      TransactionLogModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  TransactionTypes transactionTypes;
  Transactions transactions;

  Data({
    required this.transactionTypes,
    required this.transactions,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transactionTypes: TransactionTypes.fromJson(json["transaction_types"]),
        transactions: Transactions.fromJson(json["transactions"]),
      );

  Map<String, dynamic> toJson() => {
        "transaction_types": transactionTypes.toJson(),
        "transactions": transactions.toJson(),
      };
}

class TransactionTypes {
  String moneyOut;
  String merchantPayment;
  String receivedPayment;
  String addSubBalance;
  String payLink;

  TransactionTypes({
    required this.moneyOut,
    required this.merchantPayment,
    required this.receivedPayment,
    required this.addSubBalance,
    required this.payLink,
  });

  factory TransactionTypes.fromRawJson(String str) =>
      TransactionTypes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionTypes.fromJson(Map<String, dynamic> json) =>
      TransactionTypes(
        moneyOut: json["money_out"],
        merchantPayment: json["merchant_payment"],
        receivedPayment: json["received_payment"],
        addSubBalance: json["add_sub_balance"],
        payLink: json["pay_link"],
      );

  Map<String, dynamic> toJson() => {
        "money_out": moneyOut,
        "merchant_payment": merchantPayment,
        "received_payment": receivedPayment,
        "add_sub_balance": addSubBalance,
        "pay_link": payLink,
      };
}

class Transactions {
  List<MoneyOut> moneyOut;
  List<MerchantPayment> merchantPayment;
  List<MakePayment> makePayment;
  List<AddSubBalance> addSubBalance;
  List<PayPayLink> payLink;
  Transactions({
    required this.moneyOut,
    required this.merchantPayment,
    required this.makePayment,
    required this.addSubBalance,
    required this.payLink,
  });

  factory Transactions.fromRawJson(String str) =>
      Transactions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        moneyOut: List<MoneyOut>.from(
            json["money_out"].map((x) => MoneyOut.fromJson(x))),
        merchantPayment: List<MerchantPayment>.from(
            json["merchant_payment"].map((x) => MerchantPayment.fromJson(x))),
        makePayment: List<MakePayment>.from(
            json["make_payment"].map((x) => MakePayment.fromJson(x))),
        addSubBalance: List<AddSubBalance>.from(
            json["add_sub_balance"].map((x) => AddSubBalance.fromJson(x))),
        payLink: List<PayPayLink>.from(
            json["pay_link"].map((x) => PayPayLink.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "money_out": List<dynamic>.from(moneyOut.map((x) => x.toJson())),
        "merchant_payment":
            List<dynamic>.from(merchantPayment.map((x) => x.toJson())),
        "make_payment": List<dynamic>.from(makePayment.map((x) => x.toJson())),
        "add_sub_balance":
            List<dynamic>.from(addSubBalance.map((x) => x.toJson())),
        "pay_link": List<dynamic>.from(payLink.map((x) => x.toJson())),
      };
}

class AddSubBalance {
  int id;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String currentBalance;
  String receiveAmount;
  String exchangeRate;
  String totalCharge;
  String remark;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;

  AddSubBalance({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.currentBalance,
    required this.receiveAmount,
    required this.exchangeRate,
    required this.totalCharge,
    required this.remark,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory AddSubBalance.fromRawJson(String str) =>
      AddSubBalance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddSubBalance.fromJson(Map<String, dynamic> json) => AddSubBalance(
        id: json["id"],
        trx: json["trx"],
        transactionType: json["transaction_type"],
        transactionHeading: json["transaction_heading"],
        requestAmount: json["request_amount"],
        currentBalance: json["current_balance"],
        receiveAmount: json["receive_amount"],
        exchangeRate: json["exchange_rate"],
        totalCharge: json["total_charge"],
        remark: json["remark"],
        status: json["status"],
        dateTime: DateTime.parse(json["date_time"]),
        statusInfo: StatusInfo.fromJson(json["status_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trx": trx,
        "transaction_type": transactionType,
        "transaction_heading": transactionHeading,
        "request_amount": requestAmount,
        "current_balance": currentBalance,
        "receive_amount": receiveAmount,
        "exchange_rate": exchangeRate,
        "total_charge": totalCharge,
        "remark": remark,
        "status": status,
        "date_time": dateTime.toIso8601String(),
        "status_info": statusInfo.toJson(),
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

  factory StatusInfo.fromRawJson(String str) =>
      StatusInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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

class MakePayment {
  int id;
  String type;
  String trx;
  String transactionType;
  String transactionHeading;
  String recipientReceived;
  String currentBalance;
  String status;
  bool refundActionStatus;
  String refundActionUrl;
  String refundActionType;
  DateTime dateTime;
  StatusInfo statusInfo;

  MakePayment({
    required this.id,
    required this.type,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.recipientReceived,
    required this.currentBalance,
    required this.status,
    required this.refundActionStatus,
    required this.refundActionUrl,
    required this.refundActionType,
    required this.dateTime,
    required this.statusInfo,
  });

  factory MakePayment.fromRawJson(String str) =>
      MakePayment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MakePayment.fromJson(Map<String, dynamic> json) => MakePayment(
        id: json["id"],
        type: json["type"],
        trx: json["trx"],
        transactionType: json["transaction_type"],
        transactionHeading: json["transaction_heading"],
        recipientReceived: json["recipient_received"],
        currentBalance: json["current_balance"],
        status: json["status"],
        refundActionStatus: json["refund_action_status"],
        refundActionUrl: json["refund_action_url"],
        refundActionType: json["refund_action_type"],
        dateTime: DateTime.parse(json["date_time"]),
        statusInfo: StatusInfo.fromJson(json["status_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "trx": trx,
        "transaction_type": transactionType,
        "transaction_heading": transactionHeading,
        "recipient_received": recipientReceived,
        "current_balance": currentBalance,
        "status": status,
        "date_time": dateTime.toIso8601String(),
        "status_info": statusInfo.toJson(),
      };
}

class MerchantPayment {
  int id;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String payable;
  String envType;
  String sender;
  String businessName;
  String paymentAmount;
  String status;
  bool refundActionStatus;
  String refundActionUrl;
  String refundActionType;
  DateTime dateTime;
  StatusInfo statusInfo;
  String rejectionReason;

  MerchantPayment({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.payable,
    required this.envType,
    required this.sender,
    required this.businessName,
    required this.paymentAmount,
    required this.status,
    required this.refundActionStatus,
    required this.refundActionUrl,
    required this.refundActionType,
    required this.dateTime,
    required this.statusInfo,
    required this.rejectionReason,
  });

  factory MerchantPayment.fromRawJson(String str) =>
      MerchantPayment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MerchantPayment.fromJson(Map<String, dynamic> json) =>
      MerchantPayment(
        id: json["id"],
        trx: json["trx"],
        transactionType: json["transaction_type"],
        transactionHeading: json["transaction_heading"],
        requestAmount: json["request_amount"],
        payable: json["payable"],
        envType: json["env_type"],
        sender: json["sender"],
        businessName: json["business_name"],
        paymentAmount: json["payment_amount"],
        status: json["status"],
        refundActionStatus: json["refund_action_status"],
        refundActionUrl: json["refund_action_url"],
        refundActionType: json["refund_action_type"],
        dateTime: DateTime.parse(json["date_time"]),
        statusInfo: StatusInfo.fromJson(json["status_info"]),
        rejectionReason: json["rejection_reason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trx": trx,
        "transaction_type": transactionType,
        "transaction_heading": transactionHeading,
        "request_amount": requestAmount,
        "payable": payable,
        "env_type": envType,
        "sender": sender,
        "business_name": businessName,
        "payment_amount": paymentAmount,
        "status": status,
        "date_time": dateTime.toIso8601String(),
        "status_info": statusInfo.toJson(),
        "rejection_reason": rejectionReason,
      };
}

class MoneyOut {
  int id;
  String trx;
  String gatewayName;
  String gatewayCurrencyName;
  String transactionType;
  String requestAmount;
  String payable;
  String exchangeRate;
  String totalCharge;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;
  String rejectionReason;

  MoneyOut({
    required this.id,
    required this.trx,
    required this.gatewayName,
    required this.gatewayCurrencyName,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
    required this.rejectionReason,
  });

  factory MoneyOut.fromRawJson(String str) =>
      MoneyOut.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MoneyOut.fromJson(Map<String, dynamic> json) => MoneyOut(
        id: json["id"],
        trx: json["trx"],
        gatewayName: json["gateway_name"],
        gatewayCurrencyName: json["gateway_currency_name"],
        transactionType: json["transaction_type"],
        requestAmount: json["request_amount"],
        payable: json["payable"],
        exchangeRate: json["exchange_rate"],
        totalCharge: json["total_charge"],
        currentBalance: json["current_balance"],
        status: json["status"],
        dateTime: DateTime.parse(json["date_time"]),
        statusInfo: StatusInfo.fromJson(json["status_info"]),
        rejectionReason: json["rejection_reason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trx": trx,
        "gateway_name": gatewayName,
        "gateway_currency_name": gatewayCurrencyName,
        "transaction_type": transactionType,
        "request_amount": requestAmount,
        "payable": payable,
        "exchange_rate": exchangeRate,
        "total_charge": totalCharge,
        "current_balance": currentBalance,
        "status": status,
        "date_time": dateTime.toIso8601String(),
        "status_info": statusInfo.toJson(),
        "rejection_reason": rejectionReason,
      };
}

class Message {
  List<String> success;

  Message({
    required this.success,
  });

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
      };
}

class PayPayLink {
  final int id;
  final String trx;
  final String title;
  final String transactionType;
  final String requestAmount;
  final String payable;
  final String exchangeRate;
  final String totalCharge;
  final String currentBalance;
  final String paymentType;
  final PaymentTypeGatewayData paymentTypeGatewayData;
  final PaymentTypeCardData paymentTypeCardData;
  final PaymentTypeWalletData paymentTypeWalletData;
  final int statusValue;
  final String status;
  final DateTime dateTime;
  final StatusInfo statusInfo;

  PayPayLink({
    required this.id,
    required this.trx,
    required this.title,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.currentBalance,
    required this.paymentType,
    required this.paymentTypeGatewayData,
    required this.paymentTypeCardData,
    required this.paymentTypeWalletData,
    required this.statusValue,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory PayPayLink.fromJson(Map<String, dynamic> json) => PayPayLink(
        id: json["id"],
        trx: json["trx"],
        title: json["title"],
        transactionType: json["transaction_type"],
        requestAmount: json["request_amount"],
        payable: json["payable"],
        exchangeRate: json["exchange_rate"],
        totalCharge: json["total_charge"],
        currentBalance: json["current_balance"],
        paymentType: json["payment_type"],
        paymentTypeGatewayData:
            PaymentTypeGatewayData.fromJson(json["payment_type_gateway_data"]),
        paymentTypeCardData:
            PaymentTypeCardData.fromJson(json["payment_type_card_data"]),
        paymentTypeWalletData:
            PaymentTypeWalletData.fromJson(json["payment_type_wallet_data"]),
        statusValue: json["status_value"],
        status: json["status"],
        dateTime: DateTime.parse(json["date_time"]),
        statusInfo: StatusInfo.fromJson(json["status_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trx": trx,
        "title": title,
        "transaction_type": transactionType,
        "request_amount": requestAmount,
        "payable": payable,
        "exchange_rate": exchangeRate,
        "total_charge": totalCharge,
        "current_balance": currentBalance,
        "payment_type": paymentType,
        "payment_type_gateway_data": paymentTypeGatewayData.toJson(),
        "payment_type_card_data": paymentTypeCardData.toJson(),
        "payment_type_wallet_data": paymentTypeWalletData.toJson(),
        "status_value": statusValue,
        "status": status,
        "date_time": dateTime.toIso8601String(),
        "status_info": statusInfo.toJson(),
      };
}

class PaymentTypeCardData {
  final String senderEmail;
  final String cardHolderName;
  final String senderCardLast4;

  PaymentTypeCardData({
    required this.senderEmail,
    required this.cardHolderName,
    required this.senderCardLast4,
  });

  factory PaymentTypeCardData.fromJson(Map<String, dynamic> json) =>
      PaymentTypeCardData(
        senderEmail: json["sender_email"],
        cardHolderName: json["card_holder_name"],
        senderCardLast4: json["sender_card_last4"],
      );

  Map<String, dynamic> toJson() => {
        "sender_email": senderEmail,
        "card_holder_name": cardHolderName,
        "sender_card_last4": senderCardLast4,
      };
}

class PaymentTypeGatewayData {
  final String paymentGateway;

  PaymentTypeGatewayData({
    required this.paymentGateway,
  });

  factory PaymentTypeGatewayData.fromJson(Map<String, dynamic> json) =>
      PaymentTypeGatewayData(
        paymentGateway: json["payment_gateway"],
      );

  Map<String, dynamic> toJson() => {
        "payment_gateway": paymentGateway,
      };
}

class PaymentTypeWalletData {
  final String senderEmail;

  PaymentTypeWalletData({
    required this.senderEmail,
  });

  factory PaymentTypeWalletData.fromJson(Map<String, dynamic> json) =>
      PaymentTypeWalletData(
        senderEmail: json["sender_email"],
      );

  Map<String, dynamic> toJson() => {
        "sender_email": senderEmail,
      };
}
