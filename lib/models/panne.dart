import 'package:loccar_agency/utils/constants.dart';

class ModelPanne {
  late int id, status, ownerState, state;
  late String createdAt, report, reportDate;

  ModelPanne(
      {required this.id,
      required this.createdAt,
      required this.report,
      required this.reportDate,
      required this.ownerState,
      required this.state,
      required this.status});

  factory ModelPanne.fromJson(Map<String, dynamic> json) => ModelPanne(
      id: json['id'],
      createdAt: json['createdAt'],
      ownerState: json['ownerState'],
      state: json['state'],
      reportDate:
          (json['reportDate'] != null) ? json['reportDate'] : json['createdAt'],
      status: json['state'],
      report: (json['report'] != null)
          ? "${Constants.mediaHost}/${json['report']}"
          : "");
}
