class UserListModel {
  final Data data;

  UserListModel({required this.data});

  factory UserListModel.fromJson(Map<String, dynamic> json) =>
      UserListModel(data: Data.fromJson(json["data"]));
}

class Data {
  final ChatBox chatBox;

  Data({required this.chatBox});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(chatBox: ChatBox.fromJson(json["chatBox"]));
}

class ChatBox {
  final int currentPage;
  final int lastPage;
  final List<Datum> data;

  ChatBox({
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory ChatBox.fromJson(Map<String, dynamic> json) => ChatBox(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );
}

class Datum {
  final String id;
  final String senderId;
  final String receiverId;
  final String token;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SenderImage senderImage;

  Datum({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.token,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.senderImage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"].toString(),
    senderId: json["sender_id"].toString(),
    receiverId: json["receiver_id"].toString(),
    token: json["token"] ?? "",
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"] ?? json["created_at"]),
    senderImage: SenderImage.fromJson(json["senderImage"]),
  );
}

class SenderImage {
  final String fullname;
  final String email;
  final String image;

  SenderImage({
    required this.fullname,
    required this.email,
    required this.image,
  });

  factory SenderImage.fromJson(Map<String, dynamic> json) => SenderImage(
    fullname: json["fullname"],
    email: json["email"],
    image: json["image"],
  );
}
