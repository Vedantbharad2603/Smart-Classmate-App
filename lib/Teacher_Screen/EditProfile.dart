// ignore_for_file: unused_local_variable, avoid_unnecessary_containers

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:smartclassmate/tools/theme.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late int id;
  bool _isLoading = false;
  TextEditingController TeacherNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize GetStorage
    GetStorage storage = GetStorage();
    final mydata = storage.read('login_data');

    if (mydata != null) {
      id = mydata['data']['userdata']['id'];
      TeacherNameController.text =
          mydata['data']['userdata']['full_name'] ?? "";
      mobileNumberController.text =
          mydata['data']['userdata']['mobile_number'] ?? "";
      blockController.text = mydata['data']['userdata']['block_number'] ?? "";
      streetController.text = mydata['data']['userdata']['street_name'] ?? "";
      cityController.text = mydata['data']['userdata']['city'] ?? "";
      stateController.text = mydata['data']['userdata']['state'] ?? "";
      pinCodeController.text = mydata['data']['userdata']['pin_code'] ?? "";
    }
  }

  Future<bool> updateDetails() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> body = {
      "id": id,
      "full_name": TeacherNameController.text,
      "mobile_number": mobileNumberController.text,
      "block_number": blockController.text,
      "street_name": streetController.text,
      "city": cityController.text,
      "state": stateController.text,
      "pin_code": pinCodeController.text,
    };
    try {
      http.Response response = await http.put(
        Uri.parse(
            Apiconst.updateTeacher), // Use the correct endpoint for updating
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Updated successful'),
              content: Text("Advice to Re-login"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Fail'),
              content: Text("Somthing wrong while updating"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return false;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Fail'),
            content: Text("Somthing wrong while updating"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: MyTheme.mainbackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Edit Profile',
                style: TextStyle(
                    color: MyTheme.textcolor,
                    fontSize: getSize(context, 2.8),
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: MyTheme.button1,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    buildMyTextField("Teacher Name", TeacherNameController,
                        width, "String", 255, context),
                    buildMyTextField("Mobile Number", mobileNumberController,
                        width, "Number", 10, context),
                    SizedBox(
                      height: getHeight(context, 0.02),
                    ),
                    horizontalLine(),
                    Padding(
                      padding: const EdgeInsets.only(top: 13),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Edit Address",
                          style: TextStyle(
                              color: MyTheme.textcolor,
                              fontSize: getSize(context, 2.7),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    buildMyTextField("Block No.(or name)", blockController,
                        width, "String", 255, context),
                    buildMyTextField("Street Name", streetController, width,
                        "String", 255, context),
                    buildMyTextField(
                        "City", cityController, width, "String", 255, context),
                    buildMyTextField("State", stateController, width, "String",
                        255, context),
                    buildMyTextField("Pin Code", pinCodeController, width,
                        "Number", 6, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: InkWell(
                        onTap: () async {
                          if (await updateDetails()) {
                            GetStorage storage = GetStorage();
                            storage.write('login_data', {
                              'data': {
                                'userdata': {
                                  'id': id,
                                  'full_name': TeacherNameController.text,
                                  'mobile_number': mobileNumberController.text,
                                  'block_number': blockController.text,
                                  'street_name': streetController.text,
                                  'city': cityController.text,
                                  'state': stateController.text,
                                  'pin_code': pinCodeController.text,
                                }
                              }
                            });
                            setState(() {});
                          }
                        },
                        child: Container(
                          height: getHeight(context, 0.05),
                          width: getWidth(context, 0.38),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: MyTheme.mainbutton,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: MyTheme.mainbuttontext,
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.06,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(context, 0.02),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  bool areAllFieldsFilled() {
    return TeacherNameController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        blockController.text.isNotEmpty &&
        streetController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        pinCodeController.text.isNotEmpty;
  }
}
