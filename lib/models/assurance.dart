class AssuranceModel {
  final int id;
  final String? assuranceNumber;
  final int carId;
  final String name;
  final String type;
  final String file;
  final DateTime issueDate;
  final DateTime expiryDate;

  AssuranceModel({
    required this.id,
    required this.carId,
    this.assuranceNumber,
    required this.name,
    required this.type,
    required this.file,
    required this.issueDate,
    required this.expiryDate,
  });

  factory AssuranceModel.fromJson(Map<String, dynamic> json) {
    return AssuranceModel(
      id: json['id'],
      assuranceNumber: json['assuranceNumber'],
      carId: json['carId'],
      name: json['name'],
      type: json['type'],
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
