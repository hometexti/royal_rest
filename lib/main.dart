import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../signin.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'Admin/adminhomepage.dart';
import 'Operator/operatorhomepage.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // Set portrait orientation
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Selection(),
    );
  }
}

class Selection extends StatefulWidget {
  const Selection({super.key});

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  void initState() {
    super.initState();
    autologin();
  }

  final _auth = FirebaseAuth.instance;
  var email, password;
  autologin() async {
    print("called");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      email = await prefs.getString('email');
      password = await prefs.getString('password');
      if (email == null || password == null) {
        FlutterNativeSplash.remove();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
        return;
      }
      final fuser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (fuser != null) {
        if (email == 'royalrestorationapp@gmail.com') {
          FlutterNativeSplash.remove();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AdminHomepage()));
          return;
        } else {
          final querySnapshot = await FirebaseFirestore.instance
              .collection("users")
              .where("userEmail", isEqualTo: email)
              .limit(1)
              .get();
          if (querySnapshot.size > 0) {
            var check = querySnapshot.docs.first['can_login'];
            if (check) {
              FlutterNativeSplash.remove();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => OPeratorHomepage()));
              return;
            } else {
              FlutterNativeSplash.remove();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Your Account is terminated, Contact with Admin"),
              ));
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
              return;
            }
          }
        }
      } else {
        FlutterNativeSplash.remove();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
        return;
      }
    } catch (e) {
      FlutterNativeSplash.remove();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor1,
        ),
      ),
    );
  }
}
