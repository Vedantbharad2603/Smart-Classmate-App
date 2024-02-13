// ignore_for_file: unnecessary_null_comparison, unused_element

import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String selectedCourse = 'Not Selected';
  String selectedShift = 'Not Selected';

  final List<String> courses = [
    'Not Selected',
    'Course A',
    'Course B',
    'Course C',
    'Course D',
  ];
  final List<String> shifts = ['Not Selected', 'Shift 1', 'Shift 2'];

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
        title: Text('Add Student', style: TextStyle(color: MyTheme.textcolor)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildMyTextField("First Name", firstNameController, width,
                  "String", 20, context),
              buildMyTextField("Last Name", lastNameController, width, "String",
                  20, context),
              buildMyTextField(
                  "Email ID", emailController, width, "String", 255, context),
              buildMyTextField(
                  "Password", passwordController, width, "String", 8, context),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Select Course",
                  style: TextStyle(color: MyTheme.textcolor, fontSize: 20),
                ),
              ),
              buildmainDropdown(selectedCourse, (value) {
                setState(() {
                  selectedCourse = value!;
                });
              }, context, courses),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Select Shift",
                  style: TextStyle(color: MyTheme.textcolor, fontSize: 20),
                ),
              ),
              buildmainDropdown(selectedShift, (value) {
                setState(() {
                  selectedShift = value!;
                });
              }, context, shifts),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: InkWell(
                  onTap: () {
                    _validateFields(context);
                  },
                  child: Container(
                    height: getHeight(context, 0.05),
                    width: getWidth(context, 0.38),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: MyTheme.mainbutton,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'Add Student',
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

  Widget buildmainDropdown(String selectedValue, Function(String?) onChanged,
      context, List<String> types) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(height * 0.011),
      child: Container(
        padding: EdgeInsets.only(left: height * 0.016, right: height * 0.016),
        decoration: BoxDecoration(
          color: MyTheme.background,
          borderRadius: BorderRadius.circular(height * 0.02),
        ),
        child: DropdownButton<String>(
          dropdownColor: MyTheme.background,
          value: selectedValue,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          iconSize: height * 0.04,
          isExpanded: true,
          underline: const SizedBox(),
          style: TextStyle(color: MyTheme.textcolor, fontSize: height * 0.018),
          items: types.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ignore: unused_element
  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 8;
  }

// Inside _AddStudentPageState class
  bool _validateFields(BuildContext context) {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedCourse == "Not Selected" ||
        selectedShift == "Not Selected" ||
        !_validateEmail(emailController.text) ||
        !_validatePassword(passwordController.text)) {
      // Show popup with text field data
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: MyTheme.background,
            title: Text(
              'Validation Failed',
              style: TextStyle(color: MyTheme.button2),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('First Name: ${firstNameController.text}',
                    style: TextStyle(color: MyTheme.textcolor)),
                Text('Last Name: ${lastNameController.text}',
                    style: TextStyle(color: MyTheme.textcolor)),
                Text('Email: ${emailController.text}',
                    style: TextStyle(color: MyTheme.textcolor)),
                Text('Password: ${passwordController.text}',
                    style: TextStyle(color: MyTheme.textcolor)),
                Text('Selected Course: $selectedCourse',
                    style: TextStyle(color: MyTheme.textcolor)),
                Text('Selected Shift: $selectedShift',
                    style: TextStyle(color: MyTheme.textcolor)),
              ],
            ),
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
      return false; // Validation failed
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text('Submitted Data',
              style: TextStyle(color: MyTheme.mainbuttontext)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First Name: ${firstNameController.text}',
                  style: TextStyle(color: MyTheme.textcolor)),
              Text('Last Name: ${lastNameController.text}',
                  style: TextStyle(color: MyTheme.textcolor)),
              Text('Email: ${emailController.text}',
                  style: TextStyle(color: MyTheme.textcolor)),
              Text('Password: ${passwordController.text}',
                  style: TextStyle(color: MyTheme.textcolor)),
              Text('Selected Course: $selectedCourse',
                  style: TextStyle(color: MyTheme.textcolor)),
              Text('Selected Shift: $selectedShift',
                  style: TextStyle(color: MyTheme.textcolor)),
            ],
          ),
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
    return true; // Validation passed
  }
}
