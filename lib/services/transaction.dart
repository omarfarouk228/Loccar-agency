import 'package:flutter/material.dart';
import 'package:loccar_agency/models/transaction.dart';
import 'package:loccar_agency/services/dio.dart';

class TransactionService {
  final DioHelper _dioHelper = DioHelper();

  Future<(List<TransactionModel>, List)> fetchRents() async {
    List<TransactionModel> transactions = [];
    List dates = [];

    try {
      final response = await _dioHelper.get(
        '/transactions',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var rent in response.data["data"]) {
          transactions.add(TransactionModel.fromJson(rent));
        }

        dates = response.data["data"]
            .where((element) => element['id'] != null)
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

        transactions.sort((a, b) => b.createdAt.isAfter(a.createdAt) ? 1 : 0);

        dates.sort(
            (a, b) => DateTime.parse(b).isAfter(DateTime.parse(a)) ? 1 : 0);
      }
    } catch (e) {
      debugPrint("Get info error: $e");
    }
    return (transactions, dates);
  }

  Future<bool> handleTransaction({required String url}) async {
    try {
      final response = await _dioHelper.get(url);
      debugPrint("Response: ${response.data}");

      return response.data["responseCode"] == "0";
    } catch (e) {
      debugPrint("Update transaction error: $e");
      return false;
    }
  }
}
