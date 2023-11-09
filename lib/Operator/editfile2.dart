import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing/printing.dart';

import '../../Operator/pdf.dart';
import '../../Operator/route.dart';
import '../../Operator/textformsecond.dart';

import '../utils/colors.dart';
import '../utils/textstyle.dart';
import '../widgets/custom_button2.dart';
import '../widgets/loading_indicator.dart';

import 'package:flutter/services.dart';

class EditFile2 extends StatefulWidget {
  final String doc_id;
  const EditFile2({super.key, required this.doc_id});

  @override
  State<EditFile2> createState() => _EditFile2State();
}

class _EditFile2State extends State<EditFile2> {
  //drying log
  TextEditingController dateControllerlog = TextEditingController();
  TextEditingController timeControllerlog = TextEditingController();
  List<TextEditingController> materialListControllers =
      List.generate(5, (index) => TextEditingController());
  List<TextEditingController> surfaceMeterListControllers =
      List.generate(5, (index) => TextEditingController());
  List<TextEditingController> penetrateMeterListControllers =
      List.generate(5, (index) => TextEditingController());
  TextEditingController numberOfFansController = TextEditingController();
  TextEditingController numberOfDehumidifiersController =
      TextEditingController();
  TextEditingController numberOfAirScrubbersController =
      TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController waterclassController = TextEditingController();
  TextEditingController watercategoryController = TextEditingController();
  TextEditingController outsideTempController = TextEditingController();
  TextEditingController outsideRHController = TextEditingController();
  TextEditingController outsideGPPController = TextEditingController();
  TextEditingController insideTempController = TextEditingController();
  TextEditingController insideRHController = TextEditingController();
  TextEditingController insideGPPController = TextEditingController();
  TextEditingController unaffectedTempController = TextEditingController();
  TextEditingController unaffectedRHController = TextEditingController();
  TextEditingController unaffectedGPPController = TextEditingController();
  TextEditingController dehumidifier1TempController = TextEditingController();
  TextEditingController dehumidifier1RHController = TextEditingController();
  TextEditingController dehumidifier1GPPController = TextEditingController();
  TextEditingController dehumidifier1GDController = TextEditingController();
  TextEditingController dehumidifier2TempController = TextEditingController();
  TextEditingController dehumidifier2RHController = TextEditingController();
  TextEditingController dehumidifier2GPPController = TextEditingController();
  TextEditingController dehumidifier2GDController = TextEditingController();
  TextEditingController otherACTempController = TextEditingController();
  TextEditingController otherACRHController = TextEditingController();
  TextEditingController otherACGPPController = TextEditingController();
  TextEditingController otherACGDController = TextEditingController();

  //
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController contractController = TextEditingController();
  final TextEditingController dryinglogController = TextEditingController();
  final TextEditingController equipmentController = TextEditingController();
  final TextEditingController technicianController = TextEditingController();
  final TextEditingController JobController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var image;
  bool check2 = false;
  var waterclass, watercategory, room, floor;
  var name = '',
      operator_name = '',
      email = '',
      phonenumber = '',
      date = '',
      time = '',
      contract_url = '',
      lat,
      long,
      latitude,
      longitude,
      policy = '',
      lossdate = '',
      losstime = '',
      referby = '',
      job = '',
      operatorname = '',
      drying_log_days;
  var room_get, floor_get, waterclass_get, watercat_get;
  Map<String, dynamic> dryinglogday1 = {},
      dryinglogday2 = {},
      dryinglogday3 = {},
      dryinglogday4 = {},
      dryinglogday5 = {};

  List images_url = [];
  Map<String, dynamic> drying_log_map = {
    "date": "",
    "time": "",
    "materiallist1": "",
    "materiallist2": "",
    "materiallist3": "",
    "materiallist4": "",
    "materiallist5": "",
    "surfacemeterlist1": "",
    "surfacemeterlist2": "",
    "surfacemeterlist3": "",
    "surfacemeterlist4": "",
    "surfacemeterlist5": "",
    "penetratemeterlist1": "",
    "penetratemeterlist2": "",
    "penetratemeterlist3": "",
    "penetratemeterlist4": "",
    "penetratemeterlist5": "",
    "fan": "",
    "dehumidifiers": "",
    "airscrubbers": "",
    "out_temp": "",
    "out_rh": "",
    "out_gpp": "",
    "in_temp": "",
    "in_rh": "",
    "int_gpp": "",
    "area_temp": "",
    "area_rh": "",
    "area_gpp": "",
    "de1_temp": "",
    "de1_rh": "",
    "de1_gpp": "",
    "de1_gd": "",
    "de2_temp": "",
    "de2_rh": "",
    "de2_gpp": "",
    "de2_gd": "",
    "other_temp": "",
    "other_rh": "",
    "other_gpp": "",
    "other_gd": "",
  };

  List<XFile>? imageFiles;
  UploadTask? uploadTask;
  var pdf_file_to_upload;
  bool datasaved = false;
  List<dynamic> img_list = [];

  bool loading = false;
  bool test = false;
  List<dynamic> downloadURLs = [];
  String getTimeAsString(TimeOfDay? time) {
    return '${time?.hour}:${time?.minute.toString().padLeft(2, '0')}';
  }

