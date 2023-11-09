import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/colors.dart';

class WelcomeWaveClipper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: MyClipper2(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.89,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
            ),
          ),
        ),
        ClipPath(
          clipper: MyClipper1(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              gradient: AppColors.linearGradientPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 120);
    path.quadraticBezierTo(
        size.width / 4, size.height / 2.7, size.width / 1.8, size.height - 100);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height - 60,
        size.width, size.height - 60);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MyClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 85);
    path.quadraticBezierTo(
        size.width / 5, size.height / 1.26, size.width / 2.1, size.height - 60);
    path.quadraticBezierTo(
        size.width - (size.width / 3.5), size.height, size.width, size.height);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 130);
    path.quadraticBezierTo(size.width / 4.1, size.height / 1.31,
        size.width / 1.5, size.height - 81.8);
    path.quadraticBezierTo(size.width - (size.width / 5), size.height - 62.5,
        size.width, size.height - 60);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
