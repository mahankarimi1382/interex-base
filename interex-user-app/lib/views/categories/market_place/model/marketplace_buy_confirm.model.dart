class MarketplaceBuyConfirmModel {
  Message message;
  MarketplaceBuyConfirmModelData data;

  MarketplaceBuyConfirmModel({required this.message, required this.data});

  factory MarketplaceBuyConfirmModel.fromJson(Map<String, dynamic> json) =>
      MarketplaceBuyConfirmModel(
        message: Message.fromJson(json["message"]),
        data: MarketplaceBuyConfirmModelData.fromJson(json["data"]),
      );
}

class MarketplaceBuyConfirmModelData {
  String trxId;
  List<PaymentField> paymentFields;

  MarketplaceBuyConfirmModelData({
    required this.trxId,
    required this.paymentFields,
  });

  factory MarketplaceBuyConfirmModelData.fromJson(Map<String, dynamic> json) =>
      MarketplaceBuyConfirmModelData(
        trxId: json["trx_id"],
        paymentFields: List<PaymentField>.from(
          json["payment_fields"].map((x) => PaymentField.fromJson(x)),
        ),
      );
}

class DataData {
  String target;
  String gatewayId;
  String rateCurrency;
  int paymentGatewayId;
  String willGet;
  String saleCurrency;
  String amount;
  String subtotal;
  Wallet wallet;
  int fixedCharge;
  int percentCharge;
  int totalCharge;
  int totalAmount;
  String transactionType;

  DataData({
    required this.target,
    required this.gatewayId,
    required this.rateCurrency,
    required this.paymentGatewayId,
    required this.willGet,
    required this.saleCurrency,
    required this.amount,
    required this.subtotal,
    required this.wallet,
    required this.fixedCharge,
    required this.percentCharge,
    required this.totalCharge,
    required this.totalAmount,
    required this.transactionType,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    target: json["target"],
    gatewayId: json["gateway_id"],
    rateCurrency: json["rate_currency"],
    paymentGatewayId: json["payment_gateway_id"],
    willGet: json["will_get"],
    saleCurrency: json["sale_currency"],
    amount: json["amount"],
    subtotal: json["subtotal"],
    wallet: Wallet.fromJson(json["wallet"]),
    fixedCharge: json["fixed_charge"],
    percentCharge: json["percent_charge"],
    totalCharge: json["total_charge"],
    totalAmount: json["total_amount"],
    transactionType: json["transaction_type"],
  );
}

class Wallet {
  int id;
  int userId;
  int currencyId;
  String balance;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.currencyId,
    required this.balance,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["id"],
    userId: json["user_id"],
    currencyId: json["currency_id"],
    balance: json["balance"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );
}

class PaymentField {
  String type;
  String label;
  String name;
  bool required;
  Validation validation;

  PaymentField({
    required this.type,
    required this.label,
    required this.name,
    required this.required,
    required this.validation,
  });

  factory PaymentField.fromJson(Map<String, dynamic> json) => PaymentField(
    type: json["type"],
    label: json["label"],
    name: json["name"],
    required: json["required"],
    validation: Validation.fromJson(json["validation"]),
  );
}

class Validation {
  String max;
  List<String> mimes;
  dynamic min;
  List<dynamic> options;
  bool required;

  Validation({
    required this.max,
    required this.mimes,
    required this.min,
    required this.options,
    required this.required,
  });

  factory Validation.fromJson(Map<String, dynamic> json) => Validation(
    max: json["max"],
    mimes: List<String>.from(json["mimes"].map((x) => x)),
    min: json["min"],
    options: List<dynamic>.from(json["options"].map((x) => x)),
    required: json["required"],
  );
}

class Message {
  List<String> success;

  Message({required this.success});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(success: List<String>.from(json["success"].map((x) => x)));
}
