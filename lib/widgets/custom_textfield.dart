import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  String hint;
  var validator;
  bool? obsecuteText;
  var icon;
  CustomTextField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.validator,
      this.obsecuteText = false,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecuteText!,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: icon,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: const EdgeInsets.only(bottom: 11, top: 11, right: 15),
        hintText: hint,
        hintStyle:
            const TextStyle(color: AppColors.primaryColor2, fontSize: 14),
      ),
    );
  }
}
