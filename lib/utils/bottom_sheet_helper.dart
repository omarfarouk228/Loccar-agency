import 'package:flutter/material.dart';
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
        builder: (context2) {
          return StatefulBuilder(
              builder: (context2, setState) => Container(
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
                                Navigator.pop(context2);
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
                                Navigator.pop(context2);
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
}
