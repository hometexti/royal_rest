import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/textstyle.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _EditFileState();
}

class _EditFileState extends State<DeleteAccount> {
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  delaccount(var email) async {
    var updatedData = {"can_login": false};
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("userEmail", isEqualTo: email)
          .limit(1)
          .get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.update(updatedData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Account Deleted"),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.primaryColor1,
          centerTitle: true,
          title: Text(
            "Operator account list",
            style: AppTextStyle.appNameTextStyle,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.linearGradientPrimary,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _usersCollection
                .where('can_login', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.data?.size == 0) {
                return Center(
                  child: Text("No operator Account Found"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data();

                  return ListTile(
                    leading: Icon(Icons.account_circle_sharp),
                    title: Text(
                      data['userName'],
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(data['userEmail'].toString()),
                    trailing: GestureDetector(
                      onTap: () {
                        if (data['userEmail'] ==
                            "royalrestorationapp@gmail.com") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("You cannot delete admin Account"),
                          ));
                        } else {
                          delaccount(data['userEmail']);
                        }
                        // Handle tap on trailing widget
                      },
                      child: Icon(Icons.delete_forever),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                        side: BorderSide(color: AppColors.primaryColor1)),
                    onTap: () {
                      // Perform action when the list tile is tapped
                      /*   Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => DeleteAccount_2(
                              doc_id: data['doc_id'].toString()))); */
                    },
                  );
                }).toList(),
              );
            }));
  }
}
