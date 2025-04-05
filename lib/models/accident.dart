import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/models/owner.dart';

class AccidentModel {
  final int id;
  final int carId;
  final int ownerId;
  final int agencyId;
  final int ownerState;
  final int state;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CarModel? car;
  final OwnerModel? owner;

  AccidentModel({
    required this.id,
    required this.carId,
    required this.ownerId,
    required this.agencyId,
    required this.ownerState,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.car,
    this.owner,
  });

  factory AccidentModel.fromJson(Map<String, dynamic> json) {
    return AccidentModel(
      id: json['id'],
      carId: json['carId'],
      ownerId: json['ownerId'],
      agencyId: json['agencyId'],
      ownerState: json['ownerState'],
      state: json['state'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      car: json['car'] != null ? CarModel.fromJson(json['car']) : null,
      owner: json['owner'] != null ? OwnerModel.fromJson(json['owner']) : null,
    );
  }
}
