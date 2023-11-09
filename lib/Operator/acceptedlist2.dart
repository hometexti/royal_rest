import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../Admin/filedeleterequest.dart';
import '../../Operator/pdf.dart';
import '../../Operator/route.dart';
import '../utils/colors.dart';
import '../utils/textstyle.dart';
import '../widgets/custom_button2.dart';
import '../widgets/loading_indicator.dart';

class AcceptedList_2 extends StatefulWidget {
  final String doc_id;
  const AcceptedList_2({super.key, required this.doc_id});

  @override
  State<AcceptedList_2> createState() => _AcceptedList_2State();
}

class _AcceptedList_2State extends State<AcceptedList_2> {
  var name,
      operator_name,
      email,
      phonenumber,
      date,
      time,
      lossdate,
      losstime,
      contract_url,
      lat,
      long,
      latitude,
      longitude,
      referby,
      job,
      dryinglog,
      equipment,
      policy,
      note,
      drying_log_days;
  var room_get, floor_get, waterclass_get, watercat_get;
  Map<String, dynamic> dryinglogday1 = {},
      dryinglogday2 = {},
      dryinglogday3 = {},
      dryinglogday4 = {},
      dryinglogday5 = {};
  List images_url = [];
  bool test = false;
  bool loading = false;
  bool loading1 = false;
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
      Navigator.pop(context);
    }
  }

  FileDeleteRequest() async {
    try {
      var updatedData = {"status": "delete"};
      await FirebaseFirestore.instance
          .collection("form")
          .doc(widget.doc_id)
          .update(updatedData)
          .then((value) {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  FilereopenRequest() async {
    try {
      var updatedData = {"status": "pending"};
      await FirebaseFirestore.instance
          .collection("form")
          .doc(widget.doc_id)
          .update(updatedData)
          .then((value) {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Future<Uint8List> fetchAndResizeImage(
      String imageUrl, double maxWidth, double maxHeight) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      img.Image? image1 = img.decodeImage(response.bodyBytes);

      var width = image1!.width;
      var height = image1!.height;
      print("img  " + width.toString() + " " + height.toString());
      img.Image image = img.decodeImage(response.bodyBytes)!;

      if (height > 600 && width > 450) {
        image = img.copyResize(image,
            width: maxWidth.toInt(),
            height: maxHeight.toInt(),
            interpolation: img.Interpolation.linear);
      } else if (height > 600) {
        image = img.copyResize(image,
            width: width,
            height: maxHeight.toInt(),
            interpolation: img.Interpolation.linear);
      } else if (width > 450) {
        image = img.copyResize(image,
            width: maxWidth.toInt(),
            height: height,
            interpolation: img.Interpolation.linear);
      }

      return Uint8List.fromList(img.encodePng(image));
    } else {
      throw Exception('Failed to load image from URL');
    }
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

  print_completion() async {
    final sign_response2 = await http.get(Uri.parse(contract_url));
    final pdf = pw.Document();

    if (sign_response2.statusCode == 200) {
      final sign2 = pw.MemoryImage(sign_response2.bodyBytes);
      final imageBytes =
          await loadPngImageFromAssets('lib/assets/file/complete.png');
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Stack(
            children: [
              pw.Image(pw.MemoryImage(imageBytes), height: 800),
              pw.Positioned(
                  bottom: 306,
                  right: 200,
                  child: pw.Text(policy,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Positioned(
                  bottom: 280,
                  right: 200,
                  child: pw.Text(name,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Positioned(
                  bottom: 95, right: 170, child: pw.Image(sign2, height: 70)),
              pw.Positioned(
                  bottom: 70,
                  right: 200,
                  child: pw.Text(date,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Positioned(
                bottom: 10,
                left: 250,
                child: pw.Text("Developed by: Sartec Software Company",
                    style: pw.TextStyle(fontSize: 11)),
              ),
              pw.Positioned(
                bottom: 0,
                left: 305,
                child: pw.Text("web: sartecsoftware.co.uk",
                    style: pw.TextStyle(fontSize: 11)),
              ),
            ],
          ));
        },
      ));
    }

    var file = await pdf.save();
    loading1 = false;
    setState(() {});
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfPrint(file: file)));
  }

  Future<Uint8List> loadPngImageFromAssets(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  printall(var num) async {
    final pdf = pw.Document();
    final sign_response2 = await http.get(Uri.parse(contract_url));

//assets file
    /*   String link1 =
        "https://firebasestorage.googleapis.com/v0/b/restoration-c3993.appspot.com/o/complete.pdf?alt=media&token=fbaf10de-3c0c-43f5-8815-04850a92bc9b";
 */
//job completion page
    if (sign_response2.statusCode == 200) {
      final sign2 = pw.MemoryImage(sign_response2.bodyBytes);
      final imageBytes =
          await loadPngImageFromAssets('lib/assets/file/complete.png');
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Stack(
            children: [
              pw.Image(pw.MemoryImage(imageBytes), height: 800),
              pw.Positioned(
                  bottom: 306,
                  right: 200,
                  child: pw.Text(policy,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Positioned(
                  bottom: 280,
                  right: 200,
                  child: pw.Text(name,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Positioned(
                  bottom: 95, right: 170, child: pw.Image(sign2, height: 70)),
              pw.Positioned(
                  bottom: 70,
                  right: 200,
                  child: pw.Text(date,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Positioned(
                bottom: 10,
                left: 250,
                child: pw.Text("Developed by: Sartec Software Company",
                    style: pw.TextStyle(fontSize: 11)),
              ),
              pw.Positioned(
                bottom: 0,
                left: 305,
                child: pw.Text("web: sartecsoftware.co.uk",
                    style: pw.TextStyle(fontSize: 11)),
              ),
            ],
          ));
        },
      ));
    }
//contracts pages
    if (num != 0) {
      if (sign_response2.statusCode == 200) {
        final sign2 = pw.MemoryImage(sign_response2.bodyBytes);

        var imageBytes, imageBytes1, imageBytes2, imageBytes3, imageBytes4;

        if (num == 1) {
          imageBytes =
              await loadPngImageFromAssets('lib/assets/file/water1.png');
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
    }

//
    for (var link in images_url) {
      Uint8List resizedImage = await fetchAndResizeImage(link, 450, 600);
      // = await fetchAndResizeImage(link, 500, 800);
      //final response = await http.get(Uri.parse(link));

      final image = pw.MemoryImage(resizedImage);
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(children: [
              pw.FittedBox(
                child: pw.Text("Royal Restoration Contract",
                    style: pw.TextStyle(fontSize: 60)),
              ),
              //pw.SizedBox(height: 10),
              pw.Text(
                  "===================================================================="),
              pw.Text("Customer name :" + name,
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text("Policy # :" + policy, style: pw.TextStyle(fontSize: 16)),
              pw.Image(
                image,
              ),
              pw.Align(
                alignment: pw.Alignment.bottomCenter,
                child: pw.Text("Developed by: Sartec Software Company",
                    style: pw.TextStyle(fontSize: 11)),
              ),
              pw.Align(
                alignment: pw.Alignment.bottomCenter,
                child: pw.Text("web: sartecsoftware.co.uk",
                    style: pw.TextStyle(fontSize: 11)),
              ),
            ]);
          },
        ),
      );
    }
    var file = await pdf.save();
    loading1 = false;
    setState(() {});
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfPrint(file: file)));
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
          lossdate = data['loss_date'];
          losstime = data['loss_time'];
          name = data['customer_name'];
          email = data['email'];
          phonenumber = data['phonenumber'];
          operator_name = data['operator_name'];
          lat = data['lat'];
          long = data['long'];
          contract_url = data['sign_url'];
          images_url = data['img_url'];
          referby = data["refer_by"];
          job = data['job'];
          dryinglog = data["drying_log"];
          equipment = data["equipment"];
          policy = data["policy"];
          note = data["tech_note"];
          room_get = data["room"];
          floor_get = data["floor"];
          watercat_get = data["watercategory"];
          waterclass_get = data["waterclass"];
          drying_log_days = data["dryinglogdays"];
          dryinglogday1 = data["dryinglogday1"];
          dryinglogday2 = data["dryinglogday2"];
          dryinglogday3 = data["dryinglogday3"];
          dryinglogday4 = data["dryinglogday4"];
          dryinglogday5 = data["dryinglogday5"];
          loading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error in getting project"),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error in getting project"),
      ));
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
          "Project Details",
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
                            "Contract Date & time: " + date + " " + time,
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
                            "Loss Date & time: " + lossdate + " " + losstime,
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
                        child: Container(
                          width: size.width * 0.99,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor1,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            "Equipments: " + equipment,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      loading1 == true
                          ? test == true
                              ? LoadingIndicator()
                              : Center()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButtonCon(
                                    text: "Print All",
                                    onPressed: () async {
                                      if (job == "Water Job") {
                                        setState(() {
                                          loading1 = true;
                                          test = true;
                                        });
                                        await Future.delayed(
                                            Duration(milliseconds: 1000));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Loading.... It will take 10 - 20 seconds"),
                                        ));
                                        await printall(1);
                                        setState(() {
                                          loading1 = false;
                                          test = false;
                                        });
                                      } else if (job == "Reconstruction Job") {
                                        setState(() {
                                          loading1 = true;
                                          test = true;
                                        });
                                        await Future.delayed(
                                            Duration(milliseconds: 1000));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Loading.... It will take 10 - 20 seconds"),
                                        ));
                                        await printall(2);
                                        setState(() {
                                          loading1 = false;
                                          test = false;
                                        });
                                      } else {
                                        setState(() {
                                          loading1 = true;
                                          test = true;
                                        });
                                        await Future.delayed(
                                            Duration(milliseconds: 1000));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Loading.... It will take 10 - 20 seconds"),
                                        ));
                                        await printall(0);
                                        setState(() {
                                          loading1 = false;
                                          test = false;
                                        });
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
                      /*   loading1 == true
                          ? Center()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButtonCon(
                                    text: "Print Completion Document",
                                    onPressed: () async {
                                      {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Loading..."),
                                        ));
                                        loading1 = true;
                                        setState(() {});
                                        await print_completion();
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
                       */
                      /*  loading1 == true
                          ? Center()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButtonCon(
                                    text: "Print Job Document",
                                    onPressed: () async {
                                      if (job == "Water Job") {
                                        setState(() {
                                          loading1 = true;
                                          test = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Loading.... It will take 4 - 10 seconds"),
                                        ));
                                        print_completion2(1);
                                        setState(() {
                                          loading1 = false;
                                          test = true;
                                        });
                                      } else if (job == "Reconstruction Job") {
                                        setState(() {
                                          loading1 = true;
                                          test = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Loading.... It will take 4 - 10 seconds"),
                                        ));
                                        print_completion2(2);
                                        setState(() {
                                          loading1 = false;
                                          test = true;
                                        });
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
                      */
                      loading1 == true
                          ? Center()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButtonCon(
                                    text: "Print Drying Log",
                                    onPressed: () async {
                                      if (drying_log_days == 1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Empty Dry Log"),
                                        ));
                                        return;
                                      }
                                      setState(() {
                                        loading1 = true;
                                        test = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Loading.... It will take 2-6 seconds"),
                                      ));
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      dryinglog_print();
                                      setState(() {
                                        loading1 = false;
                                        test = true;
                                      });
                                    },
                                    bgColor: AppColors.primaryColor1,
                                    textColor: AppColors.primaryWhiteColor,
                                    width: size.width * 0.6,
                                    height: size.height * 0.06,
                                  ),
                                ],
                              ),
                            ),
                      loading1 == true
                          ? Center()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButtonCon(
                                    text: "Show image(s)",
                                    onPressed: () async {
                                      if (images_url.length > 0) {
                                        Map<String, dynamic> data1 = {
                                          "name": name,
                                          "phone": phonenumber,
                                          "email": email,
                                          "job": job,
                                          "date": date,
                                          "policy": policy
                                        };
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (_) => ImageViewer(
                                                url: images_url, data: data1),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("No, image found"),
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
                      loading1 == true
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
                                      if (lat != null &&
                                          long != null &&
                                          latitude != null &&
                                          longitude != null) {
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
                                          content: Text("Wait... Data Loading"),
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
                      loading1 == true
                          ? Center()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButtonCon(
                                    text: "Reopen",
                                    onPressed: () async {
                                      try {
                                        loading1 = true;
                                        setState(() {});
                                        await FilereopenRequest();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("File reopened"),
                                        ));
                                        Navigator.pop(context);
                                      } catch (e) {
                                        print(e.toString());
                                        Navigator.pop(context);
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
                      loading1 == true
                          ? Center()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButtonCon(
                                    text: "Delete",
                                    onPressed: () async {
                                      try {
                                        loading1 = true;
                                        setState(() {});
                                        await FileDeleteRequest();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Sent"),
                                        ));
                                        Navigator.pop(context);
                                      } catch (e) {
                                        print(e.toString());
                                        Navigator.pop(context);
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

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract'),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  ImageViewer({Key? key, required this.url, required this.data})
      : super(key: key);
  List url;
  Map<String, dynamic> data;
  Future<Uint8List> fetchAndResizeImage(
      String imageUrl, double maxWidth, double maxHeight) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      img.Image? image1 = img.decodeImage(response.bodyBytes);
      var width = image1!.width;
      var height = image1!.height;
      print("img  " + width.toString() + " " + height.toString());
      img.Image image = img.decodeImage(response.bodyBytes)!;

      if (height > 600 && width > 450) {
        image = img.copyResize(image,
            width: maxWidth.toInt(),
            height: maxHeight.toInt(),
            interpolation: img.Interpolation.linear);
      } else if (height > 600) {
        image = img.copyResize(image,
            width: width,
            height: maxHeight.toInt(),
            interpolation: img.Interpolation.linear);
      } else if (width > 450) {
        image = img.copyResize(image,
            width: maxWidth.toInt(),
            height: height,
            interpolation: img.Interpolation.linear);
      }

      return Uint8List.fromList(img.encodePng(image));
    } else {
      throw Exception('Failed to load image from URL');
    }
  }

  Future<Uint8List> generatePdfFromImageLinks(List<dynamic> imageLinks) async {
    final pdf = pw.Document();

    for (var link in imageLinks) {
      Uint8List resizedImage = await fetchAndResizeImage(link, 450, 600);
      // = await fetchAndResizeImage(link, 500, 800);
      //final response = await http.get(Uri.parse(link));

      final image = pw.MemoryImage(resizedImage);
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(children: [
              pw.FittedBox(
                child: pw.Text("Royal Restoration Contract",
                    style: pw.TextStyle(fontSize: 60)),
              ),
              //pw.SizedBox(height: 10),
              pw.Text(
                  "===================================================================="),
              pw.Text("Customer name :" + data["name"],
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text("Policy # :" + data["policy"],
                  style: pw.TextStyle(fontSize: 16)),
              pw.Image(
                image,
              ),
              pw.Align(
                alignment: pw.Alignment.bottomCenter,
                child: pw.Text("Developed by: Sartec Software Company",
                    style: pw.TextStyle(fontSize: 11)),
              ),
              pw.Align(
                alignment: pw.Alignment.bottomCenter,
                child: pw.Text("web: sartecsoftware.co.uk",
                    style: pw.TextStyle(fontSize: 11)),
              ),
            ]);
          },
        ),
      );
    }

    return pdf.save();
  }

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
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.02,
              bottom: size.height * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButtonCon(
                  text: "Share & Print",
                  onPressed: () async {
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please Wait, Loading..."),
                      ));
                      final pdf = await generatePdfFromImageLinks(url);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PdfPrint(file: pdf)));
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
        ),
      ]),
    );
  }
}
