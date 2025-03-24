class ModelAccident {
  late int id, status, ownerState;
  late double latitude, longitude;
  late String createdAt;

  ModelAccident(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.createdAt,
      required this.ownerState,
      required this.status});

  static ModelAccident fromJson(Map<String, dynamic> json) => ModelAccident(
        id: json['id'],
        latitude: double.parse(json['latitude'].toString()),
        longitude: double.parse(json['longitude'].toString()),
        createdAt: json['createdAt'],
        ownerState: json['ownerState'],
        status: json['state'],
      );
}
