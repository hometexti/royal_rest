import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/textstyle.dart';

class FileDeletionRequest extends StatefulWidget {
  const FileDeletionRequest({super.key});

  @override
  State<FileDeletionRequest> createState() => _EditFileState();
}

class _EditFileState extends State<FileDeletionRequest> {
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('form');

  Future<void> deleteFolder(String folderName) async {
    final Reference folderReference =
        FirebaseStorage.instance.ref().child(folderName);

    // List all items (files and subfolders) within the folder
    final ListResult result = await folderReference.listAll();

    // Delete all files within the folder
    await Future.forEach(result.items, (Reference item) async {
      await item.delete();
    });

    // Delete the folder itself
    //await folderReference.delete();
  }

  accept(var id) async {
    try {
      try {
        var filename;
        await FirebaseFirestore.instance
            .collection("form")
            .doc(id)
            .get()
            .then((value) {
          String t = value["customer_name"];
          String t1 = value["date"];
          String t2 = value["time"];
          filename = t + t1 + t2 + "/";
        });
        print("////////////////////////////////");
        print(filename);

        await deleteFolder(filename);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
      var updatedData = {"status": "deleted"};
      await FirebaseFirestore.instance
          .collection("form")
          .doc(id)
          .update(updatedData)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("File Deleted"),
        ));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  reject(var id) async {
    try {
      var updatedData = {"status": "contracted"};
      await FirebaseFirestore.instance
          .collection("form")
          .doc(id)
          .update(updatedData)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Deletion Request Rejected"),
        ));
      });
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
            "File Deletion Requests",
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
                .where('status', isEqualTo: "delete")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.data?.size == 0) {
                return Center(
                  child: Text("No Request Found"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data();

                  return ListTile(
                    leading: Icon(Icons.file_copy),
                    title: Text(
                      "Name: " + data['customer_name'],
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                        "requested by: " + data['operator_name'].toString()),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                        side: BorderSide(color: AppColors.primaryColor1)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(50.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text('Accept Request'),
                                    onTap: () {
                                      // Handle option 1 selection
                                      Navigator.pop(context);
                                      accept(data['doc_id']);
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(45),
                                        side: BorderSide(
                                            color: AppColors.primaryColor1)),
                                  ),
                                  ListTile(
                                    title: Text('Reject Request'),
                                    onTap: () {
                                      // Handle option 2 selection
                                      Navigator.pop(context);
                                      reject(data['doc_id']);
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(45),
                                        side: BorderSide(
                                            color: AppColors.primaryColor1)),
                                  ),
                                  ListTile(
                                    title: Text('Close'),
                                    onTap: () {
                                      // Handle option 3 selection
                                      Navigator.pop(context);
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(45),
                                        side: BorderSide(
                                            color: AppColors.primaryColor1)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      // Perform action when the list tile is tapped
                      /*   Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FileDeletionRequest_2(
                              doc_id: data['doc_id'].toString()))); */
                    },
                  );
                }).toList(),
              );
            }));
  }
}
