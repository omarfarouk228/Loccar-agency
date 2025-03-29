import 'package:flutter/material.dart';
import 'package:loccar_agency/utils/colors.dart';

class Constants {
  static String appName = "LOCCAR AGENCE";

  static String baseUrl = "https://api.sogenuvo.com";

  static String currentFontFamily = "Lato";
  static String secondFontFamily = "LilitaOne";

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
