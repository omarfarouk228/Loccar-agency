import 'package:flutter/material.dart';
import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';

class CarService {
  final DioHelper _dioHelper = DioHelper();

  Future<List<CarModel>> fetchCars() async {
    List<CarModel> cars = [];
    try {
      int agencyId = await SharedPreferencesHelper.getIntValue("id");
      final response = await _dioHelper.get(
        '/cars/agencies/$agencyId/list',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var car in response.data["data"]) {
          cars.add(CarModel.fromJson(car));
        }
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
    return cars;
  }
}
