import 'dart:convert';

GatewaySettingsModel gatewaySettingsModelFromJson(String str) =>
    GatewaySettingsModel.fromJson(json.decode(str));

String gatewaySettingsModelToJson(GatewaySettingsModel data) =>
    json.encode(data.toJson());

class GatewaySettingsModel {
  Message message;
  Data data;

  GatewaySettingsModel({
    required this.message,
    required this.data,
  });

  factory GatewaySettingsModel.fromJson(Map<String, dynamic> json) =>
      GatewaySettingsModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  bool walletStatus;
  bool virtualCardStatus;
  bool masterVisaStatus;
  Credentials credentials;

  Data({
    required this.walletStatus,
    required this.virtualCardStatus,
    required this.masterVisaStatus,
    required this.credentials,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        walletStatus: json["wallet_status"],
        virtualCardStatus: json["virtual_card_status"],
        masterVisaStatus: json["master_visa_status"],
        credentials: Credentials.fromJson(json["credentials"]),
      );

  Map<String, dynamic> toJson() => {
        "wallet_status": walletStatus,
        "virtual_card_status": virtualCardStatus,
        "master_visa_status": masterVisaStatus,
        "credentials": credentials.toJson(),
      };
}

class Credentials {
  String primaryKey;
  String secretKey;

  Credentials({
    required this.primaryKey,
    required this.secretKey,
  });

  factory Credentials.fromJson(Map<String, dynamic> json) => Credentials(
        primaryKey: json["primary_key"],
        secretKey: json["secret_key"],
      );

  Map<String, dynamic> toJson() => {
        "primary_key": primaryKey,
        "secret_key": secretKey,
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
