class TvmModel {
  final int id;
  final String? tvmNumber;
  final int carId;
  final String file;
  final DateTime issueDate;
  final DateTime expiryDate;

  TvmModel({
    required this.id,
    required this.carId,
    this.tvmNumber,
    required this.file,
    required this.issueDate,
    required this.expiryDate,
  });

  factory TvmModel.fromJson(Map<String, dynamic> json) {
    return TvmModel(
      id: json['id'],
      tvmNumber: json['tvmNumber'],
      carId: json['carId'],
      file: json['file'],
      issueDate: json['issueDate'] == null
          ? DateTime.now()
          : DateTime.parse(json['issueDate']),
      expiryDate: json['expiryDate'] == null
          ? DateTime.now()
          : DateTime.parse(json['expiryDate']),
    );
  }
}
