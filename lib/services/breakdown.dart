import 'package:flutter/material.dart';
import 'package:loccar_agency/models/breakdown.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';

class BreakdownService {
  final DioHelper _dioHelper = DioHelper();

  Future<List<BreakdownModel>> fetchBreakdowns() async {
    int userId = await SharedPreferencesHelper.getIntValue("id");
    List<BreakdownModel> breakdowns = [];

    try {
      final response = await _dioHelper.get(
        '/breakdowns/$userId/list/all',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var rent in response.data["data"]) {
          breakdowns.add(BreakdownModel.fromJson(rent));
        }

        breakdowns.sort((a, b) => b.createdAt.isAfter(a.createdAt) ? 1 : 0);
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
    return breakdowns;
  }
}
