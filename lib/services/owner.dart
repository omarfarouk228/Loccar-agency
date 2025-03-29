import 'package:flutter/material.dart';
import 'package:loccar_agency/models/owner.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';

class OwnerService {
  final DioHelper _dioHelper = DioHelper();

  Future<List<OwnerModel>> fetchOwners() async {
    List<OwnerModel> owners = [];
    try {
      int agencyId = await SharedPreferencesHelper.getIntValue("id");
      final response = await _dioHelper.get(
        '/owners/agency/$agencyId/list',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var owner in response.data["data"]) {
          owners.add(OwnerModel.fromJson(owner));
        }
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
    return owners;
  }
}
