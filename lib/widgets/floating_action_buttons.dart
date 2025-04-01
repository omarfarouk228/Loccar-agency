import 'package:flutter/material.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:loccar_agency/widgets/buttons/sized_button.dart';

class CustomFloatingActionButtons extends StatelessWidget {
  final List<IconData> iconsData;
  final List<VoidCallback> callbacks;
  final List<Color> colors;

  const CustomFloatingActionButtons(
      {super.key,
      required this.iconsData,
      required this.callbacks,
      this.colors = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        alignment: Alignment.center,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: iconsData
                    .map((iconData) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SizedButton(
                            width: 40,
                            height: 40,
                            color: colors.isNotEmpty &&
                                    iconsData.contains(iconData)
                                ? colors[iconsData.indexOf(iconData)]
                                : AppColors.secondaryColor,
                            onPressed: callbacks[iconsData.indexOf(iconData)],
                            child: Icon(
                              iconData,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ))
                    .toList()),
          ),
        ));
  }
}
