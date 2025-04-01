class CardTypeModel {
  late int id;
  late String name;

  CardTypeModel({required this.id, required this.name});

  static CardTypeModel fromJson(Map<String, dynamic> json) {
    return CardTypeModel(id: json['id'], name: json['name']);
  }
}
