import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../signin.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../utils/textstyle.dart';
import '../../widgets/clippath.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/small_divider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  //final AuthMethods _authMethods = AuthMethods();
  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool progress = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWaveClipper(),
            Padding(
              padding: const EdgeInsets.only(left: 28.0, right: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.forgetPassword,
                    style: AppTextStyle.signInHeading,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    AppStrings.forgotPassSubTitle,
                    style: AppTextStyle.signInSubHeading,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const CustomSmallDivider(),
                  SizedBox(
                    height: 30,
                  ),
                  const Text(
                    AppStrings.emailAddress,
                    style: AppTextStyle.testFieldHeading,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hint: AppStrings.hintEmail,
                  ),
                  const Divider(color: AppColors.primaryColor1, thickness: 1),
                  const SizedBox(
                    height: 30,
                  ),
                  progress == true
                      ? const LoadingIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButtonCon(
                                bgColor: AppColors.primaryColor1,
                                onPressed: () {
                                  forgetPassword();
                                  // Navigator.push(context, MaterialPageRoute(builder:  (context) => VerifyPassword()));
                                },
                                text: AppStrings.sendCode,
                                textColor: AppColors.primaryWhiteColor,
                                height: size.height * 0.055,
                                width: size.width * 0.28,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  forgetPassword() {
    if (_emailController.text != "") {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text)
          .then((value) {
        AwesomeDialog(
          customHeader: Container(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryColor1,
              child: Icon(
                size: 30,
                Icons.check,
                color: AppColors.primaryWhiteColor,
              ),
            ),
          ),
          btnOkColor: AppColors.primaryColor1,
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: AppStrings.success,
          desc: AppStrings.passwordSent,
          btnOkOnPress: () {
            setState(() {
              progress = false;
            });
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInScreen()));
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          },
        ).show();
      }).catchError(() {
        setState(() {
          progress = false;
        });
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Warning"),
                  content: Text("Invalid email"),
                ));
      });
    } else {
      setState(() {
        progress = false;
      });
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Warning"),
                content: Text("Invalid email"),
              ));
    }
  }
}
