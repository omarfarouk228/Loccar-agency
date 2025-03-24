import 'package:loccar_agency/utils/constants.dart';

class ModelTax {
  late int id, status;
  late String issueDate, expiryDate, file, renewDate, tvmNumber;

  ModelTax(
      {required this.id,
      required this.tvmNumber,
      required this.issueDate,
      required this.expiryDate,
      required this.file,
      required this.renewDate,
      required this.status});

  factory ModelTax.fromJson(Map<String, dynamic> json) => ModelTax(
        id: json['id'],
        tvmNumber: json['tvmNumber'] ?? "",
        issueDate: json['issueDate'],
        expiryDate: json['expiryDate'],
        file: (json['file'] != null)
            ? "${Constants.mediaHost}${json['file']}"
            : "https://www.eplaque.fr/wp-content/uploads/2013/11/vignette-assurance.jpg",
        status: Constants.getDiffBetweenDates(json['expiryDate']).$2,
        renewDate: Constants.getDiffBetweenDates(json['expiryDate']).$1,
      );
}
