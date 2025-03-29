class RentUserModel {
  final int id;
  final String userName;
  final String gender;
  final String dateOfBirth;
  final String lastName;
  final String firstName;

  RentUserModel({
    required this.id,
    required this.userName,
    required this.gender,
    required this.dateOfBirth,
    required this.lastName,
    required this.firstName,
  });

  factory RentUserModel.fromJson(Map<String, dynamic> json) {
    return RentUserModel(
      id: json['id'],
      userName: json['userName'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      lastName: json['lastName'],
      firstName: json['firstName'],
    );
  }
}
