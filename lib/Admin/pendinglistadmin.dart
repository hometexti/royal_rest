import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Admin/pendinglistadmin_2.dart';

import '../utils/colors.dart';
import '../utils/textstyle.dart';

class PendingListAdmin extends StatefulWidget {
  const PendingListAdmin({super.key});

  @override
  State<PendingListAdmin> createState() => _EditFileState();
}

class _EditFileState extends State<PendingListAdmin> {
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
            "Pending List",
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
                .where('status', isEqualTo: "pending")
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
                          builder: (_) => PendingListAdmin_2(
                              doc_id: data['doc_id'].toString())));
                    },
                  );
                }).toList(),
              );
            }));
  }
}
