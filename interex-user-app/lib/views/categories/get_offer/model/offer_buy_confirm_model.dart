class OfferBuyConfirmModel {
  Message message;
  Data data;

  OfferBuyConfirmModel({
    required this.message,
    required this.data,
  });

  factory OfferBuyConfirmModel.fromJson(Map<String, dynamic> json) =>
      OfferBuyConfirmModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  String trxId;
  List<PaymentField> paymentFields;

  Data({
    required this.trxId,
    required this.paymentFields,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        trxId: json["trx_id"],
        paymentFields: List<PaymentField>.from(
            json["payment_fields"].map((x) => PaymentField.fromJson(x))),
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

  Message({
    required this.success,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
      );
}
