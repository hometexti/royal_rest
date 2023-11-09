import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Operator/acceptedlist2.dart';

import '../utils/colors.dart';
import '../utils/textstyle.dart';
import 'editfile2.dart';

class AcceptedList extends StatefulWidget {
  const AcceptedList({super.key});

  @override
  State<AcceptedList> createState() => _EditFileState();
}

class _EditFileState extends State<AcceptedList> {
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('form');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.primaryColor1,
          centerTitle: true,
          title: Text(
            "Completed Projects",
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
                .where('status', isEqualTo: "contracted")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.data?.size == 0) {
                return Center(
                  child: Text("No File Found"),
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
                      data['customer_name'],
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(data['email'].toString()),
                    trailing: Icon(Icons.arrow_forward),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                        side: BorderSide(color: AppColors.primaryColor1)),
                    onTap: () {
                      // Perform action when the list tile is tapped
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AcceptedList_2(
                              doc_id: data['doc_id'].toString())));
                    },
                  );
                }).toList(),
              );
            }));
  }
}
