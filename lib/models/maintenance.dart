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
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'],
      ownerId: json['owner_id'],
      carId: json['car_id'],
      agencyId: json['agency_id'],
      wording: json['wording'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      report: json['report'],
      reportDate: json['report_date'] != null
          ? DateTime.parse(json['report_date'])
          : null,
      currentMileage: json['current_mileage'],
      oilName: json['oil_name'],
      kilometersToGo: json['kilometers_to_go'],
      changeFilter: json['change_filter'],
      ownerState: json['owner_state'],
      state: json['state'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
