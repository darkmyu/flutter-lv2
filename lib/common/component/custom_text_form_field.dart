import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String> onChanged;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: inputBorderColor,
        width: 1,
      ),
    );

    return TextFormField(
      cursorColor: primaryColor,
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: bodyTextColor,
          fontSize: 14,
        ),
        fillColor: inputBgColor,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
