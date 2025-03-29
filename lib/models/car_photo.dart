class CarPhotoModel {
  final int id;
  final String carPhoto;

  CarPhotoModel({required this.id, required this.carPhoto});

  factory CarPhotoModel.fromJson(Map<String, dynamic> json) {
    return CarPhotoModel(
      id: json['id'],
      carPhoto: json['carPhoto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carPhoto': carPhoto,
    };
  }
}
