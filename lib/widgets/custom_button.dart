import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color textColor;
  const CustomButton({Key? key,required this.text,required this.onPressed,required this.bgColor,required this.textColor}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            primary: bgColor,
            side: const BorderSide(
              width: 3.0,
              color: AppColors.primaryColor1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            )
        ),
        child:  Text(text,style: TextStyle(color: textColor,fontSize: 14 ),));
  }
}
