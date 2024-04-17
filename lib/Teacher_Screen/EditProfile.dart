// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartclassmate/Start_Screen/login.dart';
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
  TextEditingController teacherNameController = TextEditingController();
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
      teacherNameController.text =
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
      "full_name": teacherNameController.text,
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
              title: const Text('Updated successful'),
              content: const Text("Going back to login"),
              actions: [
                TextButton(
                  onPressed: () async {
                    final storage = GetStorage();
                    await storage.remove('login_data');
                    await storage.write('logedin', false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text('OK'),
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
              title: const Text('Fail'),
              content: const Text("Somthing wrong while updating"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
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
            title: const Text('Fail'),
            content: const Text("Somthing wrong while updating"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
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
        ? Container(
            color: MyTheme.background,
            child: Center(
              child: CircularProgressIndicator(
                // strokeAlign: 1,
                color: MyTheme.button1,
                backgroundColor: MyTheme.background,
              ),
            ),
          )
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
                    buildMyTextField("Teacher Name", teacherNameController,
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
                          if (areAllFieldsFilled()) {
                            if (await updateDetails()) {
                              GetStorage storage = GetStorage();
                              storage.write('login_data', {
                                'data': {
                                  'userdata': {
                                    'id': id,
                                    'full_name': teacherNameController.text,
                                    'mobile_number':
                                        mobileNumberController.text,
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
                          } else {
                            String message =
                                "Please fill in all required fields.";
                            if (mobileNumberController.text.isEmpty) {
                              message += "\n- Mobile number is required.";
                            } else if (mobileNumberController.text.length !=
                                10) {
                              message +=
                                  "\n- Mobile number must be 10 digits long.";
                            }
                            if (pinCodeController.text.isEmpty) {
                              message += "\n- Pin code is required.";
                            } else if (pinCodeController.text.length != 6) {
                              message += "\n- Pin code must be 6 digits long.";
                            }
                            // Add similar checks for other fields if needed

                            // Show popup with the message
                            // Example of showing a dialog:
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Incomplete Details"),
                                  content: Text(message),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
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
    return teacherNameController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        mobileNumberController.text.length == 10 &&
        blockController.text.isNotEmpty &&
        streetController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        pinCodeController.text.isNotEmpty &&
        pinCodeController.text.length == 6;
  }
}
