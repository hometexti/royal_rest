import 'dart:io';

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../Operator/route.dart';
import '../utils/colors.dart';
import '../utils/textstyle.dart';
import '../widgets/custom_button2.dart';
import '../widgets/loading_indicator.dart';

class PendingListAdmin_2 extends StatefulWidget {
  final String doc_id;
  const PendingListAdmin_2({super.key, required this.doc_id});

  @override
  State<PendingListAdmin_2> createState() => _PendingListAdmin_2State();
}

class _PendingListAdmin_2State extends State<PendingListAdmin_2> {
  var name,
      operator_name,
      email,
      phonenumber,
      date,
      time,
      contract_url,
      lat,
      long,
      latitude,
      longitude;
  List images_url = [];
  getLocation() async {
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print(position.latitude);
        print(position.longitude);
        latitude = position.latitude;
        longitude = position.longitude;
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print(position.latitude);
        print(position.longitude);
        latitude = position.latitude;
        longitude = position.longitude;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  bool loading = false;
  del_request() async {
    Map<String, dynamic> data = {
      "status": "delete",
    };
    await FirebaseFirestore.instance
        .collection("form")
        .doc(widget.doc_id)
        .update(data)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Request Sent"),
      ));

      Navigator.pop(context);
    });
  }

  getdocdata() async {
    try {
      setState(() {
        loading = true;
      });
      print("okkkkkkkkk" + widget.doc_id.toString());
      final CollectionReference<Map<String, dynamic>> _usersCollection =
          FirebaseFirestore.instance.collection('form');
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _usersCollection.doc(widget.doc_id).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()!;
        setState(() {
          date = data['date'];
          time = data['time'];
          name = data['customer_name'];
          email = data['email'];
          phonenumber = data['phonenumber'];
          operator_name = data['operator_name'];
          lat = data['lat'];
          long = data['long'];
          contract_url = data['signature_url'];
          images_url = data['img_url'];
          loading = false;
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print("errorororororoor");
    }
  }

  @override
  void initState() {
    super.initState();
    // Add your initialization logic here
    getLocation();
    getdocdata();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
      body: loading == true
          ? LoadingIndicator()
          : Container(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.height * 0.025),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: Text(
                          "Check Details",
                          style: AppTextStyle.PageHeading,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.02,
                            bottom: size.height * 0.015),
                        child: Container(
                          width: size.width * 0.99,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor1,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            "Customer Name: " + name,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: Container(
                          width: size.width * 0.99,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor1,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            "Operator Name: " + operator_name,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: Container(
                          width: size.width * 0.99,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor1,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            "Customer  email: " + email,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: Container(
                          width: size.width * 0.99,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor1,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            "Customer Phonenumber: " + phonenumber,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: Container(
                          width: size.width * 0.99,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor1,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            "Meeting Date & time: " + date + " " + time,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButtonCon(
                              text: "Show Location",
                              onPressed: () async {
                                if (latitude != null && longitude != null) {
                                  Map<String, double> data1 = {
                                    "cus_lat": (lat),
                                    "cus_long": (long),
                                    "lat": (latitude),
                                    "long": (longitude)
                                  };
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          MapWithRoutePage(data: data1)));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Wait... getting your current location"),
                                  ));
                                }
                              },
                              bgColor: AppColors.primaryColor1,
                              textColor: AppColors.primaryWhiteColor,
                              width: size.width * 0.6,
                              height: size.height * 0.06,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
