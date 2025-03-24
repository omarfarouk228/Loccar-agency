import 'package:loccar_agency/utils/constants.dart';

class ModelEntretien {
  late int id, currentMileage, kilometersToGo, ownerState, state;
  late bool changeFilter;
  late String wording, oilName, file, createdAt, report, reportDate;

  ModelEntretien(
      {required this.id,
      required this.wording,
      required this.currentMileage,
      required this.changeFilter,
      required this.oilName,
      required this.file,
      required this.report,
      required this.reportDate,
      required this.createdAt,
      required this.kilometersToGo,
      required this.ownerState,
      required this.state});

  factory ModelEntretien.fromJson(Map<String, dynamic> json) => ModelEntretien(
        id: json['id'],
        wording: json['wording'],
        currentMileage: json['currentMileage'],
        reportDate: (json['reportDate'] != null)
            ? json['reportDate']
            : json['createdAt'],
        oilName: (json['oilName'] != null) ? json['oilName'] : "",
        changeFilter: json['changeFilter'],
        createdAt: json['createdAt'],
        file: (json['file'] != null)
            ? "${Constants.mediaHost}${json['file']}"
            : "",
        report: (json['report'] != null) ? json['report'] : "",
        kilometersToGo: json['kilometersToGo'],
        ownerState: json['ownerState'],
        state: json['state'],
      );
}
