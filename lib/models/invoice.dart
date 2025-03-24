import 'package:loccar_agency/utils/constants.dart';

class ModelInvoice {
  late int id, status;
  late String ref, source, file, createdAt, carInfo;
  late double total;
  late bool isClassified;

  ModelInvoice(
      {required this.id,
      required this.ref,
      required this.source,
      required this.total,
      required this.file,
      required this.carInfo,
      required this.createdAt,
      required this.status});

  ModelInvoice.another(
      {required this.id,
      required this.ref,
      required this.source,
      required this.total,
      required this.file,
      required this.createdAt,
      required this.isClassified,
      required this.status});

  static ModelInvoice fromJson(Map<String, dynamic> json) => ModelInvoice(
      id: json['id'],
      ref: json['ref'],
      source: json['source'],
      carInfo: json['car']['brand'] +
          " " +
          json['car']['model'] +
          " " +
          json['car']['carPlateNumber'],
      total: double.parse(json['total'].toString()),
      file: (json['file'] != null)
          ? "${Constants.mediaHost}/${json['file']}"
          : "",
      createdAt: json['createdAt'],
      status: json['state']);

  static ModelInvoice secondFromJson(Map<String, dynamic> json) =>
      ModelInvoice.another(
          id: json['id'],
          ref: json['ref'],
          source: json['source'],
          total: double.parse(json['total'].toString()),
          file: (json['file'] != null)
              ? "${Constants.mediaHost}/${json['file']}"
              : "",
          createdAt: json['createdAt'],
          status: json['state'],
          isClassified: json['isClassified']);
}
