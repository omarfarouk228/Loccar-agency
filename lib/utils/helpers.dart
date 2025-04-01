import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

  static String formatDateTimeToDate(DateTime dateTime,
      {String lang = "fr", String separator = "-"}) {
    return DateFormat(lang == "fr"
            ? 'dd${separator}MM${separator}yyyy'
            : 'yyyy${separator}MM${separator}dd')
        .format(DateTime.parse(dateTime.toString()));
  }

  static String formatDateTimeToString(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm:ss')
        .format(DateTime.parse(dateTime.toString()));
  }

  static Future<File?> createFileFromRemoteUrl(String url) async {
    try {
      // Create a Dio instance for downloading
      final dio = Dio();

      // Extract filename from URL (or use a custom name)
      final filename = url.split('/').last;

      // Get temporary directory to store the file
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$filename';

      // Download the file and save to the path
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            debugPrint('Download progress: $progress%');
          }
        },
      );

      // Check if file was downloaded successfully
      final file = File(filePath);
      if (await file.exists()) {
        debugPrint('File downloaded successfully to: $filePath');
        return file;
      } else {
        debugPrint('File download failed');
        return null;
      }
    } catch (e) {
      debugPrint('Error downloading file: $e');
      return null;
    }
  }
}
