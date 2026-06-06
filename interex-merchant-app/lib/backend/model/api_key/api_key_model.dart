import 'dart:convert';

ApiKeyModel apiKeyModelFromJson(String str) =>
    ApiKeyModel.fromJson(json.decode(str));

String apiKeyModelToJson(ApiKeyModel data) => json.encode(data.toJson());

class ApiKeyModel {
  final Message message;
  final Data data;

  ApiKeyModel({
    required this.message,
    required this.data,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) => ApiKeyModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  final List<KeyModel> keys;

  Data({
    required this.keys,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        keys:
            List<KeyModel>.from(json["keys"].map((x) => KeyModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "keys": List<dynamic>.from(keys.map((x) => x.toJson())),
      };
}

class KeyModel {
  final int id;
  final dynamic name;
  final String clientId;
  final String clientSecret;
  final String mode;
  final bool status;
  final DateTime createdAt;

  KeyModel({
    required this.id,
    this.name,
    required this.clientId,
    required this.clientSecret,
    required this.mode,
    required this.status,
    required this.createdAt,
  });

  factory KeyModel.fromJson(Map<String, dynamic> json) => KeyModel(
        id: json["id"],
        name: json["name"] ?? '',
        clientId: json["client_id"],
        clientSecret: json["client_secret"],
        mode: json["mode"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "client_id": clientId,
        "client_secret": clientSecret,
        "mode": mode,
        "status": status,
        "created_at": createdAt.toIso8601String(),
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
