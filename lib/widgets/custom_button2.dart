import 'package:flutter/cupertino.dart';
import '../utils/colors.dart';

class CustomButtonCon extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color textColor;
  CustomButtonCon(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.bgColor,
      required this.textColor,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 3.5, color: AppColors.primaryColor1),
            color: bgColor,
            borderRadius: BorderRadius.circular(20)),
        height: height,
        width: width,
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
