// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/clippath.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/small_divider.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../utils/textstyle.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

enum GenderType { male, female }

class _SignUpScreenState extends State<SignUpScreen> {
  GenderType _gender = GenderType.male;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _sex = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double latitude = 0.0;
  double longitude = 0.0;

  //final AuthMethods _authMethods = AuthMethods();
  bool progress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _obscureText = true;
  bool _obscureText1 = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Operator Account"),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 35,
            ),
            Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter Details",
                      style: AppTextStyle.signInHeading,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Create a new operator account.",
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
                      AppStrings.name,
                      style: AppTextStyle.testFieldHeading,
                    ),
                    CustomTextField(
                      controller: _name,
                      hint: AppStrings.hintName,
                    ),
                    const Divider(color: AppColors.primaryColor1, thickness: 1),
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
                      validator: (var value) {
                        if (value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                      obsecuteText: _obscureText,
                      controller: _passwordController,
                      hint: AppStrings.hintPassword,
                    ),
                    const Divider(color: AppColors.primaryColor1, thickness: 1),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      AppStrings.confirmPassword,
                      style: AppTextStyle.testFieldHeading,
                    ),
                    CustomTextField(
                      icon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText1 = !_obscureText1;
                            });
                          },
                          child: Icon(
                            _obscureText1
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 22,
                            color: AppColors.primaryColor1,
                          ),
                        ),
                      ),
                      obsecuteText: _obscureText1,
                      validator: (var value) {
                        if (value.isEmpty) {
                          return 'Please re-enter password';
                        }
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                      controller: _confirmPasswordController,
                      hint: AppStrings.hintPassword,
                    ),
                    const Divider(color: AppColors.primaryColor1, thickness: 1),
                    const SizedBox(
                      height: 20,
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
                                    signUp();
                                  },
                                  text: "Create",
                                  textColor: AppColors.primaryWhiteColor,
                                  height: size.height * 0.055,
                                  width: size.width * 0.28,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void signUp() async {
    FocusScope.of(context).unfocus();
    if (_emailController.text == "" ||
        _passwordController.text == "" ||
        _name.text == "") {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Warning"),
                content: Text("Fields cannot be empty"),
              ));
    } else if (_passwordController.text.length < 6) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Warning"),
                content:
                    Text("Password length should be more then 6 characters"),
              ));
    } else if (_emailController.text.contains("@") == false) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Warning"),
                content: Text("Email is not valid"),
              ));
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Warning"),
                content: Text("Passwords does not match."),
              ));
    } else {
      try {
        setState(() {
          progress = true;
        });
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim())
            .then((value2) {
          FirebaseMessaging.instance.getToken().then((value1) {
            print(value1);
            Map<String, dynamic> users = {
              "id": value2.user!.uid,
              "userName": _name.text,
              "userEmail": _emailController.text,
              "can_login": true
            };
            FirebaseFirestore.instance
                .collection('users')
                .doc(value2.user!.uid)
                .set(users)
                .whenComplete(() {
              setState(() {
                progress = false;
              });
              _emailController.text = "";
              _name.text = "";
              _passwordController.text = "";
              _confirmPasswordController.text = '';
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Account Created"),
              ));
            });
          });
        });
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
