class PaymentModel {
  final int id;
  final int? carId;
  final int? ownerId;
  final int agencyId;
  final int ownerState;
  final int state;
  final String? author;
  final int amount;
  final String channel;
  final String operation;
  final String wording;
  final String? entrySource;
  final String? status;
  final String? fullName;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentModel({
    required this.id,
    this.carId,
    this.ownerId,
    required this.agencyId,
    required this.ownerState,
    required this.state,
    this.author,
    required this.amount,
    required this.channel,
    required this.operation,
    required this.wording,
    this.entrySource,
    this.status,
    this.fullName,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      carId: json['carId'],
      ownerId: json['ownerId'],
      agencyId: json['agencyId'],
      ownerState: json['ownerState'],
      state: json['state'],
      author: json['author'],
      amount: json['amount'],
      channel: json['channel'],
      operation: json['operation'],
      wording: json['wording'],
      entrySource: json['entrySource'],
      status: json['status'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
