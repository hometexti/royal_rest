import 'dart:io';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import '../../Operator/addlocation.dart';
import '../../Operator/textformsecond.dart';
import '../../widgets/loading_indicator.dart';
import 'package:hand_signature/signature.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../utils/textstyle.dart';
import '../../widgets/custom_button2.dart';
import 'package:intl/intl.dart';

class Newform extends StatefulWidget {
  const Newform({Key? key}) : super(key: key);

  @override
  State<Newform> createState() => _NewformState();
}

class _NewformState extends State<Newform> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController lossdateController = TextEditingController();
  final TextEditingController losstimeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController contractController = TextEditingController();
  final TextEditingController policyController = TextEditingController();
  final TextEditingController referController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

  String selectedOption = 'Water Job';

  var text_button = "Start Signature";
  String signurl = '';
  bool touch_sign = false;
  bool show_sign_area = false;
  void touch() {
    if (touch_sign == false) {
      setState(() {
        touch_sign = true;
        text_button = "Stop Signature";

        print("dont touch meeeeeeeeeeeeeeeee");
      });
    } else if (touch_sign == true) {
      setState(() {
        text_button = "Start Signature";

        touch_sign = false;
      });
    }
  }

  HandSignatureControl control = new HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  var lat, long;
  bool loading = false;
  var operator_name;
  var latitude = 0.0, longitude = 0.0;
  var pdf_file_to_upload;
  String getTimeAsString(TimeOfDay? time) {
    return '${time?.hour}:${time?.minute.toString().padLeft(2, '0')}';
  }

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

  uploaddata() async {
    if (jobController.text == "") {
      jobController.text = 'Water Job';
    }
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
    Map<String, dynamic> data = {
      "date": dateController.text,
      "time": timeController.text,
      "customer_name": nameController.text,
      "email": emailController.text,
      "phonenumber": phoneController.text,
      "operator_name": operator_name,
      "policy": policyController.text,
      "loss_date": lossdateController.text,
      "loss_time": losstimeController.text,
      "refer_by": referController.text,
      "job": jobController.text,
      "long": long,
      "lat": lat,
      "img_url": [],
      "drying_log": "",
      "equipment": "",
      "tech_note": "",
      "status": "pending",
      "pdf_url": [],
      "sign_url": signurl,
      "dryinglogdays": 1,
      "dryinglogday1": drying_log_map,
      "dryinglogday2": drying_log_map,
      "dryinglogday3": drying_log_map,
      "dryinglogday4": drying_log_map,
      "dryinglogday5": drying_log_map,
      "watercategory": "",
      "room": "",
      "floor": "",
      "waterclass": "",
      "doc_id": (phoneController.text.toString() +
              dateController.text.toString() +
              timeController.text.toString())
          .toString(),
    };
    try {
      await FirebaseFirestore.instance
          .collection("form")
          .doc(phoneController.text.toString() +
              dateController.text.toString() +
              timeController.text.toString())
          .set(data)
          .then((value) {
        dateController.text = "";
        lossdateController.text = '';
        losstimeController.text = "";
        referController.text = "";
        policyController.text = "";
        control.clear();
        timeController.text = "";
        nameController.text = "";
        emailController.text = "";
        phoneController.text = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Data Saved"),
      ));
    } catch (e) {}
    loading = false;
    setState(() {});
  }

  getoperatordata() async {
    var id;
    id = await FirebaseAuth.instance.currentUser?.uid;

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .get()
          .then((value) {
        operator_name = value['userName'];
      });
    } catch (e) {
      print("file1" + e.toString());
    }
  }

  Future<bool> signupload() async {
    try {
      ui.Image image =
          await decodeImageFromList(rawImageFit.value!.buffer.asUint8List());

      // Convert the image to PNG format
      ByteData? pngByteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      await pngByteData?.buffer.asUint8List();
      final appDir = await getTemporaryDirectory();
      final fileName = nameController.text +
          dateController.text +
          timeController.text +
          "Sign";
      final tempFilePath = '${appDir.path}/$fileName';

      await File(tempFilePath).writeAsBytes(pngByteData!.buffer.asUint8List());

      // Upload the temporary file to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(File(tempFilePath));

      // Get the download URL of the uploaded image
      signurl = await storageRef.getDownloadURL();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getLocation();
    getoperatordata();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.primaryColor1,
        centerTitle: true,
        title: Text(
          "Create new Contract",
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
                            EdgeInsets.symmetric(vertical: size.height * 0.02),
                        child: TextFormSecond(
                          controller: nameController,
                          hint: AppStrings.name,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: TextFormSecond(
                          type: TextInputType.phone,
                          controller: phoneController,
                          hint: "Enter phone number",
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: TextFormSecond(
                          controller: policyController,
                          hint: "Policy #/ Claim #",
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: TextFormSecond(
                          controller: emailController,
                          hint: "Enter email address",
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: TextFormSecond(
                          controller: lossdateController,
                          hint: "Loss Date",
                          icon: Icon(
                            Icons.calendar_today,
                            color: AppColors.primaryColor1,
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                //get today's date
                                firstDate: DateTime(2000),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              String formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(
                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                              setState(() {
                                lossdateController.text =
                                    formattedDate; //set foratted date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                          readOnly: true,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: TextFormSecond(
                          controller: losstimeController,
                          hint: "Loss Time",
                          icon: Icon(
                            Icons.calendar_today,
                            color: AppColors.primaryColor1,
                          ),
                          onTap: () async {
                            await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                String time_temp = getTimeAsString(value);

                                losstimeController.text = time_temp;
                              }

                              setState(() {});
                            });
                          },
                          readOnly: true,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: TextFormSecond(
                          controller: dateController,
                          hint: "Meeting Date",
                          icon: Icon(
                            Icons.calendar_today,
                            color: AppColors.primaryColor1,
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                //get today's date
                                firstDate: DateTime(2000),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              String formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(
                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                              setState(() {
                                dateController.text =
                                    formattedDate; //set foratted date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                          readOnly: true,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: TextFormSecond(
                          controller: timeController,
                          hint: "Meeting Time",
                          icon: Icon(
                            Icons.calendar_today,
                            color: AppColors.primaryColor1,
                          ),
                          onTap: () async {
                            await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                String time_temp = getTimeAsString(value);

                                timeController.text = time_temp;
                              }

                              setState(() {});
                            });
                          },
                          readOnly: true,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.015),
                        child: TextFormSecond(
                          controller: referController,
                          hint: "Refer by",
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.015),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              filled: true,
                              fillColor: AppColors.primaryColor1,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            child: DropdownButton<String>(
                              value: selectedOption,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedOption = newValue!;
                                  jobController.text = selectedOption;
                                });
                              },
                              items: <String>[
                                'Water Job',
                                'Reconstruction Job',
                                'Carpet Cleaning',
                                'Rug Cleaning'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          bottom: size.height * 0.04,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButtonCon(
                              text: text_button,
                              onPressed: () {
                                setState(() {
                                  touch();
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
                      Center(
                        child: Container(
                          height: size.height * 0.3,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints.expand(),
                                color: Color.fromARGB(255, 223, 165, 103),
                                child: HandSignature(
                                  control: control,
                                  type: SignatureDrawType.shape,
                                ),
                              ),
                              CustomPaint(
                                painter: DebugSignaturePainterCP(
                                  control: control,
                                  cp: false,
                                  cpStart: false,
                                  cpEnd: false,
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0), // Set the desired border radius
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 172, 91, 5))),
                                onPressed: () {
                                  control.clear();
                                  rawImageFit.value = null;
                                },
                                child: Text('clear'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          //top: size.height * 0.04,
                          bottom: size.height * 0.02,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          bottom: size.height * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButtonCon(
                              text: "Add location",
                              onPressed: () {
                                if (latitude != 0.0 || longitude != 0.0) {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (_) => AddressSearchPage(
                                              latitude: latitude,
                                              longitude: longitude)))
                                      .then((value) {
                                    if (value != null) {
                                      lat = value['lat'];
                                      long = value['long'];
                                    }
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Getting your current location, Try again"),
                                  ));
                                }
                              },
                              bgColor: AppColors.primaryColor1,
                              textColor: AppColors.primaryWhiteColor,
                              width: size.width * 0.8,
                              height: size.height * 0.06,
                            ),
                          ],
                        ),
                      ),
                      loading == true
                          ? LoadingIndicator()
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
                                      if (lat != null && long != null) {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          rawImageFit.value =
                                              await control.toImage(
                                            color: Colors.black,
                                            background: const Color.fromARGB(
                                                255, 251, 253, 252),
                                            fit: true,
                                            width: 200,
                                            height: 150,
                                          );

                                          if (rawImageFit.value != null) {
                                            bool check = await signupload();
                                            if (check == false) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Error in saving your signature, Try again"),
                                              ));
                                              loading = false;
                                              setState(() {});
                                              return;
                                            }
                                            await uploaddata();
                                            loading = false;
                                            setState(() {});
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Please do signature before submitting data"),
                                            ));
                                            setState(() {
                                              loading = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            loading = false;
                                          });
                                          return;
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Please add customer location"),
                                        ));
                                      }
                                    },
                                    bgColor: AppColors.primaryColor1,
                                    textColor: AppColors.primaryWhiteColor,
                                    width: size.width * 0.8,
                                    height: size.height * 0.06,
                                  ),
                                ],
                              ),
                            )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
