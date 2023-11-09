import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/strings.dart';

class TextFormSecond extends StatelessWidget {
  var controller;
  var icon;
  var onTap;
  var readOnly;
  var maxLines;
  var type;
  // var validator;
  String hint;
  TextFormSecond(
      {Key? key,
      this.controller,
      required this.hint,
      this.icon,
      this.onTap,
      this.readOnly = false,
      this.type,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: type,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter Data';
        }
        return null;
      },
      onTap: onTap,
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        suffixIcon: icon,
        contentPadding:
            const EdgeInsets.only(bottom: 11, top: 11, right: 15, left: 20),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        fillColor: AppColors.primaryColor1,
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black45,
        ),
      ),
    );
  }
}
