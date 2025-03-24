import 'package:loccar_agency/utils/constants.dart';

class ModelTechnicalVisit {
  late int id, status;
  late String issueDate, expiryDate, file, renewDate, technicalVisitNumber;

  ModelTechnicalVisit(
      {required this.id,
      required this.technicalVisitNumber,
      required this.issueDate,
      required this.expiryDate,
      required this.file,
      required this.renewDate,
      required this.status});

  static ModelTechnicalVisit fromJson(Map<String, dynamic> json) =>
      ModelTechnicalVisit(
        id: json['id'],
        issueDate: json['issueDate'],
        technicalVisitNumber: json['technicalVisitNumber'] ?? "",
        expiryDate: json['expiryDate'],
        file: (json['file'] != null)
            ? "${Constants.mediaHost}/${json['file']}"
            : "https://www.eplaque.fr/wp-content/uploads/2013/11/vignette-assurance.jpg",
        status: Constants.getDiffBetweenDates(json['expiryDate']).$2,
        renewDate: Constants.getDiffBetweenDates(json['expiryDate']).$1,
      );
}
