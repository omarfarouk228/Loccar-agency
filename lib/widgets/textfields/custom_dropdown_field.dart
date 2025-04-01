import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/utils/colors.dart';

// ignore: must_be_immutable
class CustomDropButton<T> extends StatefulWidget {
  CustomDropButton(
      {required this.hintText,
      required this.options,
      this.currentValue,
      this.height = 55,
      required this.onChanged,
      required this.active,
      required this.displayStringForOption,
      Key? key})
      : super(key: key);

  final String hintText;
  final List<T> options;
  T? currentValue;
  final bool active;
  double height = 50;
  final Function(T?) onChanged;
  final String Function(T) displayStringForOption;

  @override
  State<CustomDropButton<T>> createState() => _CustomDropButtonState<T>();
}

class _CustomDropButtonState<T> extends State<CustomDropButton<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.active ? chooseOption() : const Center(),
      child: Container(
        width: double.infinity,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: ShapeDecoration(
          color: AppColors.placeholderBg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.currentValue != null
                ? widget.displayStringForOption(widget.currentValue as T)
                : widget.hintText),
            widget.active
                ? const FaIcon(FontAwesomeIcons.angleDown)
                : const Center()
          ],
        ),
      ),
    );
  }

  chooseOption() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.options
                    .map((element) => GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.onChanged(element);
                              widget.currentValue = element;
                              Navigator.pop(context);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(widget.displayStringForOption(element)),
                          ),
                        ))
                    .toList(),
              ),
            ));
  }
}
