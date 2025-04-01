class TechnicalVisitModel {
  final int id;
  final String? technicalVisitNumber;
  final int carId;
  final String file;
  final DateTime issueDate;
  final DateTime expiryDate;

  TechnicalVisitModel({
    required this.id,
    required this.carId,
    this.technicalVisitNumber,
    required this.file,
    required this.issueDate,
    required this.expiryDate,
  });

  factory TechnicalVisitModel.fromJson(Map<String, dynamic> json) {
    return TechnicalVisitModel(
      id: json['id'],
      technicalVisitNumber: json['technicalVisitNumber'],
      carId: json['carId'],
      file: json['file'],
      issueDate: json['issueDate'] == null
          ? DateTime.now()
          : DateTime.parse(json['issueDate']),
      expiryDate: json['issueDate'] == null
          ? DateTime.now()
          : DateTime.parse(json['expiryDate']),
    );
  }
}
