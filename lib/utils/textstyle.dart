import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyle {
  static const TextStyle signInHeading = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryColor1);

  static const TextStyle signInSubHeading = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryColor1);

  static const TextStyle testFieldHeading = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryColor1);

  static const TextStyle PageHeading = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryColor1);

  static const TextStyle testFieldHeading1 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);

  static TextStyle bottomNavTextStyle = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      foreground: Paint()..shader = AppColors.linearGradientShader);

  static TextStyle appNameTextStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryWhiteColor);
}
