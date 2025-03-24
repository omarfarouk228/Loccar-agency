import 'package:loccar_agency/utils/constants.dart';

class ModelAssurance {
  late int id, status;
  late String name, type, issueDate, expiryDate, file, renewDate, number;

  ModelAssurance(
      {required this.id,
      required this.name,
      required this.number,
      required this.type,
      required this.issueDate,
      required this.expiryDate,
      required this.file,
      required this.renewDate,
      required this.status});

  static ModelAssurance fromJson(Map<String, dynamic> json) => ModelAssurance(
        id: json['id'],
        name: json['name'],
        number: json['assuranceNumber'] ?? "",
        type: json['type'],
        issueDate: json['issueDate'],
        expiryDate: json['expiryDate'],
        file: (json['file'] != null)
            ? "${Constants.mediaHost}/${json['file']}"
            : "https://www.eplaque.fr/wp-content/uploads/2013/11/vignette-assurance.jpg",
        status: Constants.getDiffBetweenDates(json['expiryDate']).$2,
        renewDate: Constants.getDiffBetweenDates(json['expiryDate']).$1,
      );
}
