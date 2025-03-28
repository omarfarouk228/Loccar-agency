class ModelVehicle {
  late int id;
  late String marque,
      model,
      couleur,
      plaque,
      annee,
      nomConducteur,
      telephoneConducteur,
      permisConducteur,
      permisCategorie,
      dateDelivrance,
      dateExpiration,
      imagePermis,
      transmission;
  late int status;
  late bool isExpanded, geolocation;
  late bool isOnRace, isOnLocation, isOnShop;
  List<PhotoCar> photos = [];
  late int agencyId;

  ModelVehicle(
      {required this.id,
      required this.marque,
      required this.model,
      required this.couleur,
      required this.plaque,
      required this.annee,
      required this.nomConducteur,
      required this.telephoneConducteur,
      required this.geolocation,
      required this.permisConducteur,
      required this.permisCategorie,
      required this.dateDelivrance,
      required this.dateExpiration,
      required this.imagePermis,
      required this.transmission,
      required this.status,
      required this.photos,
      required this.isExpanded,
      required this.agencyId});

  ModelVehicle.second(
      {required this.id,
      required this.marque,
      required this.model,
      required this.couleur,
      required this.plaque,
      required this.annee,
      required this.geolocation,
      required this.nomConducteur,
      required this.telephoneConducteur,
      required this.permisConducteur,
      required this.permisCategorie,
      required this.dateDelivrance,
      required this.dateExpiration,
      required this.imagePermis,
      required this.status,
      required this.isOnRace,
      required this.isOnLocation,
      required this.isOnShop,
      required this.photos,
      required this.isExpanded,
      required this.agencyId});

  ModelVehicle.empty();

  static ModelVehicle fromJson(Map<String, dynamic> json) {
    List<PhotoCar> carPhotos = [];
    if (json['carPhotos'] != null) {
      for (var photo in json['carPhotos']) {
        carPhotos.add(PhotoCar(
          id: photo['id'],
          name: photo['carPhoto'],
        ));
      }
    }

    return ModelVehicle(
      id: json['id'],
      annee: json['year'].toString(),
      couleur: json['color'] ?? "",
      dateDelivrance: json['driverLicenseIssueDate'] ?? "",
      dateExpiration: json['driverLicenseExpiryDate'] ?? "",
      imagePermis: (json['driverLicense'] != null)
          ? "https://api.loccar.com/${json['driverLicense']}"
          : 'https://www.citizencard.com/images/sample-cards/uk-id-card-for-over-18s-2023.png',
      marque: json['brand'],
      model: json['model'],
      geolocation: json['geolocation'],
      permisCategorie: json['driverLicenseCategory'] ?? "",
      nomConducteur: json['driverFullName'] ?? "",
      permisConducteur: json['driverLicenseNumber'] ?? "",
      transmission: json['transmission'] ?? "",
      plaque: json['carPlateNumber'] ?? "",
      status: json['state'] ?? 0,
      telephoneConducteur: json['driverPhoneNumber'] ?? "",
      photos: carPhotos,
      isExpanded: false,
      agencyId: json['agencyId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'annee': annee,
        'couleur': couleur,
        'dateDelivrance': dateDelivrance,
        'dateExpiration': dateExpiration,
        'imagePermis': imagePermis,
        'marque': marque,
        'model': model,
        'geolocation': geolocation,
        'permisCategorie': permisCategorie,
        'nomConducteur': nomConducteur,
        'permisConducteur': permisConducteur,
        'plaque': plaque,
        'transmission': transmission,
        'status': status,
        'telephoneConducteur': telephoneConducteur,
        'isExpanded': false,
        'agencyId': agencyId
      };

  Map<String, dynamic> toJson2() => {
        'id': id,
        'year': annee,
        'color': couleur,
        'brand': marque,
        'model': model,
        'geolocation': geolocation,
        'grayCardNumber': "",
        'locationFees': 30000,
        'carPlateNumber': "18891081l'",
        'status': status,
        'chassisNumber': 4,
        'airConditioner': 1,
        'doors': 5,
        'places': 2,
        'isExpanded': false,
        'agencyId': agencyId
      };

  static ModelVehicle fromJsonSecond(Map<String, dynamic> json) {
    List<PhotoCar> carPhotos = [];
    return ModelVehicle.second(
      id: json['id'],
      annee: json['year'].toString(),
      couleur: json['color'],
      dateDelivrance: json['driverLicenseIssueDate'],
      dateExpiration: json['driverLicenseExpiryDate'],
      geolocation: json['geolocation'],
      imagePermis: (json['driverLicense'] != null)
          ? "https://api.loccar.com/${json['driverLicense']}"
          : 'https://www.citizencard.com/images/sample-cards/uk-id-card-for-over-18s-2023.png',
      marque: json['brand'],
      model: json['model'],
      nomConducteur: json['driverFullName'],
      permisConducteur: json['driverLicenseNumber'],
      plaque: json['carPlateNumber'],
      status: json['state'],
      telephoneConducteur: json['driverPhoneNumber'],
      permisCategorie: json['driverLicenseCategory'],
      isExpanded: false,
      isOnLocation: json['isOnLocation'],
      isOnRace: json['isOnRace'],
      isOnShop: json['isOnShop'],
      photos: carPhotos,
      agencyId: json['agencyId'],
    );
  }

  static ModelVehicle fromJsonSecond2(Map<String, dynamic> json) {
    List<PhotoCar> carPhotos = [];
    return ModelVehicle.second(
      id: json['id'],
      annee: json['annee'].toString(),
      couleur: json['couleur'],
      dateDelivrance: json['dateDelivrance'],
      dateExpiration: json['dateExpiration'],
      geolocation: json['geolocation'],
      imagePermis: json['imagePermis'],
      marque: json['marque'],
      model: json['model'],
      nomConducteur: json['nomConducteur'],
      permisConducteur: json['permisConducteur'],
      plaque: json['plaque'],
      status: json['status'],
      telephoneConducteur: json['telephoneConducteur'],
      permisCategorie: json['permisCategorie'],
      isExpanded: false,
      isOnLocation: false,
      isOnRace: false,
      isOnShop: false,
      photos: carPhotos,
      agencyId: json['agencyId'],
    );
  }
}

class PhotoCar {
  late int id;
  late String name;

  PhotoCar({required this.id, required this.name});
}