  bool touch_sign = false;
  bool show_sign_area = false;
  //Uint8List? _pdfBytes;

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

  Future<void> uploadImagesToFirebase() async {
    //downloadURLs = [];
    // print(imageFiles);

    if (img_list != null && img_list!.isNotEmpty) {
      try {
        for (int i = 0; i < img_list.length; i++) {
          File file = File(img_list[i]);
          String fileName =
              name + date + time + "/image" + DateTime.now().toString();

          // Create a reference to the Firebase Storage bucket
          final Reference storageRef =
              FirebaseStorage.instance.ref().child(fileName);

          // Upload the image file to Firebase Storage
          await storageRef.putFile(file);

          // Get the download URL of the uploaded image
          String downloadURL = await storageRef.getDownloadURL();
          downloadURLs.add(downloadURL);
        }
      } catch (e) {
        print('Error uploading images: $e');
      }
    }
  }

  Future<String> fileUpload(File file) async {
    print("wait");
    try {
      String fileName =
          nameController.text + dateController.text + '/contract.pdf';

      final ref = FirebaseStorage.instance.ref().child(fileName);

      uploadTask = ref.putFile(file);
      var urrl;
      await uploadTask?.whenComplete(() async {
        urrl = await ref.getDownloadURL();
      });
      return urrl;
    } catch (e) {
      print("error");

      return "null";
    }
  }

  uploaddata(bool check1) async {
    // var pdf_link = await fileUpload(pdf_file_to_upload);

    try {
      await uploadImagesToFirebase();
      var status1;
      if (check1 == false) {
        status1 = "pending";
      } else {
        status1 = "contracted";
      }
      if (drying_log_days != 1) {
        room = "";
        floor = "";
        waterclass = "";
        watercategory = "";
      }

      Map<String, dynamic> data = {
        "img_url": downloadURLs,
        "status": status1,
        "room": room,
        "floor": floor,
        "waterclass": waterclass,
        "watercategory": watercategory,
        "equipment": equipmentController.text,
        "tech_note": technicianController.text,
        "dryinglogday$drying_log_days": drying_log_map,
        "dryinglogdays": drying_log_days + 1,
      };
      await FirebaseFirestore.instance
          .collection("form")
          .doc(phonenumber.toString() + date.toString() + time.toString())
          .update(data)
          .then((value) {});

      setState(() {
        datasaved = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error in uploading data Try Again"),
      ));
    }
    loading = false;

    setState(() {});
  }

