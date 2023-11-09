import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Operator/acceptedlist.dart';
import '../../Operator/editfile.dart';
import '../../Operator/pendinglist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Admin/createaccount.dart';
import '../signin.dart';
import '../utils/colors.dart';
import 'help.dart';
import 'newform.dart';

class OPeratorHomepage extends StatefulWidget {
  const OPeratorHomepage({super.key});

  @override
  State<OPeratorHomepage> createState() => _OPeratorHomepageState();
}

class _OPeratorHomepageState extends State<OPeratorHomepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  logout() {
    FirebaseAuth.instance.signOut().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await FirebaseAuth.instance.signOut();
      prefs.clear().then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInScreen()));
      });
    });
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Operator Panel"),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: Container(
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                'lib/assets/images/1.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'lib/assets/images/third.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Welcome to\nRestoration Company',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 118, 0, 0),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                    // Perform action on button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor1,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // padding: EdgeInsets.zero,
          children: [
            Image.asset(
              'lib/assets/images/third.png',
              //width: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.document_scanner_sharp),
              title: const Text('Create new Project'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: AppColors.primaryColor1)),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const Newform()));
              },
            ),
            ListTile(
              leading: Icon(Icons.edit_document),
              title: const Text('Existing project'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: AppColors.primaryColor1)),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const EditFile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.filter_list),
              title: const Text('Completed Projects'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: AppColors.primaryColor1)),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AcceptedList()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded),
              title: const Text('Logout'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: AppColors.primaryColor1)),
              onTap: () {
                Navigator.pop(context);
                logout();
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: const Text('Help'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: AppColors.primaryColor1)),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const Help()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
