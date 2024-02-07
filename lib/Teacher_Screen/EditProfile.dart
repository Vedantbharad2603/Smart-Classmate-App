// ignore_for_file: unused_local_variable, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController TeacherNameController = TextEditingController();
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
              buildMyTextField("Teacher Name", TeacherNameController, width,
                  "String", 255, context),
              buildMyTextField("Mobile Number", mobileNumberController, width,
                  "Number", 10, context),
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
              buildMyTextField("Block No.(or name)", blockController, width,
                  "String", 255, context),
              buildMyTextField("Street Name", streetController, width, "String",
                  255, context),
              buildMyTextField(
                  "City", cityController, width, "String", 255, context),
              buildMyTextField(
                  "State", stateController, width, "String", 255, context),
              buildMyTextField(
                  "Pin Code", pinCodeController, width, "Number", 7, context),
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
