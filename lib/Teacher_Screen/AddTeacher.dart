import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/mailSender.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({Key? key}) : super(key: key);

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String selectedType = 'Not Selected';
  bool _isLoading = false;

  final List<String> t_type = [
    'Not Selected',
    'admin',
    'teacher',
    'trainee',
  ];

  Future<void> addTeacher(String firstName, String lastName, String password,
      String email, String selectedType, String phone) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String username = generateUsername(firstName, lastName);
      int id = await addLogin(username, password, selectedType, email);
      await addTeacherData(firstName, lastName, phone, id);

      EmailService emailService = EmailService();
      String mailStatus = await emailService.sendEmail(selectedType, email,
          (firstName + " " + lastName), username, password);
      String dialogMessage = mailStatus == 'Email sent successfully'
          ? 'Teacher added successfully.Email sent successfully'
          : 'Failed to send email. Please try again later.';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email Status'),
            content: Text(dialogMessage),
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
      setState(() {
        firstNameController.text = '';
        lastNameController.text = '';
        passwordController.text = '';
        emailController.text = '';
        phoneController.text = '';
        selectedType = 'Not Selected';
      });
    } catch (e) {
      // Show error popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add teacher: $e'),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String generateUsername(String firstName, String lastName) {
    String formattedDate = DateFormat('ddMMyy').format(DateTime.now());
    return '${firstName.toLowerCase()}${lastName.toLowerCase()}$formattedDate';
  }

  Future<int> addLogin(String username, String password, String selectedType,
      String email) async {
    Map<String, dynamic> body = {
      "username": username,
      "email": email,
      "password": password,
      "type": selectedType,
      "isActive": true
    };

    final response = await http.post(
      Uri.parse(Apiconst.addLogindata),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body2 = {"username": username};
      final response2 = await http.post(
        Uri.parse(Apiconst.giveuserlogin),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body2),
      );
      if (response2.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response2.body);
        // Get the 'id' from the 'data' object
        return jsonData['data']['id'];
      } else {
        throw Exception('Failed to add teacher');
      }
    } else {
      throw Exception('Failed to add teacher');
    }
  }

  Future<void> addTeacherData(
      String firstName, String lastName, String phone, int id) async {
    Map<String, dynamic> addteacherdata = {
      "full_name": '$firstName $lastName',
      "mobile_number": phone,
      "logindatumId": id
    };
    final teacherResponse = await http.post(
      Uri.parse(Apiconst.addTeacher),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(addteacherdata),
    );

    if (teacherResponse.statusCode != 200) {
      throw Exception('Failed to add teacher');
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
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: MyTheme.button1,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Add Teacher',
                  style: TextStyle(color: MyTheme.textcolor)),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildMyTextField("First Name", firstNameController, width,
                        "String", 20, context),
                    buildMyTextField("Last Name", lastNameController, width,
                        "String", 20, context),
                    buildMyTextField("Email ID", emailController, width,
                        "String", 255, context),
                    buildMyTextField("Mobile No", phoneController, width,
                        "Number", 10, context),
                    buildMyTextField("Password", passwordController, width,
                        "String", 20, context),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Select Type",
                        style:
                            TextStyle(color: MyTheme.textcolor, fontSize: 20),
                      ),
                    ),
                    buildmainDropdown(selectedType, (value) {
                      setState(() {
                        selectedType = value!;
                      });
                    }, context, t_type),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: InkWell(
                        onTap: () {
                          if (_validateFields(context)) {
                            addTeacher(
                                firstNameController.text,
                                lastNameController.text,
                                passwordController.text,
                                emailController.text,
                                selectedType,
                                phoneController.text);
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
                            'Add Teacher',
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
    // Regular expressions for password validation
    RegExp specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    RegExp upperCase = RegExp(r'[A-Z]');
    RegExp lowerCase = RegExp(r'[a-z]');

    // Check if password meets all criteria
    return password.length >= 8 &&
        specialChar.hasMatch(password) &&
        upperCase.hasMatch(password) &&
        lowerCase.hasMatch(password);
  }

  bool _validatePhone(String phone) {
    return phone.length == 10;
  }

// Inside _AddStudentPageState class
  bool _validateFields(BuildContext context) {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        !_validatePhone(phoneController.text) ||
        selectedType == "Not Selected" ||
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
                Text('Mail should be in Proper format.',
                    style: TextStyle(color: MyTheme.textcolor)),
                Text(
                    'Password must contain At least 8 characters and password must contain 1 small and 1 special character.',
                    style: TextStyle(color: MyTheme.textcolor)),
                // Text('Email: ${emailController.text}',
                //     style: TextStyle(color: MyTheme.textcolor)),
                // Text('Password: ${passwordController.text}',
                //     style: TextStyle(color: MyTheme.textcolor)),
                // Text('Selected Course: $selectedType',
                //     style: TextStyle(color: MyTheme.textcolor)),
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
    return true; // Validation passed
  }
}
