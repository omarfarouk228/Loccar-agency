import 'package:flutter/material.dart';
import 'package:loccar_agency/models/card_type.dart';
import 'package:loccar_agency/models/country.dart';
import 'package:loccar_agency/services/dio.dart';

class OtherService {
  final DioHelper _dioHelper = DioHelper();

  Future<List<Country>> fetchCountries() async {
    List<Country> countries = [];
    try {
      final response = await _dioHelper.get(
        '/countries',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var country in response.data["data"]) {
          countries.add(Country.fromJson(country));
        }
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
    return countries;
  }

  Future<List<CardTypeModel>> fetchCardTypes() async {
    List<CardTypeModel> cardTypes = [];
    try {
      final response = await _dioHelper.get(
        '/cardTypes',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var cardType in response.data["data"]) {
          cardTypes.add(CardTypeModel.fromJson(cardType));
        }
      }
    } catch (e) {
      debugPrint("Get card type error: $e");
    }
    return cardTypes;
  }
}
