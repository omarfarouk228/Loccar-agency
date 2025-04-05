import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/models/price.dart';
import 'package:loccar_agency/models/rent_user.dart';

class RentModel {
  int id, state, days, price, deposit, rating, hours;
  double lat, lon;
  DateTime startDate, endDate, createdAt;
  CarModel? car;
  RentUserModel? user;
  PriceModel? priceModel;

  RentModel(
      {required this.id,
      required this.state,
      required this.days,
      required this.price,
      required this.deposit,
      required this.rating,
      required this.lat,
      required this.lon,
      required this.startDate,
      required this.endDate,
      required this.createdAt,
      required this.hours,
      this.car,
      this.user,
      this.priceModel});

  static RentModel fromJson(Map<String, dynamic> json) => RentModel(
        id: json['id'],
        state: json['state'],
        days: json['days'],
        price: json['price'],
        deposit: json['deposit'],
        rating: json['rating'],
        hours: json['hours'],
        lat: json['lat'] != null ? double.parse(json['lat'].toString()) : 0.0,
        lon: json['lon'] != null ? double.parse(json['lat'].toString()) : 0.0,
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        createdAt: DateTime.parse(json['createdAt']),
        car: json['car'] != null ? CarModel.fromJson(json['car']) : null,
        user:
            json['user'] != null ? RentUserModel.fromJson(json['user']) : null,
        priceModel:
            json['prices'] != null ? PriceModel.fromJson(json['prices']) : null,
      );
}
