import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loccar_agency/models/car.dart';
import 'package:loccar_agency/models/category.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';

class CarService {
  final DioHelper _dioHelper = DioHelper();

  Future<List<CarModel>> fetchCars() async {
    List<CarModel> cars = [];
    try {
      int userId = await SharedPreferencesHelper.getIntValue("id");
      final response = await _dioHelper.get(
        '/cars/agencies/$userId/list',
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

  Future<List<CategoryModel>> fetchCategories() async {
    List<CategoryModel> categories = [];
    try {
      final response = await _dioHelper.get(
        '/categories',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var category in response.data["data"]) {
          categories.add(CategoryModel.fromJson(category));
        }
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
    return categories;
  }

  Future<bool> deleteCar(int id) async {
    try {
      final response = await _dioHelper.delete(
        '/cars/$id',
      );
      debugPrint("Response: ${response.data}");
      if (response.data["responseCode"] == "0") {
        return true;
      }
    } catch (e) {
      debugPrint("Delete car error: $e");
    }
    return false;
  }

  addOrUpdateCar(
      {required int ownerId,
      required int categoryId,
      required String plateCountry,
      required String plateNumber,
      required String plateSeries,
      required String brand,
      required String model,
      required String color,
      required String year,
      required String grayCardNumber,
      required File grayCard,
      required String chassisNumber,
      required int geolocation,
      required int isOnLocation,
      required String transmission,
      required String engine,
      required int places,
      required int doors,
      required String? assuranceIsueDate,
      required String? assuranceExpiryDate,
      required File? assurance,
      required String? technicalVisitIsueDate,
      required String? technicalVisitExpiryDate,
      required File? technicalVisit,
      required String? tvmIsueDate,
      required String? tvmExpiryDate,
      required File? tvm,
      required double? locationFees,
      required int? twoHours,
      required int? sixHours,
      required int? twelveHours,
      required int? days,
      required double? shopFees,
      required int? isOnShop,
      required int? isPopular,
      required String? popularStartDate,
      required int? popularDays,
      List<File> carPhotos = const [],
      int? carId}) async {
    try {
      int agencyId = await SharedPreferencesHelper.getIntValue("agencyId");
      List arrPhotos = [];

      for (var image in carPhotos) {
        arrPhotos.add(await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last,
            contentType: MediaType('image', 'jpeg')));
      }

      // Create a map to easily inspect before converting to FormData
      Map<String, dynamic> formMap = {
        'agencyId': agencyId,
        'ownerId': ownerId,
        'categoryId': categoryId,
        'plateCountry': plateCountry,
        'plateNumber': plateNumber,
        'plateSeries': plateSeries,
        'brand': brand,
        'model': model,
        'color': color,
        'year': year,
        'grayCardNumber': grayCardNumber,
        'chassisNumber': chassisNumber,
        'geolocation': geolocation,
        'isOnLocation': isOnLocation,
        'transmission': transmission,
        'engine': engine,
        'places': places,
        'doors': doors,
        'assuranceIsueDate': assuranceIsueDate,
        'assuranceExpiryDate': assuranceExpiryDate,
        'technicalVisitIsueDate': technicalVisitIsueDate,
        'technicalVisitExpiryDate': technicalVisitExpiryDate,
        'tvmIsueDate': tvmIsueDate,
        'tvmExpiryDate': tvmExpiryDate,
        'locationFees': locationFees,
        'twoHours': twoHours,
        'sixHours': sixHours,
        'twelveHours': twelveHours,
        'days': days,
        'shopFees': shopFees,
        'isOnShop': isOnShop,
        'isPopular': isPopular,
        'popularStartDate': popularStartDate,
        'popularDays': popularDays,
        'carPhotos': arrPhotos
      };

      // Debug the map before creating FormData
      debugPrint("Form data map: $formMap");

      // Create FormData from map
      FormData data = FormData.fromMap(formMap);

      // Add file fields
      final grayCardFile = await MultipartFile.fromFile(grayCard.path,
          filename: grayCard.path.split('/').last,
          contentType: MediaType('image', 'jpeg'));
      data.files.add(MapEntry('grayCard', grayCardFile));

      if (assurance != null) {
        final assuranceFile = await MultipartFile.fromFile(assurance.path,
            filename: assurance.path.split('/').last,
            contentType: MediaType('image', 'jpeg'));
        data.files.add(MapEntry('assurance', assuranceFile));
      }
      if (technicalVisit != null) {
        final technicalVisitFile = await MultipartFile.fromFile(
            technicalVisit.path,
            filename: technicalVisit.path.split('/').last,
            contentType: MediaType('image', 'jpeg'));
        data.files.add(MapEntry('technicalVisit', technicalVisitFile));
      }
      if (tvm != null) {
        final tvmFile = await MultipartFile.fromFile(tvm.path,
            filename: tvm.path.split('/').last,
            contentType: MediaType('image', 'jpeg'));
        data.files.add(MapEntry('tvm', tvmFile));
      }

      // Show files info
      for (var file in data.files) {
        debugPrint("File field: ${file.key}, filename: ${file.value.filename}");
      }

      Response response;
      if (carId != null) {
        response = await _dioHelper.put(
          '/cars/$carId',
          data: data,
        );
      } else {
        response = await _dioHelper.post(
          '/cars/agencies/create',
          data: data,
        );
      }

      debugPrint("Response: ${response.data}");
      return response.data["responseCode"] == "0";
    } catch (e) {
      debugPrint("Adding car error: $e");
      return false;
    }
  }

  Future<bool> makeDeposit(
      {required int carId,
      required double amount,
      required String wording,
      required String entrySource,
      required String plateCountry,
      required String plateSeries,
      required String plateNumber,
      required int ownerId}) async {
    try {
      int agencyId = await SharedPreferencesHelper.getIntValue("agencyId");
      final response = await _dioHelper.put(
        '/cars/$carId',
        data: {
          'plateCountry': plateCountry,
          'plateSeries': plateSeries,
          'plateNumber': plateNumber,
          'ownerId': ownerId,
          'agencyId': agencyId,
          'amount': amount,
          'wording': wording,
          'entrySource': entrySource
        },
      );
      debugPrint("Response: ${response.data}");

      return response.data["responseCode"] == "0";
    } catch (e) {
      debugPrint("Adding owner error: $e");
      return false;
    }
  }
}
