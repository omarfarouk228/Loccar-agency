class OwnerModel {
  final int id;
  final String ref;
  final String accountType;
  final String email;
  final int agencyId;
  final int? administratorId;
  final int cardTypeId;
  final int balance;
  final String phoneNumber;
  final String? phoneNumberBis;
  final String fullName;
  final String idCardNumber;
  final String idCard;
  final String? photo;
  final String? socialReason;
  final String? professionalCardNumber;
  final String? professionalCard;
  final String? responsibleFullName;
  final String? fullAddress;
  final String? geolocalisation;
  final String password;
  final DateTime lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? carCount;

  OwnerModel({
    required this.id,
    required this.ref,
    required this.accountType,
    required this.email,
    required this.agencyId,
    this.administratorId,
    required this.cardTypeId,
    required this.balance,
    required this.phoneNumber,
    this.phoneNumberBis,
    required this.fullName,
    required this.idCardNumber,
    required this.idCard,
    this.photo,
    this.socialReason,
    this.professionalCardNumber,
    this.professionalCard,
    this.responsibleFullName,
    this.fullAddress,
    this.geolocalisation,
    required this.password,
    required this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
    this.carCount,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
        id: json['id'],
        ref: json['ref'],
        accountType: json['accountType'],
        email: json['email'],
        agencyId: json['agencyId'],
        administratorId: json['administratorId'],
        cardTypeId: json['cardTypeId'],
        balance: json['balance'],
        phoneNumber: json['phoneNumber'],
        phoneNumberBis: json['phoneNumberBis'],
        fullName: json['fullName'],
        idCardNumber: json['idCardNumber'],
        idCard: json['idCard'],
        photo: json['photo'],
        socialReason: json['socialReason'],
        professionalCardNumber: json['professionalCardNumber'],
        professionalCard: json['prefessionalCard'],
        responsibleFullName: json['responsibleFullName'],
        fullAddress: json['fullAddress'],
        geolocalisation: json['geolocalisation'],
        password: json['password'],
        lastLogin: DateTime.parse(json['lastLogin']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        carCount: json['carCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ref': ref,
        'accountType': accountType,
        'email': email,
        'agencyId': agencyId,
        'administratorId': administratorId,
        'cardTypeId': cardTypeId,
        'balance': balance,
        'phoneNumber': phoneNumber,
        'phoneNumberBis': phoneNumberBis,
        'fullName': fullName,
        'idCardNumber': idCardNumber,
        'idCard': idCard,
        'photo': photo,
        'socialReason': socialReason,
        'professionalCardNumber': professionalCardNumber,
        'prefessionalCard': professionalCard,
        'responsibleFullName': responsibleFullName,
        'fullAddress': fullAddress,
        'geolocalisation': geolocalisation,
        'password': password,
        'lastLogin': lastLogin.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'carCount': carCount
      };
}
