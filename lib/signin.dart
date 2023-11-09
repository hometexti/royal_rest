// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../Admin/adminhomepage.dart';
import '../../Operator/operatorhomepage.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../utils/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/clippath.dart';

import '../../widgets/custom_button2.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/small_divider.dart';
import 'forgetpassword.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    _passwordController.dispose();
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
                    AppStrings.singIn,
                    style: AppTextStyle.signInHeading,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    AppStrings.signInSubTitle,
                    style: AppTextStyle.signInSubHeading,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomSmallDivider(),
                  const SizedBox(
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
                    height: 10,
                  ),
                  const Text(
                    AppStrings.password,
                    style: AppTextStyle.testFieldHeading,
                  ),
                  CustomTextField(
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: () {
                          _toggle();
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 22,
                          color: AppColors.primaryColor1,
                        ),
                      ),
                    ),
                    obsecuteText: _obscureText,
                    controller: _passwordController,
                    hint: AppStrings.hintPassword,
                  ),
                  const Divider(color: AppColors.primaryColor1, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyle.testFieldHeading,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPassword()));
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  progress == true
                      ? const LoadingIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButtonCon(
                                bgColor: AppColors.primaryColor1,
                                onPressed: () {
                                  signIn();
                                },
                                text: AppStrings.singIn,
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

  void signIn() async {
    final _auth = FirebaseAuth.instance;
    if (_emailController.text == "" || _passwordController.text == "") {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Warning"),
                content: Text("Fields cannot be empty"),
              ));
    } else {
      try {
        setState(() {
          progress = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final fuser = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        if (fuser != null) {
          setState(() {
            progress = false;
          });

          prefs.setString('email', _emailController.text);
          prefs.setString('password', _passwordController.text);
          print(_emailController.text.toString());
          if (_emailController.text == 'royalrestorationapp@gmail.com') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AdminHomepage()));
          } else {
            final querySnapshot = await FirebaseFirestore.instance
                .collection("users")
                .where("userEmail", isEqualTo: _emailController.text)
                .limit(1)
                .get();
            if (querySnapshot.size > 0) {
              var check = querySnapshot.docs.first['can_login'];
              if (check) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OPeratorHomepage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Your Account is terminated, Contact with Admin"),
                ));
              }
            }
          }
        } else {
          setState(() {
            progress = false;
          });
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Warning"),
                    content: Text("Invalid email and password"),
                  ));
        }
      } catch (e) {
        setState(() {
          progress = false;
        });
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Warning"),
                  content: Text("Invalid email and password"),
                ));
      }
    }
  }
}
