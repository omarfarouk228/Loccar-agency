import 'package:loccar_agency/models/owner.dart';

class TransactionModel {
  int id;
  int senderId;
  String senderType;
  int receiverId;
  String receiverType;
  int amount;
  int paymentId;
  String transactionType;
  String status;
  int? validatedBy;
  String? validatedByType;
  DateTime? validatedAt;
  DateTime createdAt;
  DateTime updatedAt;
  OwnerModel receiverOwner;
  String senderAgency;

  TransactionModel({
    required this.id,
    required this.senderId,
    required this.senderType,
    required this.receiverId,
    required this.receiverType,
    required this.amount,
    required this.paymentId,
    required this.transactionType,
    required this.status,
    this.validatedBy,
    this.validatedByType,
    this.validatedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.receiverOwner,
    required this.senderAgency,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      senderId: json['sender_id'],
      senderType: json['sender_type'],
      receiverId: json['receiver_id'],
      receiverType: json['receiver_type'],
      amount: json['amount'],
      paymentId: json['payment_id'],
      transactionType: json['transaction_type'],
      status: json['status'],
      validatedBy: json['validated_by'],
      validatedByType: json['validated_by_type'],
      validatedAt: json['validated_at'] != null
          ? DateTime.parse(json['validated_at'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      receiverOwner: OwnerModel.fromJson(json['receiverOwner']),
      senderAgency: json['senderAgency']['fullname'],
    );
  }
}
