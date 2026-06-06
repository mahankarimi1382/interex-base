class TradeSubmitModel {
  final Message message;
  final Data data;

  TradeSubmitModel({
    required this.message,
    required this.data,
  });

  factory TradeSubmitModel.fromJson(Map<String, dynamic> json) => TradeSubmitModel(
    message: Message.fromJson(json["message"]),
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  final Preview preview;
  final Transaction transaction;

  Data({
    required this.preview,
    required this.transaction,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    preview: Preview.fromJson(json["preview"]),
    transaction: Transaction.fromJson(json["transaction"]),
  );
}

class Preview {
  final String message;
  final String details;
  final String qrcode;
  final int id;

  Preview({
    required this.message,
    required this.details,
    required this.qrcode,
    required this.id,
  });

  factory Preview.fromJson(Map<String, dynamic> json) => Preview(
    message: json["message"],
    details: json["details"],
    qrcode: json["qrcode"],
    id: json["id"],
  );
}

class Transaction {
  final String senderCurrency;
  final String receiverCurrency;
  final String senderAmount;
  final String receiverAmount;
  final double totalAmount;
  final double totalCharge;
  final double exchangeRate;
  final int sPrecision;
  final int rPrecision;

  Transaction({
    required this.senderCurrency,
    required this.receiverCurrency,
    required this.senderAmount,
    required this.receiverAmount,
    required this.totalAmount,
    required this.totalCharge,
    required this.exchangeRate,
    required this.sPrecision,
    required this.rPrecision,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    senderCurrency: json["sender_currency"],
    receiverCurrency: json["receiver_currency"],
    senderAmount: json["sender_amount"],
    receiverAmount: json["receiver_amount"],
    totalAmount: json["total_amount"].toDouble(),
    totalCharge: json["total_charge"].toDouble(),
    exchangeRate: json["exchange_rate"].toDouble(),
    sPrecision: json["sPrecision"],
    rPrecision: json["rPrecision"],
  );
}

class Message {
  final List<String> success;

  Message({
    required this.success,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    success: List<String>.from(json["success"].map((x) => x)),
  );
}
