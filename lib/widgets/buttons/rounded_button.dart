import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;
  final double radius;
  final bool isActive;

  const RoundedButton(
      {super.key,
      required this.color,
      required this.textColor,
      required this.text,
      required this.onPressed,
      this.radius = 10.0,
      this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: isActive
          ? ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(color),
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(10)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius),
                  ))),
              onPressed: onPressed,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: textColor, fontWeight: FontWeight.bold),
              ),
            )
          : Container(
              height: 45,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: textColor, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
