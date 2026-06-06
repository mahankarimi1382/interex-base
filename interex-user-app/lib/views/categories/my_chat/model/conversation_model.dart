class ConversationModel {
  final Data data;

  ConversationModel({
    required this.data,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) => ConversationModel(
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  final String chatBox;
  final List<PropertyConversation> propertyConversations;

  Data({
    required this.chatBox,
    required this.propertyConversations,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    chatBox: json["chatBox"].toString(),
    propertyConversations: List<PropertyConversation>.from(json["property_conversations"].map((x) => PropertyConversation.fromJson(x))),
  );
}

class PropertyConversation {
  final int id;
  final int sender;
  final String messageSender;
  final String message;
  final String profileImg;

  PropertyConversation({
    required this.id,
    required this.sender,
    required this.messageSender,
    required this.message,
    required this.profileImg,
  });

  factory PropertyConversation.fromJson(Map<String, dynamic> json) => PropertyConversation(
    id: int.parse(json["id"].toString()),
    sender: int.parse(json["sender"].toString()),
    messageSender: json["message_sender"],
    message: json["message"],
    profileImg: json["profile_img"],
  );
}