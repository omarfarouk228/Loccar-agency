import 'dart:convert';

import 'package:loccar_agency/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<String> getValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? '';
  }

  static Future<int> getIntValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key) ?? 0;
  }

  static Future<bool?> getBoolValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  static Future<bool> setValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Future<bool> setIntValue(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(key, value);
  }

  static Future<bool> deleteValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove(key);
  }

  static Future<bool> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.clear();
  }

  // New methods for object serialization

  // Save an object
  static Future<bool> saveObject(String key, dynamic object) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, json.encode(object.toJson()));
  }

  // Retrieve an object
  static Future<T?> getObject<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return fromJson(jsonMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Save a list of objects
  static Future<bool> saveObjectList<T>(String key, List<T> objects) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonList = objects
        .map((obj) => obj is UserModel
            ? obj.toJson()
            : throw ArgumentError('Object must have toJson method'))
        .toList();
    return prefs.setString(key, json.encode(jsonList));
  }

  // Retrieve a list of objects
  static Future<List<T>?> getObjectList<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((jsonMap) => fromJson(jsonMap)).toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
