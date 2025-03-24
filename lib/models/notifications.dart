class ModelNotification {
  int id, status;
  String wording;
  String message;
  String createdAt;
  ModelNotification(
      {required this.id,
      required this.status,
      required this.wording,
      required this.message,
      required this.createdAt});

  factory ModelNotification.fromJson(Map<String, dynamic> json) =>
      ModelNotification(
          id: json['id'],
          status: json['state'],
          wording: json['wording'],
          message: json['message'],
          createdAt: json['createdAt']);
}
