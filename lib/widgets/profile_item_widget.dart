import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/utils/dimensions.dart';

class ProfileItemWidget extends StatelessWidget {
  final String leftText;
  final String? rightText;
  final bool isIcon;
  final VoidCallback callback;
  final Color color;
  const ProfileItemWidget(
      {super.key,
      required this.leftText,
      required this.rightText,
      required this.isIcon,
      this.color = Colors.black,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftText,
              style: TextStyle(
                  color: color,
                  fontWeight: color == Colors.red
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
            isIcon
                ? Row(
                    children: [
                      Text(
                        rightText ?? "Non défini",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Dimensions.horizontalSpacer(10),
                      const FaIcon(
                        FontAwesomeIcons.angleRight,
                        size: 14,
                      )
                    ],
                  )
                : Text(
                    rightText ?? "Non défini",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
          ],
        ),
      ),
    );
  }
}
