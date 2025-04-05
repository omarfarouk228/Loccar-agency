import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/models/owner.dart';

class BreakdownModel {
  final int id;
  final int ownerId;
  final int carId;
  final int agencyId;

  final double latitude;
  final double longitude;
  final String? report;
  final DateTime? reportDate;
  final int state;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CarModel? car;
  final OwnerModel? owner;

  BreakdownModel({
    required this.id,
    required this.ownerId,
    required this.carId,
    required this.agencyId,
    required this.latitude,
    required this.longitude,
    this.report,
    this.reportDate,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    this.car,
    this.owner,
  });

  factory BreakdownModel.fromJson(Map<String, dynamic> json) {
    return BreakdownModel(
      id: json['id'],
      ownerId: json['ownerId'],
      carId: json['carId'],
      agencyId: json['agencyId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      report: json['report'],
      reportDate: json['reportDate'] != null
          ? DateTime.parse(json['reportDate'])
          : null,
      state: json['state'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      car: json['car'] != null ? CarModel.fromJson(json['car']) : null,
      owner: json['owner'] != null ? OwnerModel.fromJson(json['owner']) : null,
    );
  }
}
