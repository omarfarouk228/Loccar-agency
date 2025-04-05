import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/utils/dimensions.dart';

class BottomSheetHelper {
  static showModalSheetWithConfirmationButton(BuildContext context,
      Widget widget, String title, String content, Function() onPressed) {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 0,
        isDismissible: true,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (ctx, setState) => Container(
                    color: Colors.white,
                    height: Dimensions.getScreenHeight(context) * 0.3,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                          radius: 30,
                          child: widget,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          content,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35),
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.red),
                                  foregroundColor: Colors.red),
                              child: const Text("NON"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                onPressed.call();
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35),
                                  backgroundColor: Colors.white,
                                  side:
                                      BorderSide(color: AppColors.primaryColor),
                                  foregroundColor: AppColors.primaryColor),
                              child: const Text("OUI"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
        });
  }

  static showCustomBottomSheet(
      BuildContext context, String title, Widget widget,
      {double heightRatio = 0.5}) {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (ctx, setState) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    height: Dimensions.getScreenHeight(context) * heightRatio,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: [
                        Dimensions.verticalSpacer(15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 15,
                                child: const FaIcon(
                                  FontAwesomeIcons.xmark,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        widget
                      ],
                    ),
                  ));
        });
  }

  static showLoadingModalSheet(BuildContext context, String content) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (ctx, setState) => Container(
                    padding: const EdgeInsets.all(20),
                    height: Dimensions.getScreenHeight(context) * 0.2,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Dimensions.verticalSpacer(15),
                        SpinKitFadingCube(
                            color: AppColors.primaryColor, size: 30),
                        Dimensions.verticalSpacer(20),
                        Text(
                          content,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ));
        });
  }
}
