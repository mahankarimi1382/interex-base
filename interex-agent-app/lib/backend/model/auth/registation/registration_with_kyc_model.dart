// To parse this JSON data, do
//
//     final registrationWithKycModel = registrationWithKycModelFromJson(jsonString);

import 'dart:convert';

RegistrationWithKycModel registrationWithKycModelFromJson(String str) =>
    RegistrationWithKycModel.fromJson(json.decode(str));

String registrationWithKycModelToJson(RegistrationWithKycModel data) =>
    json.encode(data.toJson());

class RegistrationWithKycModel {
  Message message;
  Data data;

  RegistrationWithKycModel({
    required this.message,
    required this.data,
  });

  factory RegistrationWithKycModel.fromJson(Map<String, dynamic> json) =>
      RegistrationWithKycModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String token;
  User user;

  Data({
    required this.token,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        user: User.fromJson(json["agent"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "agent": user.toJson(),
      };
}

class User {
  int id;

//
  User({
    required this.id,
  });
//
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
