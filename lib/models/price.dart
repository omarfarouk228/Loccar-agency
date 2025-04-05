class PriceModel {
  int? price1;
  int? price2;
  int? price3;

  PriceModel({this.price1, this.price2, this.price3});

  PriceModel.fromJson(Map<String, dynamic> json) {
    price1 = json['price_1'] ?? 0;
    price2 = json['price_2'] ?? 0;
    price3 = json['price_3'] ?? 0;
  }
}
