import 'package:loccar_agency/utils/constants.dart';

class ModelReport {
  late int id, state;
  late String name, file, createdAt;

  ModelReport(
      {required this.id,
      required this.name,
      required this.file,
      required this.state,
      required this.createdAt});

  static ModelReport fromJson(Map<String, dynamic> json) => ModelReport(
      id: json['id'],
      state: json['state'],
      name: getTypeReport(json['target']),
      file: (json['file'] != null)
          ? "${Constants.mediaHost}/${json['file']}"
          : "",
      createdAt: json['createdAt']);

  static String getTypeReport(String first) {
    String message = "";
    switch (first) {
      case "sogenuvo-report":
        message = "RAPPORT SOGENUVO";
        break;
      case "diagnostic-report":
        message = "DIAGNOSTIC COMPLET";
        break;
      case "police-report":
        message = "RAPPORT DE POLICE";
        break;
      case "assurance-report":
        message = "RAPPORT ASSURANCE";
        break;
      default:
    }
    return message;
  }
}
