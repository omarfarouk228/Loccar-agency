import 'package:loccar_agency/models/photo_car.dart';

class ModelVehicule {
  late int id;
  late String marque, model, couleur, plaque, annee;

  late int status;
  late bool isExpanded, geolocation;
  late bool isOnRace, isOnLocation, isOnShop;
  List<PhotoCar> photos = [];
  int agencyId;

  ModelVehicule({
    required this.id,
    required this.marque,
    required this.model,
    required this.couleur,
    required this.plaque,
    required this.annee,
    required this.geolocation,
    required this.status,
    required this.isExpanded,
    required this.agencyId,
  });

  ModelVehicule.second(
      {required this.id,
      required this.marque,
      required this.model,
      required this.couleur,
      required this.plaque,
      required this.annee,
      required this.geolocation,
      required this.status,
      required this.isOnRace,
      required this.isOnLocation,
      required this.isOnShop,
      required this.photos,
      required this.isExpanded,
      required this.agencyId});

  static ModelVehicule fromJson(Map<String, dynamic> json) => ModelVehicule(
        id: json['id'],
        annee: json['year'].toString(),
        couleur: json['color'] ?? "",
        marque: json['brand'],
        model: json['model'],
        geolocation: json['geolocation'],
        plaque: json['plateSeries'] + json['plateNumber'],
        status: json['state'],
        isExpanded: false,
        agencyId: json['agencyId'] ?? 0,
      );

  static ModelVehicule fromJsonSecond(Map<String, dynamic> json) {
    List<PhotoCar> carPhotos = [];
    return ModelVehicule.second(
      id: json['id'],
      annee: json['year'].toString(),
      couleur: json['color'] ?? "",
      marque: json['brand'],
      geolocation: json['geolocation'],
      model: json['model'],
      plaque: json['plateSeries'] + json['plateNumber'],
      status: json['state'],
      isExpanded: false,
      isOnLocation: json['isOnLocation'],
      isOnRace: json['isOnRace'] ?? false,
      isOnShop: json['isOnShop'] ?? false,
      photos: carPhotos,
      agencyId: json['agencyId'] ?? 0,
    );
  }
}
