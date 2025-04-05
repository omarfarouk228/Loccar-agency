import 'package:flutter/material.dart';
import 'package:loccar_agency/models/payment.dart';
import 'package:loccar_agency/services/dio.dart';
import 'package:loccar_agency/utils/preferences.dart';

class PaymentService {
  final DioHelper _dioHelper = DioHelper();

  Future<(List<PaymentModel>, List)> fetchPayments() async {
    int userId = await SharedPreferencesHelper.getIntValue("id");
    List<PaymentModel> transactions = [];
    List dates = [];

    try {
      final response = await _dioHelper.get(
        '/payments/agency/$userId/list',
      );

      debugPrint("Response: ${response.data}");

      if (response.data["responseCode"] == "0") {
        for (var rent in response.data["data"]) {
          transactions.add(PaymentModel.fromJson(rent));
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
}
