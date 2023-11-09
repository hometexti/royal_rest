import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor1 = Color(0xffED8F12);
  static const primaryColor2 = Color(0xffFBC174);
  static const primaryWhiteColor = Colors.white;
  static const primaryGrayColor = Colors.grey;
  static const backgroundColor = Colors.black12;
  static const linearGradientPrimary = LinearGradient(
    colors: [AppColors.primaryColor1, AppColors.primaryColor2],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: [0.4, 0.7],
    tileMode: TileMode.repeated,
  );

  static Shader linearGradientShader = const LinearGradient(
    colors: <Color>[AppColors.primaryColor1, AppColors.primaryColor2],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
}
