class CheckRegisterUserModel {
  CheckRegisterUserModel({
    required this.message,
  });

  Message message;

  factory CheckRegisterUserModel.fromJson(Map<String, dynamic> json) =>
      CheckRegisterUserModel(
        message: Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
      };
}

class Message {
  Message({
    required this.success,
  });

  List<String> success;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
      };
}

class Data {
  final Agent agent;

  Data({
    required this.agent,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        agent: Agent.fromJson(json["agent"]),
      );

  Map<String, dynamic> toJson() => {
        "agent": agent.toJson(),
      };
}

class Agent {
  final int id;

  Agent({
    required this.id,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
