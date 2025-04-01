import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loccar_agency/models/owner.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';

class OwnerService {
  final DioHelper _dioHelper = DioHelper();

  Future<List<OwnerModel>> fetchOwners() async {
    List<OwnerModel> owners = [];
    try {
      int userId = await SharedPreferencesHelper.getIntValue("id");
      final response = await _dioHelper.get(
        '/owners/agency/$userId/list',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var owner in response.data["data"]) {
          owners.add(OwnerModel.fromJson(owner));
        }
      }
    } catch (e) {
      debugPrint("Get owners error: $e");
    }
    return owners;
  }

  Future<bool> deleteOwner(int id) async {
    try {
      final response = await _dioHelper.delete(
        '/owners/$id',
      );
      debugPrint("Response: ${response.data}");
      if (response.data["responseCode"] == "0") {
        return true;
      }
    } catch (e) {
      debugPrint("Delete owner error: $e");
    }
    return false;
  }

  Future<bool> addOrUpdateOwner(
      {required int cardTypeId,
      required String cardNumber,
      required File cardFile,
      required String accountType,
      required String fullName,
      required String companyName,
      required String companyNif,
      required File? companyCardFile,
      List<String> additionalEmails = const [],
      required String email,
      required String phoneNumber,
      String? geolocationLink,
      int? ownerId}) async {
    try {
      int agencyId = await SharedPreferencesHelper.getIntValue("agencyId");
      // Determine account type and name field key
      final isPersonalAccount = accountType == "Compte personnel";
      final accountTypeValue = isPersonalAccount ? "personal" : "enterprise";
      final nameFieldKey =
          isPersonalAccount ? 'fullName' : 'responsibleFullName';

      // Create a map to easily inspect before converting to FormData
      Map<String, dynamic> formMap = {
        'agencyId': agencyId,
        'cardTypeId': cardTypeId,
        'idCardNumber': cardNumber,
        'accountType': accountTypeValue,
        nameFieldKey: fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'geolocalisation': geolocationLink
      };

      // Add conditional fields
      if (!isPersonalAccount) {
        formMap['socialReason'] = companyName;
        formMap['professionalCardNumber'] = companyNif;
      }

      // Add additional emails if present
      if (additionalEmails.isNotEmpty) {
        for (int i = 0; i < additionalEmails.length; i++) {
          formMap['additionalEmails[$i]'] = additionalEmails[i];
        }
      }

      // Debug the map before creating FormData
      debugPrint("Form data map: $formMap");

      // Create FormData from map
      FormData data = FormData.fromMap(formMap);

      // Add file fields
      final idCardFile = await MultipartFile.fromFile(cardFile.path,
          filename: cardFile.path.split('/').last,
          contentType: MediaType('image', 'jpeg'));
      data.files.add(MapEntry('idCard', idCardFile));

      if (companyCardFile != null) {
        final profCardFile = await MultipartFile.fromFile(companyCardFile.path,
            filename: companyCardFile.path.split('/').last,
            contentType: MediaType('image', 'jpeg'));
        data.files.add(MapEntry('professionalCard', profCardFile));
      }

      // Show files info
      for (var file in data.files) {
        debugPrint("File field: ${file.key}, filename: ${file.value.filename}");
      }

      Response response;
      if (ownerId != null) {
        response = await _dioHelper.put(
          '/owners/$ownerId',
          data: data,
        );
      } else {
        response = await _dioHelper.post(
          '/owners',
          data: data,
        );
      }

      debugPrint("Response: ${response.data}");
      return response.data["responseCode"] == "0";
    } catch (e) {
      debugPrint("Adding owner error: $e");
      return false;
    }
  }

  Future<bool> makeWithdrawal({
    required int ownerId,
    required double amount,
    required String wording,
  }) async {
    try {
      int agencyId = await SharedPreferencesHelper.getIntValue("agencyId");
      final response = await _dioHelper.put(
        '/owners/$ownerId',
        data: {
          'agencyId': agencyId,
          'amount': amount,
          'wording': wording,
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
