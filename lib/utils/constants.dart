import 'package:flutter/material.dart';
import 'package:loccar_agency/utils/colors.dart';

class Constants {
  static String appName = "LOCCAR AGENCE";

  static String baseUrl = "https://api.sogenuvo.com";

  static String currentFontFamily = "Lato";
  static String secondFontFamily = "LilitaOne";

  static (String, int, Color, int) getDiffBetweenDates(String expiryDate) {
    DateTime date1 = DateTime.now();
    DateTime date2 = DateTime.parse(expiryDate);

    String text = "";
    int status = 1;
    Color color = Colors.green;
    int differenceDays = 0;
    if (date2.isAfter(date1)) {
      // Calcul de la différence entre les deux dates
      Duration difference = date2.difference(date1);

      // Récupération des composantes de la différence
      int years = difference.inDays ~/ 365;
      int months = difference.inDays ~/ 30;
      int days = difference.inDays % 30;

      differenceDays = difference.inDays;

      // Construction du texte à afficher
      if (years > 0) {
        text = 'Dans $years ans';
      } else if (months > 0) {
        text = 'Dans $months mois';
      } else if (days > 0) {
        color = Colors.orange.shade500;
        text = 'Dans $days jours';
      }
    } else {
      status = 0;
      text = 'Expirée';
      color = Colors.green;
    }

    return (text, status, color, differenceDays);
  }

  static String priceString(price) {
    final numberString = price.toString();
    final numberDigits = List.from(numberString.split(''));
    int index = numberDigits.length - 3;
    while (index > 0) {
      numberDigits.insert(index, ' ');
      index -= 3;
    }
    return numberDigits.join();
  }

  static void showAlertDialog(
      String title, String content, BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  static void showBlockAlertDialogBack(
      String title, String content, String actionText, BuildContext context) {
    var alertDialog =
        AlertDialog(title: Text(title), content: Text(content), actions: [
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
        ),
        child: Text(actionText, style: const TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      )
    ]);
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            PopScope(canPop: false, child: alertDialog));
  }

  static getMethodImage(type) {
    String typeA = getType(type);
    String image = "";
    switch (typeA) {
      case "TMONEY":
        image = "assets/images/tmoney.webp";
        break;
      case "FLOOZ":
        image = "assets/images/moov.webp";
        break;
    }
    return image;
  }

  static getType(type) {
    String valueReturn = "";
    String begin = type.toString().substring(3, 5);

    if (["70", "71", "72", "90", "91", "92", "93"].contains(begin)) {
      valueReturn = "TMONEY";
    } else {
      valueReturn = "FLOOZ";
    }
    return valueReturn;
  }

  static String getMonth(String date) {
    int month = int.parse(date.split("-")[1].toString());
    List<String> months = [
      "Janvier",
      "Février",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juillet",
      "Août",
      "Septembre",
      "Octobre",
      "Novembre",
      "Décembre"
    ];
    return months[month - 1];
  }
}
