// ignore_for_file: unnecessary_null_comparison, unused_element, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/mailSender.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  TextEditingController phoneController = TextEditingController();
  String? selectedCourse;
  String? selectedShift;

  bool _isLoading = false;

  // final List<String> courses = [
  //   'Not Selected',
  //   'Course A',
  //   'Course B',
  //   'Course C',
  //   'Course D',
  // ];
  List<Map<String, dynamic>> shifts = [
    {"id": 0, "name": "Not Selected"}
  ];

  List<Map<String, dynamic>> courses = [
    {"id": 0, "name": "Not Selected"}
  ];

  Future<void> fetchShifts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(Apiconst.listallShift));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          final List<dynamic> shiftsData = data['data'];
          shifts = shiftsData.map((shift) {
            return {
              'id': shift['id'],
              'name': shift['shiftName'].toString(),
            };
          }).toList();
          setState(() {});
        } else {
          throw Exception('Data key not found in API response');
        }
      } else {
        throw Exception('Failed to fetch shifts');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchCourses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(Apiconst.listallCourses));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          final List<dynamic> courseData = data['data'];
          courses = courseData.map((course) {
            return {
              'id': course['id'],
              'name': course['course_name'].toString(),
            };
          }).toList();
          setState(() {});
        } else {
          throw Exception('Data key not found in API response');
        }
      } else {
        throw Exception('Failed to fetch Courses');
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchShifts();
    fetchCourses();
  }

  Future<Map<String, dynamic>> fetchCourse(int cid) async {
    try {
      Map<String, dynamic> body = {"id": cid};

      final response = await http.post(
        Uri.parse(Apiconst.getCourseinfo),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          return {
            'timeDuration': data['data']['timeDuration'],
            'has_levels': data['data']['has_levels']
          };
        } else {
          throw Exception('Data key not found in API response');
        }
      } else {
        throw Exception('Failed to fetch shifts');
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> addStudent(String firstName, String lastName, String password,
      String email, int? shiftid, int? courseid, String phone) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String username = generateUsername(firstName, lastName);
      // print(username);
      int loginid = await addLogin(username, password, "student", email);
      int studentid =
          await addStudentData(firstName, lastName, phone, loginid, shiftid);

      await addEnrollment(studentid, courseid!);
      // print(studentid);
      EmailService emailService = EmailService();
      String mailStatus = await emailService.sendEmail(
          "student", email, ("$firstName $lastName"), username, password);
      String dialogMessage = mailStatus == 'Email sent successfully'
          ? 'Student added successfully.Email sent successfully'
          : 'Failed to send email. Please try again later.';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Status'),
            content: Text(dialogMessage),
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
      setState(() {
        firstNameController.text = '';
        lastNameController.text = '';
        passwordController.text = '';
        emailController.text = '';
        phoneController.text = '';
        // selectedCourse = '0';
        // selectedShift = '0';
      });
    } catch (e) {
      // Show error popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to add Student: $e'),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<int> addLogin(String username, String password, String selectedType,
      String email) async {
    try {
      Map<String, dynamic> body = {
        "username": username,
        "password": password,
        "email": email,
        "type": selectedType,
        "isActive": true
      };
      // print(body);

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
          throw Exception('Failed to add Student');
        }
      } else if (response.statusCode == 409) {
        throw Exception('Student or Email already exists');
      } else {
        throw Exception('Failed to add Student or Username already exists');
      }
      // return 1;
    } catch (e) {
      throw Exception('Error $e');
    }
  }

  String generateUsername(String firstName, String lastName) {
    String formattedDate = DateFormat('ddMMyy').format(DateTime.now());
    return '${firstName.toLowerCase()}${lastName.toLowerCase()}$formattedDate';
  }

  String findLastMonth(int months) {
    DateTime today = DateTime.now();
    DateTime lastMonth = today.add(Duration(days: months * 30));
    return DateFormat('yyyy-MM-dd').format(lastMonth);
  }

  Future<void> addEnrollment(int studid, int courseid) async {
    Map<String, dynamic> courseInfo = await fetchCourse(courseid);
    int temp = courseInfo['timeDuration'];
    bool hasLevels = courseInfo['has_levels'];

    String lastMon = findLastMonth(temp);
    try {
      Map<String, dynamic> body = {
        "enrollment_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "is_current_course": 1,
        "last_month": lastMon,
        "course_status": 1,
        "studentdatumId": studid,
        "courseId": courseid,
        "courseLevelId": hasLevels ? 1 : null
      };

      final response = await http.post(
        Uri.parse(Apiconst.addEnrollment),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to add Student in course enrollment');
      }
    } catch (socketException) {
      throw Exception('No Internet Connection Time out');
    }
  }

  Future<int> addStudentData(String firstName, String lastName, String phone,
      int loginid, int? shiftid) async {
    try {
      Map<String, dynamic> addStudentdata = {
        "full_name": '$firstName $lastName',
        "mobile_number": phone,
        "logindatumId": loginid,
        "shiftdatumId": shiftid
      };
      final studentResponse = await http.post(
        Uri.parse(Apiconst.addStudent),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(addStudentdata),
      );
      if (studentResponse.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(studentResponse.body);
        // Get the 'id' from the 'data' object
        return jsonData['data']['id'];
      } else {
        throw Exception('Failed to add student');
      }
    } catch (socketException) {
      throw Exception('No Internet Connection Time out');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: _isLoading
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
                title: Text('Add Student',
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
                          "Select Course",
                          style:
                              TextStyle(color: MyTheme.textcolor, fontSize: 20),
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
                          style:
                              TextStyle(color: MyTheme.textcolor, fontSize: 20),
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
                            if (_validateFields(context)) {
                              // print(selectedShift);
                              addStudent(
                                  firstNameController.text,
                                  lastNameController.text,
                                  passwordController.text,
                                  emailController.text,
                                  int.parse(selectedShift!),
                                  int.parse(selectedCourse!),
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
            ),
    );
  }

  Widget buildmainDropdown(String? selectedValue, Function(String?) onChanged,
      context, List<Map<String, dynamic>> types) {
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
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Not Selected'),
            ),
            ...types.map((unit) {
              return DropdownMenuItem(
                value: unit["id"].toString(),
                child: Text(unit["name"].toString()),
              );
            }).toList(),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

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
                Text('Mail should be in Proper format.',
                    style: TextStyle(color: MyTheme.textcolor)),
                Text(
                    'Password must contain At least 8 characters and password must contain 1 small and 1 special character.',
                    style: TextStyle(color: MyTheme.textcolor)),
              ],
            ),
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
      return false; // Validation failed
    }
    return true; // Validation passed
  }
}