  getdocdata() async {
    try {
      print("okkkkkkkkk" + widget.doc_id.toString());
      final CollectionReference<Map<String, dynamic>> _usersCollection =
          FirebaseFirestore.instance.collection('form');
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _usersCollection.doc(widget.doc_id).get();

      if (documentSnapshot.exists) {
        print("iiiiii");
        Map<String, dynamic> data = documentSnapshot.data()!;
        setState(() {
          room_get = data["room"];
          floor_get = data["floor"];
          watercat_get = data["watercategory"];
          waterclass_get = data["waterclass"];
          date = data['date'];
          time = data['time'];
          name = data['customer_name'];
          email = data['email'];
          phonenumber = data['phonenumber'];
          lat = data['lat'];
          long = data["long"];
          lossdate = data['loss_date'];
          losstime = data['loss_time'];
          policy = data['policy'];
          referby = data['refer_by'];
          operatorname = data['operator_name'];
          job = data['job'];
          dryinglogController.text = data["drying_log"];
          equipmentController.text = data["equipment"];
          technicianController.text = data['tech_note'];
          contract_url = data['sign_url'];

          downloadURLs = data["img_url"];
          drying_log_days = data["dryinglogdays"];
          dryinglogday1 = data["dryinglogday1"];
          dryinglogday2 = data["dryinglogday2"];
          dryinglogday3 = data["dryinglogday3"];
          dryinglogday4 = data["dryinglogday4"];
          dryinglogday5 = data["dryinglogday5"];
          print("///////");
          print(dryinglogday1["date"]);
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      /*  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error in getting data, Open Again"),
      )); */

      print("errorororororoor");
    }
  }

  Future<Uint8List> loadPngImageFromAssets(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Uint8List serial(var pdf) {
    final Uint8List pdfBytes = pdf.output();
    return pdfBytes;
  }

  dryinglog_print() async {
    final pdf = pw.Document();
    //final pdfData = await rootBundle.load('lib/assets/file/royal restoration.png');
    var imageBytes =
        await loadPngImageFromAssets('lib/assets/file/royal restoration.png');

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
            child: pw.Stack(
          children: [
            pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.cover),
            pw.Positioned(
                bottom: 692,
                left: 200,
                child: pw.Text(waterclass_get,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Positioned(
                bottom: 692,
                left: 400,
                child: pw.Text(watercat_get,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Positioned(
                bottom: 678,
                left: 45,
                child: pw.Text(name,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8))),
            pw.Positioned(
                bottom: 678,
                left: 170,
                child: pw.Text(policy,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8))),
            pw.Positioned(
                bottom: 678,
                left: 260,
                child: pw.Text(room_get,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8))),
            pw.Positioned(
                bottom: 678,
                left: 360,
                child: pw.Text(floor_get,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8))),
            pw.Positioned(
                bottom: 635,
                left: 13,
                child: pw.Text(dryinglogday1["date"],
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Positioned(
                bottom: 608,
                left: 13,
                child: pw.Text(
                  dryinglogday1["time"],
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold),
                )),
            pw.Positioned(
                bottom: 637,
                left: 92,
                child: pw.Text(
                  dryinglogday1["materiallist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 623,
                left: 92,
                child: pw.Text(
                  dryinglogday1["materiallist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 609,
                left: 92,
                child: pw.Text(
                  dryinglogday1["materiallist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 595,
                left: 92,
                child: pw.Text(
                  dryinglogday1["materiallist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 581,
                left: 92,
                child: pw.Text(
                  dryinglogday1["materiallist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 637,
                left: 176,
                child: pw.Text(
                  dryinglogday1["surfacemeterlist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 623,
                left: 176,
                child: pw.Text(
                  dryinglogday1["surfacemeterlist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 609,
                left: 176,
                child: pw.Text(
                  dryinglogday1["surfacemeterlist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 595,
                left: 176,
                child: pw.Text(
                  dryinglogday1["surfacemeterlist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 581,
                left: 176,
                child: pw.Text(
                  dryinglogday1["surfacemeterlist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 637,
                left: 246,
                child: pw.Text(
                  dryinglogday1["penetratemeterlist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 623,
                left: 246,
                child: pw.Text(
                  dryinglogday1["penetratemeterlist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 609,
                left: 246,
                child: pw.Text(
                  dryinglogday1["penetratemeterlist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 595,
                left: 246,
                child: pw.Text(
                  dryinglogday1["penetratemeterlist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 581,
                left: 246,
                child: pw.Text(
                  dryinglogday1["penetratemeterlist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 600,
                left: 340,
                child: pw.Text(
                  dryinglogday1["fan"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 600,
                left: 384,
                child: pw.Text(
                  dryinglogday1["dehumidifiers"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 600,
                left: 438,
                child: pw.Text(
                  dryinglogday1["airscrubbers"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 10,
                child: pw.Text(
                  dryinglogday1["out_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 31,
                child: pw.Text(
                  dryinglogday1["out_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 54,
                child: pw.Text(
                  dryinglogday1["out_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 75,
                child: pw.Text(
                  dryinglogday1["in_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 97,
                child: pw.Text(
                  dryinglogday1["in_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 119,
                child: pw.Text(
                  dryinglogday1["int_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 140,
                child: pw.Text(
                  dryinglogday1["area_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 163,
                child: pw.Text(
                  dryinglogday1["area_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 184,
                child: pw.Text(
                  dryinglogday1["area_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 207,
                child: pw.Text(
                  dryinglogday1["de1_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 229,
                child: pw.Text(
                  dryinglogday1["de1_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 252,
                child: pw.Text(
                  dryinglogday1["de1_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 274,
                child: pw.Text(
                  dryinglogday1["de1_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 298,
                child: pw.Text(
                  dryinglogday1["de2_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 318,
                child: pw.Text(
                  dryinglogday1["de2_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 342,
                child: pw.Text(
                  dryinglogday1["de2_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 364,
                child: pw.Text(
                  dryinglogday1["de2_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 389,
                child: pw.Text(
                  dryinglogday1["other_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 406,
                child: pw.Text(
                  dryinglogday1["other_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 430,
                child: pw.Text(
                  dryinglogday1["other_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 530,
                left: 450,
                child: pw.Text(
                  dryinglogday1["other_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 490,
                left: 13,
                child: pw.Text(dryinglogday2["date"],
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Positioned(
                bottom: 460,
                left: 13,
                child: pw.Text(
                  dryinglogday2["time"],
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold),
                )),
            pw.Positioned(
                bottom: 489,
                left: 92,
                child: pw.Text(
                  dryinglogday2["materiallist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 475,
                left: 92,
                child: pw.Text(
                  dryinglogday2["materiallist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 461,
                left: 92,
                child: pw.Text(
                  dryinglogday2["materiallist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 447,
                left: 92,
                child: pw.Text(
                  dryinglogday2["materiallist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 433,
                left: 92,
                child: pw.Text(
                  dryinglogday2["materiallist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 489,
                left: 176,
                child: pw.Text(
                  dryinglogday2["surfacemeterlist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 475,
                left: 176,
                child: pw.Text(
                  dryinglogday2["surfacemeterlist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 461,
                left: 176,
                child: pw.Text(
                  dryinglogday2["surfacemeterlist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 447,
                left: 176,
                child: pw.Text(
                  dryinglogday2["surfacemeterlist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 433,
                left: 176,
                child: pw.Text(
                  dryinglogday2["surfacemeterlist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 489,
                left: 246,
                child: pw.Text(
                  dryinglogday2["penetratemeterlist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 475,
                left: 246,
                child: pw.Text(
                  dryinglogday2["penetratemeterlist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 461,
                left: 246,
                child: pw.Text(
                  dryinglogday2["penetratemeterlist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 447,
                left: 246,
                child: pw.Text(
                  dryinglogday2["penetratemeterlist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 433,
                left: 246,
                child: pw.Text(
                  dryinglogday2["penetratemeterlist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 452,
                left: 340,
                child: pw.Text(
                  dryinglogday2["fan"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 452,
                left: 384,
                child: pw.Text(
                  dryinglogday2["dehumidifiers"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 452,
                left: 438,
                child: pw.Text(
                  dryinglogday2["airscrubbers"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 6,
                child: pw.Text(
                  dryinglogday2["out_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 27,
                child: pw.Text(
                  dryinglogday2["out_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 50,
                child: pw.Text(
                  dryinglogday2["out_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 71,
                child: pw.Text(
                  dryinglogday2["in_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 93,
                child: pw.Text(
                  dryinglogday2["in_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 115,
                child: pw.Text(
                  dryinglogday2["int_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 136,
                child: pw.Text(
                  dryinglogday2["area_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 159,
                child: pw.Text(
                  dryinglogday2["area_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 180,
                child: pw.Text(
                  dryinglogday2["area_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 203,
                child: pw.Text(
                  dryinglogday2["de1_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 225,
                child: pw.Text(
                  dryinglogday2["de1_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 248,
                child: pw.Text(
                  dryinglogday2["de1_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 270,
                child: pw.Text(
                  dryinglogday2["de1_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 294,
                child: pw.Text(
                  dryinglogday2["de2_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 314,
                child: pw.Text(
                  dryinglogday2["de2_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 338,
                child: pw.Text(
                  dryinglogday2["de2_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 360,
                child: pw.Text(
                  dryinglogday2["de2_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 381,
                child: pw.Text(
                  dryinglogday2["other_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 402,
                child: pw.Text(
                  dryinglogday2["other_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 426,
                child: pw.Text(
                  dryinglogday2["other_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 385,
                left: 446,
                child: pw.Text(
                  dryinglogday2["other_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            ///////////////
            ////////////
            ///////////////////
            /////////////
            pw.Positioned(
                bottom: 338,
                left: 9,
                child: pw.Text(dryinglogday3["date"],
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Positioned(
                bottom: 310,
                left: 9,
                child: pw.Text(
                  dryinglogday3["time"],
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold),
                )),
            pw.Positioned(
                bottom: 337,
                left: 88,
                child: pw.Text(
                  dryinglogday3["materiallist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 323,
                left: 88,
                child: pw.Text(
                  dryinglogday3["materiallist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 309,
                left: 88,
                child: pw.Text(
                  dryinglogday3["materiallist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 295,
                left: 88,
                child: pw.Text(
                  dryinglogday3["materiallist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 281,
                left: 88,
                child: pw.Text(
                  dryinglogday3["materiallist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 337,
                left: 172,
                child: pw.Text(
                  dryinglogday3["surfacemeterlist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 323,
                left: 172,
                child: pw.Text(
                  dryinglogday3["surfacemeterlist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 309,
                left: 172,
                child: pw.Text(
                  dryinglogday3["surfacemeterlist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 295,
                left: 172,
                child: pw.Text(
                  dryinglogday3["surfacemeterlist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 281,
                left: 172,
                child: pw.Text(
                  dryinglogday3["surfacemeterlist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 337,
                left: 242,
                child: pw.Text(
                  dryinglogday3["penetratemeterlist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 323,
                left: 242,
                child: pw.Text(
                  dryinglogday3["penetratemeterlist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 309,
                left: 242,
                child: pw.Text(
                  dryinglogday3["penetratemeterlist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 295,
                left: 242,
                child: pw.Text(
                  dryinglogday3["penetratemeterlist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 281,
                left: 242,
                child: pw.Text(
                  dryinglogday3["penetratemeterlist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 300,
                left: 336,
                child: pw.Text(
                  dryinglogday3["fan"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 300,
                left: 380,
                child: pw.Text(
                  dryinglogday3["dehumidifiers"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 300,
                left: 434,
                child: pw.Text(
                  dryinglogday3["airscrubbers"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 6,
                child: pw.Text(
                  dryinglogday3["out_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 27,
                child: pw.Text(
                  dryinglogday3["out_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 50,
                child: pw.Text(
                  dryinglogday3["out_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 71,
                child: pw.Text(
                  dryinglogday3["in_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 93,
                child: pw.Text(
                  dryinglogday3["in_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 115,
                child: pw.Text(
                  dryinglogday3["int_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 136,
                child: pw.Text(
                  dryinglogday3["area_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 159,
                child: pw.Text(
                  dryinglogday3["area_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 180,
                child: pw.Text(
                  dryinglogday3["area_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 203,
                child: pw.Text(
                  dryinglogday3["de1_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 225,
                child: pw.Text(
                  dryinglogday3["de1_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 248,
                child: pw.Text(
                  dryinglogday3["de1_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 270,
                child: pw.Text(
                  dryinglogday3["de1_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 294,
                child: pw.Text(
                  dryinglogday3["de2_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 314,
                child: pw.Text(
                  dryinglogday3["de2_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 338,
                child: pw.Text(
                  dryinglogday3["de2_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 360,
                child: pw.Text(
                  dryinglogday3["de2_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 381,
                child: pw.Text(
                  dryinglogday3["other_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 402,
                child: pw.Text(
                  dryinglogday3["other_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 426,
                child: pw.Text(
                  dryinglogday3["other_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 233,
                left: 450,
                child: pw.Text(
                  dryinglogday3["other_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            ///////////////////
            /////////////////
            ////////////////
            pw.Positioned(
                bottom: 185,
                left: 9,
                child: pw.Text(dryinglogday4["date"],
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Positioned(
                bottom: 157,
                left: 9,
                child: pw.Text(
                  dryinglogday4["time"],
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold),
                )),
            pw.Positioned(
                bottom: 184,
                left: 86,
                child: pw.Text(
                  dryinglogday4["materiallist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 170,
                left: 86,
                child: pw.Text(
                  dryinglogday4["materiallist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 156,
                left: 86,
                child: pw.Text(
                  dryinglogday4["materiallist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 142,
                left: 86,
                child: pw.Text(
                  dryinglogday4["materiallist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 128,
                left: 86,
                child: pw.Text(
                  dryinglogday4["materiallist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 184,
                left: 168,
                child: pw.Text(
                  dryinglogday4["surfacemeterlist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 170,
                left: 168,
                child: pw.Text(
                  dryinglogday4["surfacemeterlist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 156,
                left: 168,
                child: pw.Text(
                  dryinglogday4["surfacemeterlist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 142,
                left: 168,
                child: pw.Text(
                  dryinglogday4["surfacemeterlist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 128,
                left: 168,
                child: pw.Text(
                  dryinglogday4["surfacemeterlist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 184,
                left: 242,
                child: pw.Text(
                  dryinglogday4["penetratemeterlist1"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 170,
                left: 242,
                child: pw.Text(
                  dryinglogday4["penetratemeterlist2"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 156,
                left: 242,
                child: pw.Text(
                  dryinglogday4["penetratemeterlist3"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 142,
                left: 242,
                child: pw.Text(
                  dryinglogday4["penetratemeterlist4"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 128,
                left: 242,
                child: pw.Text(
                  dryinglogday4["penetratemeterlist5"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 147,
                left: 336,
                child: pw.Text(
                  dryinglogday4["fan"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 147,
                left: 380,
                child: pw.Text(
                  dryinglogday4["dehumidifiers"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 147,
                left: 434,
                child: pw.Text(
                  dryinglogday4["airscrubbers"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 4,
                child: pw.Text(
                  dryinglogday4["out_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 23,
                child: pw.Text(
                  dryinglogday4["out_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 42,
                child: pw.Text(
                  dryinglogday4["out_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 67,
                child: pw.Text(
                  dryinglogday4["in_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 88,
                child: pw.Text(
                  dryinglogday4["in_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 110,
                child: pw.Text(
                  dryinglogday4["int_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 132,
                child: pw.Text(
                  dryinglogday4["area_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 157,
                child: pw.Text(
                  dryinglogday4["area_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 175,
                child: pw.Text(
                  dryinglogday4["area_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 198,
                child: pw.Text(
                  dryinglogday4["de1_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 220,
                child: pw.Text(
                  dryinglogday4["de1_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 243,
                child: pw.Text(
                  dryinglogday4["de1_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 264,
                child: pw.Text(
                  dryinglogday4["de1_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 289,
                child: pw.Text(
                  dryinglogday4["de2_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 309,
                child: pw.Text(
                  dryinglogday4["de2_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 333,
                child: pw.Text(
                  dryinglogday4["de2_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 354,
                child: pw.Text(
                  dryinglogday4["de2_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 375,
                child: pw.Text(
                  dryinglogday4["other_temp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 397,
                child: pw.Text(
                  dryinglogday4["other_rh"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 420,
                child: pw.Text(
                  dryinglogday4["other_gpp"],
                  style: pw.TextStyle(fontSize: 11),
                )),
            pw.Positioned(
                bottom: 81,
                left: 443,
                child: pw.Text(
                  dryinglogday4["other_gd"],
                  style: pw.TextStyle(fontSize: 11),
                )),
          ],
        ));
      },
    ));

    var file = await pdf.save();
    // final Uint8List file = await compute(serial, pdf);

    setState(() {
      loading = false;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfPrint(file: file)));
  }

  print_completion2(var num) async {
    final sign_response2 = await http.get(Uri.parse(contract_url));
    final pdf = pw.Document();

    if (sign_response2.statusCode == 200) {
      final sign2 = pw.MemoryImage(sign_response2.bodyBytes);

      var imageBytes, imageBytes1, imageBytes2, imageBytes3, imageBytes4;

      if (num == 1) {
        imageBytes = await loadPngImageFromAssets('lib/assets/file/water1.png');
        imageBytes1 =
            await loadPngImageFromAssets('lib/assets/file/water2.png');
        imageBytes2 =
            await loadPngImageFromAssets('lib/assets/file/water3.png');
        imageBytes3 =
            await loadPngImageFromAssets('lib/assets/file/water4.png');
        imageBytes4 =
            await loadPngImageFromAssets('lib/assets/file/water5.png');
      } else {
        imageBytes =
            await loadPngImageFromAssets('lib/assets/file/recons1.png');
        imageBytes1 =
            await loadPngImageFromAssets('lib/assets/file/recons2.png');
        imageBytes2 =
            await loadPngImageFromAssets('lib/assets/file/recons3.png');
        imageBytes3 =
            await loadPngImageFromAssets('lib/assets/file/recons4.png');
        imageBytes4 =
            await loadPngImageFromAssets('lib/assets/file/recons5.png');
      }
      if (num == 1) {
        pdf.addPage(pw.Page(
          build: (pw.Context context) {
            return pw.Center(
                child: pw.Stack(
              children: [
                pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.cover),
                pw.Positioned(
                    bottom: 312,
                    left: 160,
                    child: pw.Text(name,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              ],
            ));
          },
        ));
      } else {
        pdf.addPage(pw.Page(
          build: (pw.Context context) {
            return pw.Center(
                child: pw.Stack(
              children: [
                pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.cover),
                pw.Positioned(
                    bottom: 340,
                    left: 100,
                    child: pw.Text(name,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              ],
            ));
          },
        ));
      }
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Stack(
            children: [
              pw.Image(pw.MemoryImage(imageBytes1), fit: pw.BoxFit.cover),
              pw.Positioned(
                  bottom: 312,
                  right: 200,
                  child: pw.Text(name,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            ],
          ));
        },
      ));

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Stack(
            children: [
              pw.Image(pw.MemoryImage(imageBytes2), fit: pw.BoxFit.cover),
            ],
          ));
        },
      ));

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Stack(
            children: [
              pw.Image(pw.MemoryImage(imageBytes3), fit: pw.BoxFit.cover),
            ],
          ));
        },
      ));
      if (num == 1) {
        pdf.addPage(pw.Page(
          build: (pw.Context context) {
            return pw.Center(
                child: pw.Stack(
              children: [
                pw.Image(pw.MemoryImage(imageBytes4), fit: pw.BoxFit.cover),
                pw.Positioned(
                    bottom: 480,
                    right: 170,
                    child: pw.Image(sign2, height: 70)),
                pw.Positioned(
                    bottom: 450,
                    right: 180,
                    child: pw.Text(name + ",   " + phonenumber,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Positioned(
                    bottom: 380,
                    right: 200,
                    child: pw.Text(date,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Positioned(
                    bottom: 312,
                    right: 200,
                    child: pw.Text(policy,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Positioned(
                  bottom: 40,
                  left: 250,
                  child: pw.Text("Developed by: Sartec Software Company",
                      style: pw.TextStyle(fontSize: 11)),
                ),
                pw.Positioned(
                  bottom: 30,
                  left: 305,
                  child: pw.Text("web: sartecsoftware.co.uk",
                      style: pw.TextStyle(fontSize: 11)),
                ),
              ],
            ));
          },
        ));
      } else {
        pdf.addPage(pw.Page(
          build: (pw.Context context) {
            return pw.Center(
                child: pw.Stack(
              children: [
                pw.Image(pw.MemoryImage(imageBytes4), fit: pw.BoxFit.cover),
                pw.Positioned(
                    bottom: 415,
                    right: 170,
                    child: pw.Image(sign2, height: 70)),
                pw.Positioned(
                    bottom: 380,
                    right: 200,
                    child: pw.Text(name,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Positioned(
                    bottom: 320,
                    right: 200,
                    child: pw.Text(date,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Positioned(
                  bottom: 40,
                  left: 250,
                  child: pw.Text("Developed by: Sartec Software Company",
                      style: pw.TextStyle(fontSize: 11)),
                ),
                pw.Positioned(
                  bottom: 30,
                  left: 305,
                  child: pw.Text("web: sartecsoftware.co.uk",
                      style: pw.TextStyle(fontSize: 11)),
                ),
              ],
            ));
          },
        ));
      }
    }
    print("oooooooooooooo");
    var file = await pdf.save();
    // final Uint8List file = await compute(serial, pdf);

    setState(() {
      loading = false;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfPrint(file: file)));
  }

  print_completion(String pdfAssetPath) async {
    final pdfBytes = await rootBundle.load(pdfAssetPath);

    Uint8List file = await pdfBytes.buffer.asUint8List();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfPrint(file: file)));

    /* await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return pdfBytes.buffer.asUint8List();
      },
    ); */
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    // Add your initialization logic here
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
          "Add Details",
          style: AppTextStyle.appNameTextStyle,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.linearGradientPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: touch_sign ? NeverScrollableScrollPhysics() : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.height * 0.01, horizontal: size.height * 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: Text(
                        "Enter Details",
                        style: AppTextStyle.PageHeading,
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
                          "Email: " + email,
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
                          "Phone #: " + phonenumber,
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
                          "Operator Name: " + operatorname,
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
                          "Contract Date: " + date,
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
                          "Contract time: " + time,
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
                          "Job type: " + job,
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
                          "Loss Date: " + lossdate,
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
                          "Loss Time: " + losstime,
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
                          "Policy #/ Claim #: " + policy,
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
                          "Refer by: " + referby,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.015),
                      child: GestureDetector(
                        onTap: () {
                          if (drying_log_days > 4) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Drying Log form is completed for 4 Days"),
                            ));
                          } else {
                            _showDataEntryDialog(context);
                          }
                        },
                        child: Container(
                          width: size.width * 0.99,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor1,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            "Enter Drying Log",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.015),
                      child: TextFormSecond(
                        controller: equipmentController,
                        hint: "Enter Equipemnts",
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.015),
                      child: TextFormSecond(
                        controller: technicianController,
                        hint: "Type Technician Note Here",
                        maxLines: 9,
                      ),
                    ),
                    loading == true
                        ? Center()
                        : Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.04,
                              bottom: size.height * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButtonCon(
                                  text: "Print Job Document",
                                  onPressed: () async {
                                    if (job == "Water Job") {
                                      setState(() {
                                        loading = true;
                                        test = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Loading.... It will take 4 - 10 seconds"),
                                      ));
                                      print_completion2(1);
                                    } else if (job == "Reconstruction Job") {
                                      setState(() {
                                        loading = true;
                                        test = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Loading.... It will take 4 - 10 seconds"),
                                      ));
                                      print_completion2(2);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Contarct for this type of Job is not avaibale"),
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
                    loading == true
                        ? Center()
                        : Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                              bottom: size.height * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButtonCon(
                                  text: "Add Images",
                                  onPressed: () async {
                                    try {
                                      print("called");
                                      XFile? temp_file = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera,
                                              imageQuality: 15);
                                      print(temp_file?.path);
                                      img_list.add(temp_file?.path);

                                      // imageFiles?.add(temp_file!);
                                      //print(imageFiles);

                                      /*    imageFiles = await ImagePicker()
                                        .pickMultiImage(imageQuality: 15); */
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                    setState(() {});
                                  },
                                  bgColor: AppColors.primaryColor1,
                                  textColor: AppColors.primaryWhiteColor,
                                  width: size.width * 0.6,
                                  height: size.height * 0.06,
                                ),
                              ],
                            ),
                          ),
                    loading == true
                        ? Center()
                        : Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                              bottom: size.height * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButtonCon(
                                  text: "Show added images",
                                  onPressed: () async {
                                    if (downloadURLs.length > 0) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => ImageViewer1(
                                                  url: downloadURLs)));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("No image is uploaded before"),
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
                    loading == true
                        ? Center()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButtonCon(
                                  text: "Show Location",
                                  onPressed: () async {
                                    if (latitude != null && longitude != null) {
                                      try {
                                        Map<String, double> data1 = {
                                          "cus_lat": (lat),
                                          "cus_long": (long),
                                          "lat": (latitude),
                                          "long": (longitude)
                                        };
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    MapWithRoutePage(
                                                        data: data1)));
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Wait..getting your current location"),
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
                    loading == true
                        ? Center()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButtonCon(
                                  text: "Show Drying Log",
                                  onPressed: () async {
                                    if (drying_log_days == 1) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Empty Dry Log"),
                                      ));
                                      return;
                                    }
                                    setState(() {
                                      loading = true;
                                      test = false;
                                      print("logggg 111");
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Loading.... It will take 2-6 seconds"),
                                    ));
                                    await Future.delayed(Duration(seconds: 1));
                                    print("log printting");
                                    dryinglog_print();
                                  },
                                  bgColor: AppColors.primaryColor1,
                                  textColor: AppColors.primaryWhiteColor,
                                  width: size.width * 0.6,
                                  height: size.height * 0.06,
                                ),
                              ],
                            ),
                          ),
                    loading == true
                        ? test == true
                            ? LoadingIndicator()
                            : Center()
                        : Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                              bottom: size.height * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButtonCon(
                                  text: "Save Data",
                                  onPressed: () async {
                                    {
                                      setState(() {
                                        loading = true;
                                        test = true;
                                      });

                                      if (true) {
                                        await uploaddata(false);
                                        if (datasaved) {
                                          check2 = true;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Data Saved"),
                                          ));
                                          Navigator.pop(context);
                                          /* Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      PdfPrint(file: test))); */
                                        } else {
                                          return;
                                        }
                                      }
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
                    loading == true
                        ? Text('')
                        : Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                              bottom: size.height * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButtonCon(
                                  text: "Completed",
                                  onPressed: () async {
                                    {
                                      setState(() {
                                        loading = true;
                                      });

                                      if (true) {
                                        await uploaddata(true);
                                        if (datasaved) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Data Saved"),
                                          ));
                                          Navigator.pop(context);
                                        } else {
                                          return;
                                        }
                                      }
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
            ],
          ),
        ),
      ),
    );
  }

  //drying log pop up
  Future<void> _showDataEntryDialog(BuildContext context) async {
    bool check = false;
    if (drying_log_days == 1) {
      check = true;
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Drying Log Day: ' + drying_log_days.toString()),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                (check)
                    ? _buildTextField_numeric(
                        "Water Classification (1-4)", waterclassController)
                    : Container(),
                (check)
                    ? _buildTextField_numeric(
                        "Water Category (1-3)", watercategoryController)
                    : Container(),
                (check) ? _buildTextField("Room", roomController) : Container(),
                (check)
                    ? _buildTextField("Floor", floorController)
                    : Container(),
                _buildTextField("Date", dateControllerlog),
                _buildTextField("Time", timeControllerlog),
                _buildStaticList("Material List", materialListControllers),
                _buildStaticList(
                    "Surface Meter List", surfaceMeterListControllers),
                _buildStaticList(
                    "Penetrate Meter List", penetrateMeterListControllers),
                _buildTextField_numeric(
                    "Number of Fans", numberOfFansController),
                _buildTextField_numeric(
                    "Number of Dehumidifiers", numberOfDehumidifiersController),
                _buildTextField_numeric(
                    "Number of Air Scrubbers", numberOfAirScrubbersController),
                _buildTemperatureHumidityGPPFields(
                    "Outside",
                    outsideTempController,
                    outsideRHController,
                    outsideGPPController),
                _buildTemperatureHumidityGPPFields(
                    "Inside",
                    insideTempController,
                    insideRHController,
                    insideGPPController),
                _buildTemperatureHumidityGPPFields(
                    "Unaffected Area",
                    unaffectedTempController,
                    unaffectedRHController,
                    unaffectedGPPController),
                _buildTemperatureHumidityGPPGDFields(
                    "Dehumidifier 1",
                    dehumidifier1TempController,
                    dehumidifier1RHController,
                    dehumidifier1GPPController,
                    dehumidifier1GDController),
                _buildTemperatureHumidityGPPGDFields(
                    "Dehumidifier 2",
                    dehumidifier2TempController,
                    dehumidifier2RHController,
                    dehumidifier2GPPController,
                    dehumidifier2GDController),
                _buildTemperatureHumidityGPPGDFields(
                    "Other A/c",
                    otherACTempController,
                    otherACRHController,
                    otherACGPPController,
                    otherACGDController),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                // Data is valid, save it
                _saveData();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        TextField(
          controller: controller,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildTextField_numeric(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildStaticList(
      String label, List<TextEditingController> controllers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        for (int i = 0; i < controllers.length; i++)
          Row(
            children: [
              Text("${i + 1}."),
              Expanded(
                child: TextField(
                  controller: controllers[i],
                ),
              ),
            ],
          ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildTemperatureHumidityGPPFields(
      String label,
      TextEditingController tempController,
      TextEditingController rhController,
      TextEditingController gppController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: tempController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Temp'),
              ),
            ),
            Expanded(
              child: TextField(
                controller: rhController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'RH'),
              ),
            ),
            Expanded(
              child: TextField(
                controller: gppController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'GPP'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildTemperatureHumidityGPPGDFields(
      String label,
      TextEditingController tempController,
      TextEditingController rhController,
      TextEditingController gppController,
      TextEditingController gdController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: tempController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Temp'),
              ),
            ),
            Expanded(
              child: TextField(
                controller: rhController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'RH'),
              ),
            ),
            Expanded(
              child: TextField(
                controller: gppController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'GPP'),
              ),
            ),
            Expanded(
              child: TextField(
                controller: gdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'GD'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  void _saveData() {
    room = roomController.text;
    floor = floorController.text;
    waterclass = waterclassController.text;
    watercategory = watercategoryController.text;
    drying_log_map = {
      "date": dateControllerlog.text,
      "time": timeControllerlog.text,
      "materiallist1": materialListControllers[0].text,
      "materiallist2": materialListControllers[1].text,
      "materiallist3": materialListControllers[2].text,
      "materiallist4": materialListControllers[3].text,
      "materiallist5": materialListControllers[4].text,
      "surfacemeterlist1": surfaceMeterListControllers[0].text,
      "surfacemeterlist2": surfaceMeterListControllers[1].text,
      "surfacemeterlist3": surfaceMeterListControllers[2].text,
      "surfacemeterlist4": surfaceMeterListControllers[3].text,
      "surfacemeterlist5": surfaceMeterListControllers[4].text,
      "penetratemeterlist1": penetrateMeterListControllers[0].text,
      "penetratemeterlist2": penetrateMeterListControllers[1].text,
      "penetratemeterlist3": penetrateMeterListControllers[2].text,
      "penetratemeterlist4": penetrateMeterListControllers[3].text,
      "penetratemeterlist5": penetrateMeterListControllers[4].text,
      "fan": numberOfFansController.text,
      "dehumidifiers": numberOfDehumidifiersController.text,
      "airscrubbers": numberOfAirScrubbersController.text,
      "out_temp": outsideTempController.text,
      "out_rh": outsideRHController.text,
      "out_gpp": outsideGPPController.text,
      "in_temp": insideTempController.text,
      "in_rh": insideRHController.text,
      "int_gpp": insideGPPController.text,
      "area_temp": unaffectedTempController.text,
      "area_rh": unaffectedRHController.text,
      "area_gpp": unaffectedGPPController.text,
      "de1_temp": dehumidifier1TempController.text,
      "de1_rh": dehumidifier1RHController.text,
      "de1_gpp": dehumidifier1GPPController.text,
      "de1_gd": dehumidifier1GDController.text,
      "de2_temp": dehumidifier2TempController.text,
      "de2_rh": dehumidifier2RHController.text,
      "de2_gpp": dehumidifier2GPPController.text,
      "de2_gd": dehumidifier2GDController.text,
      "other_temp": otherACTempController.text,
      "other_rh": otherACRHController.text,
      "other_gpp": otherACGPPController.text,
      "other_gd": otherACGDController.text,
    };
    print(drying_log_map["date"]);
  }
}

class ImageViewer1 extends StatelessWidget {
  ImageViewer1({Key? key, required this.url}) : super(key: key);
  List url;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: url.length,
          itemBuilder: (context, index) {
            //final imageUrl = images_url[index];
            return CachedNetworkImage(
              imageUrl: url[index],
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            );
          },
        ),
      ]),
    );
  }
}
