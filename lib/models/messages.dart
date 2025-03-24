class ChatMessage {
  String sender;
  String comment;
  String createdAt;
  ChatMessage(
      {required this.sender, required this.comment, required this.createdAt});

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
      sender: json['sender'],
      comment: json['comment'],
      createdAt: json['createdAt']);
}
