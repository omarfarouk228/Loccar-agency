class UserStatModel {
  final int owners;
  final int cars;
  final int rentsPending;
  final int rents;
  final int maintenances;
  final int accidents;
  final int breakdowns;

  UserStatModel(
      {required this.owners,
      required this.cars,
      required this.rentsPending,
      required this.rents,
      required this.maintenances,
      required this.accidents,
      required this.breakdowns});

  // Convert object to JSON
  Map<String, dynamic> toJson() => {
        'owners': owners,
        'cars': cars,
        'rentsPending': rentsPending,
        'rents': rents,
        'maintenances': maintenances,
        'accidents': accidents,
        'breakdowns': breakdowns
      };

  // Create object from JSON
  factory UserStatModel.fromJson(Map<String, dynamic> json) => UserStatModel(
      owners: json['owners'],
      cars: json['cars'],
      rentsPending: json['rentsPending'],
      rents: json['rents'],
      maintenances: json['maintenances'],
      accidents: json['accidents'],
      breakdowns: json['breakdowns']);
}
