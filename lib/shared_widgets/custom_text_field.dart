import 'package:flutter/material.dart';
import 'package:vitaro/core/theme/app_theme.dart'; // To use your theme colors

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscured : false,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        // The style (fillColor, border) is automatically
        // picked up from 'InputDecorationTheme' in 'app_theme.dart'.
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: AppTheme.textLight)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.textLight,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        )
            : null,
      ),
      // We will add validation logic here later
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${widget.hintText} cannot be empty';
        }
        // Add more specific validation (e.g., email format)
        if (widget.hintText.toLowerCase().contains('email') && !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}