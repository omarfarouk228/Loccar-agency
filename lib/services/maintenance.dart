import 'package:flutter/material.dart';
import 'package:loccar_agency/models/maintenance.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';

class MaintenanceService {
  final DioHelper _dioHelper = DioHelper();

  Future<List<MaintenanceModel>> fetchMaintenances() async {
    int userId = await SharedPreferencesHelper.getIntValue("id");
    List<MaintenanceModel> maintenances = [];

    try {
      final response = await _dioHelper.get(
        '/maintenances/$userId/list/all',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var rent in response.data["data"]) {
          maintenances.add(MaintenanceModel.fromJson(rent));
        }

        maintenances.sort((a, b) => b.createdAt.isAfter(a.createdAt) ? 1 : 0);
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
    return maintenances;
  }
}
