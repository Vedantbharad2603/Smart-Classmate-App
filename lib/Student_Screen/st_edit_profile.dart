// ignore_for_file: unused_local_variable, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class StEditProfile extends StatefulWidget {
  const StEditProfile({Key? key}) : super(key: key);

  @override
  State<StEditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<StEditProfile> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyTheme.mainbackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                          color: MyTheme.textcolor,
                          fontSize: getSize(context, 2.8),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              buildMyTextField(
                  "Student Name", studentNameController, width, "String", 255),
              buildMyTextField(
                  "Mobile Number", mobileNumberController, width, "Number", 10),
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
              buildMyTextField(
                  "Block No.(or name)", blockController, width, "String", 255),
              buildMyTextField(
                  "Street Name", streetController, width, "String", 255),
              buildMyTextField("City", cityController, width, "String", 255),
              buildMyTextField("State", stateController, width, "String", 255),
              buildMyTextField(
                  "Pin Code", pinCodeController, width, "Number", 7),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: InkWell(
                  onTap: () {},
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

  Widget buildMyTextField(String label, TextEditingController controller,
      double width, String inputType, int maxLen) {
    TextInputType keyboardType;
    if (inputType == "Number") {
      keyboardType = TextInputType.number;
    } else {
      keyboardType = TextInputType.text;
    }

    return Padding(
      padding: EdgeInsets.only(
          left: getWidth(context, 0.03),
          right: getWidth(context, 0.03),
          top: getHeight(context, 0.02)),
      child: Container(
        decoration: BoxDecoration(
          color: MyTheme.background,
          borderRadius: BorderRadius.circular(getSize(context, 1.5)),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: getWidth(context, 0.02),
                    top: getWidth(context, 0.02)),
                child: Text(
                  label,
                  style: TextStyle(
                    color: MyTheme.textcolor,
                    fontSize: getSize(context, 2.6),
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(getSize(context, 1.2)),
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLength: maxLen,
                  style: TextStyle(
                    color: MyTheme.textcolor,
                    fontSize: getSize(context, 2),
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyTheme.background2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(getSize(context, 2)),
                    ),
                    contentPadding: EdgeInsets.all(getSize(context, 1.5)),
                    counterStyle: TextStyle(
                      color: MyTheme.textcolor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool areAllFieldsFilled() {
    return studentNameController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        blockController.text.isNotEmpty &&
        streetController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        pinCodeController.text.isNotEmpty;
  }
}
