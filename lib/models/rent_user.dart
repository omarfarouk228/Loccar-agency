class RentUserModel {
  final int id;
  final String userName;
  final String phoneNumber;
  final String gender;
  final String dateOfBirth;
  final String lastName;
  final String firstName;
  final bool isSafe;
  final String? nicFile;
  final String? nicNumber;
  final String? driverLicense;
  final String? driverLicenseExpiryDate;

  RentUserModel({
    required this.id,
    required this.userName,
    required this.phoneNumber,
    required this.gender,
    required this.dateOfBirth,
    required this.lastName,
    required this.firstName,
    this.isSafe = false,
    this.nicFile,
    this.driverLicense,
    this.driverLicenseExpiryDate,
    this.nicNumber,
  });

  factory RentUserModel.fromJson(Map<String, dynamic> json) {
    return RentUserModel(
      id: json['id'],
      userName: json['userName'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      isSafe: json['isSafe'],
      nicFile: json['nicFile'],
      driverLicense: json['driverLicense'],
      driverLicenseExpiryDate: json['driverLicenseExpiryDate'],
      nicNumber: json['nicNumber'] ?? "",
    );
  }
}
