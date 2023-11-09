import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/textstyle.dart';
import '../widgets/custom_button2.dart';
import 'editfile2.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _EditFileState();
}

class _EditFileState extends State<Help> {
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('form');
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.primaryColor1,
          centerTitle: true,
          title: Text(
            "Info About App",
            style: AppTextStyle.appNameTextStyle,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.linearGradientPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01, horizontal: size.height * 0.025),
            child: Container(
                child: Column(
              children: [
                Text(
                    "\n\nCreate New Project: Operator can create new file where he/she have to enter basic details about customer as well as customer signature and location\n\nExisting Project: Here operator can add more details like images etc.\n\nCompleted Projects: Here operator can see completed projects also he/she can send a deletion request to admin."),
                Text("\nDeveloped by: "),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'lib/assets/images/logo.png',
                  //width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("web: sartecsoftware.co.uk"),
              ],
            )),
          ),
        ));
  }
}
