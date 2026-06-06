class UserSearchModel {
  final Message message;
  final Data data;

  UserSearchModel({
    required this.message,
    required this.data,
  });

  factory UserSearchModel.fromJson(Map<String, dynamic> json) => UserSearchModel(
    message: Message.fromJson(json["message"]),
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  final int receiverId;
  final String name;
  final String email;
  final String mobile;
  final String fullMobile;

  Data({
    required this.receiverId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.fullMobile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    receiverId: json["receiver_id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    fullMobile: json["full_mobile"],
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