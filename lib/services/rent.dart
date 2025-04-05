import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loccar_agency/models/rent.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';

class RentService {
  final DioHelper _dioHelper = DioHelper();

  Future<(List<RentModel>, List)> fetchRents() async {
    List<RentModel> rents = [];
    List dates = [];

    try {
      int userId = await SharedPreferencesHelper.getIntValue("id");
      final response = await _dioHelper.get(
        '/rents/agencies/$userId',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var rent in response.data["data"]) {
          rents.add(RentModel.fromJson(rent));
        }

        dates = response.data["data"]
            .where((element) => element['carId'] != null)
            .fold({}, (previousValue, element) {
              Map val = previousValue as Map;
              String date = element['createdAt'].split("T")[0];
              if (!val.containsKey(date)) {
                val[date] = [];
              }
              element.remove('createdAt');
              val[date]?.add(element);
              return val;
            })
            .entries
            .map((e) => e.key)
            .toList();

        dates.sort(
            (a, b) => DateTime.parse(b).isAfter(DateTime.parse(a)) ? 1 : 0);
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
    return (rents, dates);
  }

  Future<bool> updateRent(
      {required int rentId,
      required String? endDate,
      required String? startDate,
      required int state,
      required int? deposit,
      required int carId}) async {
    try {
      Map<String, dynamic> data = {
        'state': state,
        'carId': carId,
        'id': rentId
      };

      if (endDate != null) {
        data['endDate'] = endDate;
      }
      if (startDate != null) {
        data['startDate'] = startDate;
      }
      if (deposit != null) {
        data['deposit'] = deposit;
      }

      final response = await _dioHelper.put(
        '/rents/$rentId',
        data: data,
      );
      debugPrint("Response: ${response.data}");

      return response.data["responseCode"] == "0";
    } catch (e) {
      debugPrint("Update rent error: $e");
      return false;
    }
  }

  Future<bool> updateUserRent(
      {required int userId,
      required String? userName,
      required String? nicNumber,
      required String? driverLicenseExpiryDate,
      required File? nicFile,
      required File? driverLicense}) async {
    try {
      Map<String, dynamic> formMap = {
        'userName': userName,
        'nicNumber': nicNumber,
        'driverLicenseExpiryDate': driverLicenseExpiryDate
      };

      // Create FormData from map
      FormData data = FormData.fromMap(formMap);

      // Add file fields
      if (nicFile != null) {
        final nicFileMultipart = await MultipartFile.fromFile(nicFile.path,
            filename: nicFile.path.split('/').last,
            contentType: MediaType('image', 'jpeg'));
        data.files.add(MapEntry('nicFile', nicFileMultipart));
      }

      // Add file fields
      if (driverLicense != null) {
        final driverLicenseMultipart = await MultipartFile.fromFile(
            driverLicense.path,
            filename: driverLicense.path.split('/').last,
            contentType: MediaType('image', 'jpeg'));
        data.files.add(MapEntry('driverLicense', driverLicenseMultipart));
      }

      final response = await _dioHelper.put(
        '/users/$userId',
        data: data,
      );
      debugPrint("Response: ${response.data}");

      return response.data["responseCode"] == "0";
    } catch (e) {
      debugPrint("Update rent error: $e");
      return false;
    }
  }

  Future<(int amount, int percent)> calculateRentDiscount(
      {required int price, required int days}) async {
    try {
      Map<String, dynamic> data = {'price': price, 'days': days};

      final response = await _dioHelper.post(
        '/get-reductions',
        data: data,
      );
      debugPrint("Response: ${response.data}");

      return (
        int.parse(response.data['amount'].toString()),
        int.parse(response.data['percent'].toString())
      );
    } catch (e) {
      debugPrint("Update rent error: $e");
      return (0, 0);
    }
  }
}
