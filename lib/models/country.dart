class Country {
  int id;
  String name;
  String plateCode;
  String isoCode;
  String phoneCode;
  String flag;

  Country({
    required this.id,
    required this.name,
    required this.plateCode,
    required this.isoCode,
    required this.phoneCode,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      plateCode: json['plate_code'],
      isoCode: json['iso_code'],
      phoneCode: json['phone_code'],
      flag: json['flag'],
    );
  }
}
