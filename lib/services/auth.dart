import 'package:flutter/material.dart';
import 'package:loccar_agency/models/user.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';
import 'package:loccar_agency/utils/snack_bar_helper.dart';

class AuthService {
  final DioHelper _dioHelper = DioHelper();

  Future<bool> login(String email, String password, context) async {
    try {
      final response = await _dioHelper.post(
        '/agencies/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      debugPrint("Response: ${response.data}");
      if (response.data["responseCode"] != "0") {
        debugPrint("1");
        SnackBarHelper.showCustomSnackBar(
            context, "Email ou mot de passe incorrect");
      } else {
        await _dioHelper.saveToken(response.data['data'][0]['token']);
        await SharedPreferencesHelper.setIntValue(
            "id", response.data['data'][0]['id']);
        SharedPreferencesHelper.setIntValue("step_auth", 1);
        return true;
      }
    } catch (e) {
      debugPrint("Login error: $e");
      // Handle login error
      SnackBarHelper.showCustomSnackBar(
          context, "Email ou mot de passe incorrect");
    }
    return false;
  }

  Future<void> getInfos() async {
    try {
      int agencyId = await SharedPreferencesHelper.getIntValue("id");
      final response = await _dioHelper.get(
        '/agencies/$agencyId',
      );

      if (response.data["responseCode"] == "0") {
        debugPrint("Response: ${response.data["data"][0]['country']['name']}");
        await SharedPreferencesHelper.saveObject(
            "user", UserModel.fromJson(response.data['data'][0]));
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
  }
}
