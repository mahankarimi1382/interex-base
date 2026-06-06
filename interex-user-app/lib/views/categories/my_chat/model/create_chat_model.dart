class CreateChatModel {
  final Message message;
  final Data data;

  CreateChatModel({
    required this.message,
    required this.data,
  });

  factory CreateChatModel.fromJson(Map<String, dynamic> json) => CreateChatModel(
    message: Message.fromJson(json["message"]),
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  final int chatboxId;

  Data({
    required this.chatboxId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    chatboxId: json["Chatbox_id"],
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