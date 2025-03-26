import 'package:flutter/material.dart';

class Dimensions {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static Widget verticalSpacer(double space) {
    return SizedBox(height: space);
  }

  static Widget horizontalSpacer(double space) {
    return SizedBox(width: space);
  }
}
