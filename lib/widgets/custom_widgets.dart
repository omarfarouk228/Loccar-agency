import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loccar_agency/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;

  const CustomButton(
      {super.key,
      required this.color,
      required this.textColor,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(color),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(10)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
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
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? errorMessage;
  final TextInputType? type;
  final int maxLength;
  final int maxLines;
  const CustomInput(
      {Key? key,
      this.controller,
      this.hint,
      this.errorMessage,
      this.type,
      this.maxLines = 1,
      required this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          keyboardType: type,
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
          ],
          maxLines: maxLines,
          style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.currentFontFamily,
            fontSize: 15,
          ),
          validator: (String? value) {
            if (value == null || value == '') {
              return errorMessage;
            }
            return null;
          },
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              hintText: hint!,
              labelText: hint,
              border: const OutlineInputBorder()),
          controller: controller,
        ));
  }
}
