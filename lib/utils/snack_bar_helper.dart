import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showCustomSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.redAccent,
      Duration duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.white, fontSize: 14),
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        margin: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
