class CategoryModel {
  late int id;
  late String icon, name;

  CategoryModel({required this.id, required this.name, required this.icon});

  static CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'] ?? "",
    );
  }
}
