import 'package:flutter/material.dart';
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
}
