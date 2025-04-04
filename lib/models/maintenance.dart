import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/models/owner.dart';

class MaintenanceModel {
  final int id;
  final int ownerId;
  final int carId;
  final int agencyId;
  final String wording;
  final double latitude;
  final double longitude;
  final String? report;
  final DateTime? reportDate;
  final int currentMileage;
  final String? oilName;
  final int kilometersToGo;
  final bool changeFilter;
  final int ownerState;
  final int state;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CarModel? car;
  final OwnerModel? owner;

  MaintenanceModel({
    required this.id,
    required this.ownerId,
    required this.carId,
    required this.agencyId,
    required this.wording,
    required this.latitude,
    required this.longitude,
    this.report,
    this.reportDate,
    required this.currentMileage,
    this.oilName,
    required this.kilometersToGo,
    required this.changeFilter,
    required this.ownerState,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    this.car,
    this.owner,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'],
      ownerId: json['ownerId'],
      carId: json['carId'],
      agencyId: json['agencyId'],
      wording: json['wording'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      report: json['report'],
      reportDate: json['reportDate'] != null
          ? DateTime.parse(json['reportDate'])
          : null,
      currentMileage: json['currentMileage'],
      oilName: json['oilName'],
      kilometersToGo: json['kilometersToGo'],
      changeFilter: json['changeFilter'],
      ownerState: json['ownerState'],
      state: json['state'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      car: json['car'] != null ? CarModel.fromJson(json['car']) : null,
      owner: json['owner'] != null ? OwnerModel.fromJson(json['owner']) : null,
    );
  }
}
