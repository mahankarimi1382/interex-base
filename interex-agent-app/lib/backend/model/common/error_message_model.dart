class ErrorResponse {
  ErrorResponse({required this.message});

  final Message message;

  ErrorResponse.fromJson(Map<String, dynamic> json)
    : message = Message.fromJson(json['message']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message.toJson();
    return data;
  }
}

class Message {
  Message({required this.error});

  final List<String> error;

  Message.fromJson(Map<String, dynamic> json)
    : error = List.castFrom<dynamic, String>(json['error']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['error'] = error;
    return data;
  }
}
