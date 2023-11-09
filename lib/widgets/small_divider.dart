import 'package:flutter/cupertino.dart';

import '../../utils/colors.dart';

class CustomSmallDivider extends StatelessWidget {
  const CustomSmallDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primaryColor1
      ),
    );
  }
}
