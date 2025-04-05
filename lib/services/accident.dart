import 'package:flutter/material.dart';
import 'package:loccar_agency/models/accident.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';

class AccidentService {
  final DioHelper _dioHelper = DioHelper();

  Future<List<AccidentModel>> fetchAccidents() async {
    int userId = await SharedPreferencesHelper.getIntValue("id");
    List<AccidentModel> accidents = [];

    try {
      final response = await _dioHelper.get(
        '/accidents/$userId/list/all',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var rent in response.data["data"]) {
          accidents.add(AccidentModel.fromJson(rent));
        }

        accidents.sort((a, b) => b.createdAt.isAfter(a.createdAt) ? 1 : 0);
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
    return accidents;
  }
}
