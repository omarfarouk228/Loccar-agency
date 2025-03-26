import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/utils/colors.dart';

// ignore: must_be_immutable
class CustomPasswordField extends StatefulWidget {
  CustomPasswordField({
    required String hintText,
    required TextEditingController controller,
    required String errorMessage,
    int typeBorder = 1,
    double height = 50,
    Color background = AppColors.placeholderBg,
    EdgeInsets padding = const EdgeInsets.only(left: 15, top: 14),
    required bool passwordVisible,
    super.key,
  })  : _hintText = hintText,
        _padding = padding,
        _controller = controller,
        _height = height,
        _typeBorder = typeBorder,
        _background = background,
        _passwordVisible = passwordVisible,
        _errorMessage = errorMessage;

  final String _hintText;
  final EdgeInsets _padding;
  final TextEditingController? _controller;
  final int _typeBorder;
  final double _height;
  final Color _background;
  bool _passwordVisible;
  final String? _errorMessage;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  // Regex pour chaque règle
  bool hasUppercase(String password) => password.contains(RegExp(r'[A-Z]'));
  bool hasLowercase(String password) => password.contains(RegExp(r'[a-z]'));
  bool hasDigit(String password) => password.contains(RegExp(r'[0-9]'));
  bool hasSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#&()\-\[\]{}:;\",?/*~$^+=<>]'));
  bool hasValidLength(String password) =>
      password.length >= 8 && password.length <= 20;

  @override
  void initState() {
    super.initState();
  }

// Fonction de validation globale
  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return widget._errorMessage;
    }
    if (!hasDigit(password)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    /*if (!hasLowercase(password)) {
      return 'Le mot de passe doit contenir une lettre minuscule';
    }
    if (!hasUppercase(password)) {
      return 'Le mot de passe doit contenir une lettre majuscule';
    }
    if (!hasSpecialChar(password)) {
      return 'Le mot de passe doit contenir un caractère spécial';
    }
    if (!hasValidLength(password)) {
      return 'Le mot de passe doit contenir entre 8 et 20 caractères';
    }*/

    return null; // valide si tout est bon
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
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: widget._passwordVisible,
        controller: widget._controller,
        validator: _validatePassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget._hintText,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
          contentPadding: widget._padding,
          prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
                widget._passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey),
            onPressed: () {
              setState(() {
                widget._passwordVisible = !widget._passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
