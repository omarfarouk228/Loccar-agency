class UserModel {
  final int id;
  final String name;
  final String email;
  final String city;
  final String state;
  final String phoneNumber;
  final int balance;
  final String? phoneNumberBis;
  final String responsibleFullName;
  final String fullAddress;
  final String? password;
  final String? socket;
  final String? lastBillingDate;
  final String? lastLogin;
  final String? country;
  final String? countryCode;
  final int? countryId;
  final int? administratorId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
    required this.state,
    required this.phoneNumber,
    required this.balance,
    this.phoneNumberBis,
    required this.responsibleFullName,
    required this.fullAddress,
    this.password,
    this.socket,
    this.lastBillingDate,
    this.lastLogin,
    this.countryId,
    this.country,
    this.countryCode,
    this.administratorId,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'city': city,
        'state': state,
        'phone_number': phoneNumber,
        'balance': balance,
        'phone_number_bis': phoneNumberBis,
        'responsible_full_name': responsibleFullName,
        'full_address': fullAddress,
        'password': password,
        'socket': socket,
        'lastBillingDate': lastBillingDate,
        'last_login': lastLogin,
        'countryId': countryId,
        'country': country,
        'countryCode': countryCode,
        'administratorId': administratorId,
      };

  // Create object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      city: json['city'],
      state: json['state'],
      phoneNumber: json['phone_number'],
      balance: json['balance'],
      phoneNumberBis: json['phone_number_bis'],
      responsibleFullName: json['responsible_full_name'],
      fullAddress: json['full_address'],
      password: json['password'],
      socket: json['socket'],
      lastBillingDate: json['lastBillingDate'],
      lastLogin: json['last_login'],
      countryId: json['countryId'],
      country: json['country']['name'],
      countryCode: json['country']['phone_code'],
      administratorId: json['administratorId']);

  // Create object from JSON
  factory UserModel.fromJson2(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      city: json['city'],
      state: json['state'],
      phoneNumber: json['phone_number'],
      balance: json['balance'],
      phoneNumberBis: json['phone_number_bis'],
      responsibleFullName: json['responsible_full_name'],
      fullAddress: json['full_address'],
      password: json['password'],
      socket: json['socket'],
      lastBillingDate: json['lastBillingDate'],
      lastLogin: json['last_login'],
      countryId: json['countryId'],
      country: json['country'],
      countryCode: json['countryCode'],
      administratorId: json['administratorId']);
}
