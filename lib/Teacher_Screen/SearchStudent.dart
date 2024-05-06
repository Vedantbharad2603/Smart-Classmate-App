// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:smartclassmate/Teacher_Screen/StudentInfo.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchStudent extends StatefulWidget {
  const SearchStudent({Key? key}) : super(key: key);

  @override
  State<SearchStudent> createState() => _SearchStudentState();
}

class _SearchStudentState extends State<SearchStudent> {
  List<Map<String, dynamic>> studentData = [];
  TextEditingController textEditingController = TextEditingController();

  List<int> shiftTypes = [1, 2];
  String searchText = '';
  bool _isLoading = false;
  late int teacherid;
  String username_d = "";
  String password_d = "";

  @override
  void initState() {
    super.initState();
    GetStorage storage = GetStorage();
    final mydata = storage.read('login_data');

    if (mydata != null) {
      teacherid = mydata['data']['userdata']['id'] ?? 0;
      username_d = mydata['data']['login']['username'] ?? "";
      password_d = mydata['data']['login']['password'] ?? "";
    }
    fetchStudents();
    studentData.sort((a, b) => a['full_name'].compareTo(b['full_name']));
  }

  Future<void> fetchStudents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(Apiconst.getStudent));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // print(responseData['data'][0]['login']);
        if (responseData.containsKey('data')) {
          List<dynamic> data = responseData['data'];
          List<Map<String, dynamic>> updatedTeacherData = [];
          for (var item in data) {
            updatedTeacherData.add({
              'id': item['id'],
              'full_name': item['full_name'],
              'email': item['email'],
              'mobile_number': item['mobile_number'],
              'block_number': item['block_number'],
              'street_name': item['street_name'],
              'city': item['city'],
              'state': item['state'],
              'pin_code': item['pin_code'],
              'createdAt': item['createdAt'],
              'updatedAt': item['updatedAt'],
              'logindatum_id': item['logindatum_id'],
              'shiftdatum_id': item['shiftdatum_id'],
              'is_active': item['is_active'],
              'username': item['username'],
              'course_name': item['course_name'],
            });
          }
          setState(() {
            studentData = updatedTeacherData;
          });
        } else {
          throw Exception('Data key not found in API response');
        }
      } else {
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> giveWork(String details, int studid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      log("$details $studid $teacherid");
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      Map<String, dynamic> body = {
        "homework_details": details,
        "homework_date": formattedDate,
        "is_submited": false,
        "studentdatum_id": studid,
        "teacherdatum_id": teacherid
      };
      final response = await http.post(
        Uri.parse(Apiconst.addHomeWork),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      log((response.statusCode).toString());

      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to add Course level');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to add Course Concepts: $e'),
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
        textEditingController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredStudents = studentData
        .where((student) => student['username']
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    // // Sort the students based on their names
    // filteredStudents.sort((a, b) => a['username']
    //     .toLowerCase()
    //     .compareTo(b['username'].toLowerCase()));

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
                title: Text(
                  "Student Search",
                  style: TextStyle(
                      color: MyTheme.textcolor,
                      fontSize: getSize(context, 2.7),
                      fontWeight: FontWeight.bold),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      giveuserinfo('Username: $username_d',
                          'Password: $password_d', context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: getSize(context, 1),
                        top: getHeight(context, 0.007),
                        bottom: getHeight(context, 0.007),
                      ),
                      child: CircleAvatar(
                        radius: getSize(context, 3),
                        backgroundColor: MyTheme.highlightcolor,
                        child: Icon(Icons.person,
                            color: Colors.black, size: getSize(context, 3.6)),
                      ),
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                        style: TextStyle(color: MyTheme.textcolor),
                        decoration: InputDecoration(
                          labelText: 'Search Student',
                          labelStyle: TextStyle(color: MyTheme.textcolor),
                          suffixIcon: Icon(
                            Icons.search,
                            color: MyTheme.textcolor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: getHeight(context, 0.7),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> student =
                                filteredStudents[index];
                            return Padding(
                              padding: EdgeInsets.all(getSize(context, 0.7)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      getSize(context, 1)),
                                  color: MyTheme.background,
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyTheme.boxshadow,
                                      spreadRadius: getSize(context, 0.5),
                                      blurRadius: getSize(context, 0.8),
                                      offset: Offset(0, getSize(context, 0.3)),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.all(getSize(context, 1)),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getSize(context, 1)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  student['full_name'],
                                                  style: TextStyle(
                                                    fontSize:
                                                        getSize(context, 2.4),
                                                    fontWeight: FontWeight.bold,
                                                    color: MyTheme.textcolor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      getHeight(context, 0.001),
                                                ),
                                                Text(
                                                  "@${student['username']}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        getSize(context, 1.6),
                                                    fontWeight: FontWeight.bold,
                                                    color: MyTheme.textcolor
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  getSize(context, 0.1)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: getWidth(
                                                        context, 0.008),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.transparent,
                                                ),
                                                height:
                                                    getHeight(context, 0.057),
                                                width: getWidth(context, 0.20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Course",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: getSize(
                                                            context, 1.6),
                                                        color:
                                                            MyTheme.textcolor,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${student['course_name']}",
                                                      style: TextStyle(
                                                        fontSize: getSize(
                                                            context, 1.4),
                                                        color: MyTheme.textcolor
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          PopupMenuButton(
                                            color: MyTheme.background2,
                                            icon: Icon(Icons.more_vert,
                                                color: MyTheme.textcolor),
                                            itemBuilder:
                                                (BuildContext context) {
                                              return [
                                                PopupMenuItem(
                                                  child: InkWell(
                                                    onTap: () {
                                                      // Handle Give Work action
                                                    },
                                                    child: Row(
                                                      children: [
                                                        studentbutton(
                                                            () {},
                                                            "Give work",
                                                            student['username'],
                                                            7,
                                                            MyTheme
                                                                .highlightcolor
                                                                .withOpacity(
                                                                    0.2),
                                                            MyTheme
                                                                .highlightcolor
                                                                .withOpacity(
                                                                    0.6),
                                                            context,
                                                            student['id']),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  child: InkWell(
                                                    onTap: () {
                                                      // Handle Give eBook action
                                                    },
                                                    child: Row(
                                                      children: [
                                                        studentbutton(() {
                                                          // StudentInfo
                                                        },
                                                            "Show Profile",
                                                            student['username'],
                                                            7,
                                                            MyTheme.button1
                                                                .withOpacity(
                                                                    0.2),
                                                            MyTheme.button1
                                                                .withOpacity(
                                                                    0.8),
                                                            context,
                                                            student['id']),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // PopupMenuItem(
                                                //   child: InkWell(
                                                //     onTap: () {
                                                //       // Handle Show Profile action
                                                //     },
                                                //     child: Row(
                                                //       children: [
                                                //         studentbutton(
                                                //             () {},
                                                //             "Give eBook",
                                                //             student['username'],
                                                //             7,
                                                //             MyTheme.mainbutton,
                                                //             MyTheme
                                                //                 .mainbuttontext,
                                                //             context),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                              ];
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget studentbutton(
      VoidCallback onTap,
      String label,
      String id,
      double borderRadius,
      Color color1,
      Color color2,
      BuildContext context,
      int studid) {
    return GestureDetector(
      onTap: () {
        if (label == "Give work") {
          _showGiveWorkPopup(context, studid);
        } else if (label == "Show Profile") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentInfo(studid: studid),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color2,
            width: getWidth(context, 0.008),
          ),
          borderRadius: BorderRadius.circular(15),
          color: color1,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Text(
          label,
          style: TextStyle(
            color: MyTheme.textcolor,
            fontSize: getSize(context, 1.8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _showGiveWorkPopup(BuildContext context, int studid) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background2,
          title: Text('Give Work', style: TextStyle(color: MyTheme.textcolor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Enter work details:',
                  style: TextStyle(color: MyTheme.textcolor)),
              const SizedBox(height: 10),
              TextField(
                style: TextStyle(color: MyTheme.textcolor),
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Work details...',
                  hintStyle: TextStyle(color: MyTheme.textcolor),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(MyTheme.button2.withOpacity(0.2)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the value as needed
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: MyTheme.button2,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(MyTheme.mainbutton),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the value as needed
                  ),
                ),
              ),
              onPressed: () {
                // ignore: unused_local_variable
                String workDetails = textEditingController.text;
                // Handle the work details
                giveWork(workDetails, studid);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Give',
                style: TextStyle(
                  color: MyTheme.mainbuttontext,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
