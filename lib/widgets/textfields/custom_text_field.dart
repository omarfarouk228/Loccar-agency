import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loccar_agency/utils/colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required String hintText,
    required TextEditingController controller,
    String? errorMessage,
    int maxLength = 15,
    int maxLines = 1,
    int typeBorder = 1,
    double height = 50,
    Color background = AppColors.placeholderBg,
    EdgeInsets padding = const EdgeInsets.only(left: 15),
    String value = "",
    bool enabled = true,
    bool autofocus = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    super.key,
  })  : _hintText = hintText,
        _padding = padding,
        _controller = controller,
        _maxLength = maxLength,
        _maxLines = maxLines,
        _height = height,
        _value = value,
        _enabled = enabled,
        _typeBorder = typeBorder,
        _background = background,
        _errorMessage = errorMessage,
        _autofocus = autofocus,
        _keyboardType = keyboardType,
        _suffixIcon = suffixIcon;

  final String _hintText;
  final EdgeInsets _padding;
  final TextEditingController? _controller;
  final int _maxLength;
  final int _maxLines;
  final int _typeBorder;
  final String _value;
  final double _height;
  final Color _background;
  final bool _enabled;
  final bool _autofocus;
  final TextInputType _keyboardType;
  final String? _errorMessage;
  final Widget? _suffixIcon;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    setState(() {
      widget._controller?.text = widget._value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget._height,
      decoration: ShapeDecoration(
        color: widget._background,
        shape: widget._typeBorder == 1
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            : const OutlineInputBorder(),
      ),
      alignment: Alignment.centerLeft,
      child: TextFormField(
        maxLines: widget._maxLines,
        readOnly: !widget._enabled,
        autofocus: widget._autofocus,
        // enabled: widget._enabled,
        keyboardType: widget._keyboardType,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget._maxLength),
        ],
        controller: widget._controller,
        validator: (String? value) {
          if (value == null || value == '') {
            return widget._errorMessage;
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget._hintText,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
          contentPadding: widget._padding,
          suffixIcon: widget._suffixIcon,
        ),
      ),
    );
  }
}
