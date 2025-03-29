import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static (String, int, Color, int) getDiffBetweenDates(DateTime expiryDate) {
    DateTime currentTime = DateTime.now();

    String text = "";
    int status = 1;
    Color color = Colors.green;
    int differenceDays = 0;
    if (expiryDate.isAfter(currentTime)) {
      // Calcul de la différence entre les deux dates
      Duration difference = expiryDate.difference(currentTime);

      // Récupération des composantes de la différence
      int years = difference.inDays ~/ 365;
      int months = difference.inDays ~/ 30;
      int days = difference.inDays % 30;

      differenceDays = difference.inDays;

      // Construction du texte à afficher
      if (years > 0) {
        text = 'Expire dans $years ans';
      } else if (months > 0) {
        text = 'Expire dans $months mois';
      } else if (days > 0) {
        color = Colors.orange.shade500;
        text = 'Expire dans $days jours';
      }
    } else {
      status = 0;
      text = 'Expirée';
      color = Colors.red;
    }

    return (text, status, color, differenceDays);
  }

  static String formatDateTimeToDate(DateTime dateTime, {String lang = "fr"}) {
    return DateFormat(lang == "fr" ? 'dd-MM-yyyy' : 'yyyy-MM-dd')
        .format(DateTime.parse(dateTime.toString()));
  }

  static String formatDateTimeToString(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm:ss')
        .format(DateTime.parse(dateTime.toString()));
  }
}
