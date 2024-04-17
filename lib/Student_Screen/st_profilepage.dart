import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartclassmate/Start_Screen/login.dart';
import 'package:smartclassmate/Student_Screen/st_downloads.dart';
import 'package:smartclassmate/Student_Screen/st_edit_profile.dart';
import 'package:smartclassmate/Student_Screen/st_my_courses.dart';
import 'package:smartclassmate/Student_Screen/st_settings.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class STProfilePage extends StatefulWidget {
  void Function() onThemeToggleMaster;
  STProfilePage({super.key, required this.onThemeToggleMaster});

  @override
  State<STProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<STProfilePage> {
  String role = "";
  String full_name_d = "";
  String username_d = "";
  String password_d = "";
  String shift_d = "";
  String coursename = "";
  String lastmon = "";
  int s_courseId = 0;
  int s_courseLevelId = 0;
  int s_courseStatus = 0;
  List<Map<String, dynamic>> shifts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchShifts();
    GetStorage storage = GetStorage();
    final mydata = storage.read('login_data');
    // print(mydata['data']['userdata']['shiftdatumId']);
    if (mydata != null) {
      role = mydata['data']['login']['type'] ?? "";
      full_name_d = mydata['data']['userdata']['full_name'] ?? "";
      username_d = mydata['data']['login']['username'] ?? "";
      password_d = mydata['data']['login']['password'] ?? "";
      shift_d = mydata['data']['userdata']['shiftdatumId'].toString() ?? "";
      coursename = mydata['data']['courseinfo']['course_name'] ?? "";
      lastmon = mydata['data']['courseinfo']['last_month'] ?? "";

      s_courseId = mydata['data']['courseinfo']['courseId'] ?? 0;
      s_courseLevelId = mydata['data']['courseinfo']['courseLevelId'] ?? 0;
      s_courseStatus = mydata['data']['courseinfo']['course_status'] ?? 0;
    }
  }

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
              'shiftName': shift['shiftName'].toString(),
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

  String getShiftNameById(int id, List<Map<String, dynamic>>? shifts) {
    if (shifts == null || shifts.isEmpty) return '';

    // Find the shift with the matching id
    Map<String, dynamic> shift = shifts.firstWhere(
      (shift) => shift['id'] == id,
      orElse: () => {},
    );

    // Return the shift name if it exists, otherwise return an empty string
    return shift.isNotEmpty ? shift['shiftName'] ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(getSize(context, 1)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(getSize(context, 1)),
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
                        child: Padding(
                          padding: EdgeInsets.all(getSize(context, 0.7)),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(getSize(context, 2)),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        giveuserinfo('Username: $username_d',
                                            'Password: $password_d', context);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: MyTheme.highlightcolor,
                                        radius: getSize(context, 4.2),
                                        child: Text(
                                          full_name_d
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              fontSize: getSize(context, 4.1),
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getSize(context, 3)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: getWidth(context, 0.6),
                                            child: Expanded(
                                              child: Text(
                                                "$full_name_d",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: MyTheme.textcolor,
                                                    fontSize:
                                                        getSize(context, 3.1),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: getHeight(context, 0.01),
                                          ),
                                          SizedBox(
                                            width: getWidth(context, 0.6),
                                            child: Expanded(
                                              child: Text(
                                                "@$username_d",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: MyTheme.textcolor
                                                        .withOpacity(0.7),
                                                    fontSize:
                                                        getSize(context, 1.7),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Loreto",
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    color: MyTheme.textcolor
                                                        .withOpacity(0.7),
                                                    fontSize:
                                                        getSize(context, 1.7),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Icon(
                                                Icons.arrow_right_rounded,
                                                size: 30,
                                                color: MyTheme.textcolor,
                                              ),
                                              Text(
                                                "$role",
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    color: MyTheme.textcolor
                                                        .withOpacity(0.7),
                                                    fontSize:
                                                        getSize(context, 1.7),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // myinfobox(
                                  //     "Shift", getShiftNameById(shift_d, shifts)),
                                  myinfobox(
                                      "Shift",
                                      getShiftNameById(
                                          int.parse(shift_d), shifts)),
                                  myinfobox("Course", coursename),
                                  myinfobox("Last Date", lastmon),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // showAttendance("Your Attendance", context, dateIntList),
                    Padding(
                      padding: EdgeInsets.all(getSize(context, 1)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(getSize(context, 1)),
                          color: MyTheme.background,
                          boxShadow: [
                            BoxShadow(
                              color: MyTheme.boxshadow,
                              spreadRadius: getSize(context, 1),
                              blurRadius: getSize(context, 1),
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: getHeight(context, 0.02),
                            ),
                            Row(
                              children: [
                                Icon(Icons.arrow_right_outlined,
                                    size: getSize(context, 4),
                                    color: MyTheme.mainbuttontext),
                                SizedBox(
                                  width: getWidth(context, 0.7),
                                  child: Expanded(
                                    child: Text(
                                      "Content",
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: getSize(context, 2.7),
                                          color: MyTheme.textcolor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            customContainerWithInkWell("My Courses", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StMyCourses(
                                      courseid: s_courseId,
                                      levelid: s_courseLevelId,
                                      cstatus: s_courseStatus),
                                ),
                              );
                            }, Icons.library_books_outlined),
                            // customContainerWithInkWell("Downloads", () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => const StDownloads(),
                            //     ),
                            //   );
                            // }, Icons.download),
                            SizedBox(
                              height: getHeight(context, 0.018),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(getSize(context, 1)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyTheme.background,
                          boxShadow: [
                            BoxShadow(
                              color: MyTheme.boxshadow,
                              spreadRadius: getSize(context, 1),
                              blurRadius: getSize(context, 1),
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: getHeight(context, 0.02),
                            ),
                            Row(
                              children: [
                                Icon(Icons.arrow_right_outlined,
                                    size: getSize(context, 4),
                                    color: MyTheme.mainbuttontext),
                                SizedBox(
                                  width: getWidth(context, 0.7),
                                  child: Expanded(
                                    child: Text(
                                      "Rreferences",
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: getSize(context, 2.7),
                                          color: MyTheme.textcolor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            customContainerWithInkWell("Edit Profile", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StEditProfile(),
                                ),
                              );
                            }, Icons.person_outline_sharp),
                            customContainerWithInkWell("About Us", () {
                              // print("Downloads tapped!");
                            }, Icons.info_outline_rounded),
                            customContainerWithInkWell("Settings", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StSettings(
                                      onThemeToggleMaster:
                                          widget.onThemeToggleMaster,
                                      onThemeToggleProfile: () =>
                                          setState(() {})),
                                ),
                              );
                            }, Icons.settings),
                            customContainerWithInkWell("Logout", () async {
                              final storage = GetStorage();
                              await storage.remove('login_data');
                              await storage.write('logedin', false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }, Icons.logout_outlined),
                            SizedBox(
                              height: getHeight(context, 0.02),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget customContainerWithInkWell(
    String text,
    VoidCallback onTap,
    IconData myicon,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(getSize(context, 1.2)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getSize(context, 1.2)),
            color: MyTheme.background2,
            border: Border.all(
                color: MyTheme.textcolor.withOpacity(0.3),
                width: getWidth(context, 0.004)),
          ),
          child: Padding(
            padding: EdgeInsets.all(getSize(context, 0.9)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: getHeight(context, 0.045),
                      width: getHeight(context, 0.045),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(getSize(context, 1.2)),
                        color: MyTheme.background,
                      ),
                      child: Icon(
                        myicon,
                        color: MyTheme.mainbuttontext,
                        size: getSize(context, 2.5),
                      ),
                    ),
                    SizedBox(
                      width: getWidth(context, 0.03),
                    ),
                    SizedBox(
                      width: getWidth(context, 0.6),
                      child: Expanded(
                        child: Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: MyTheme.textcolor,
                              fontSize: getSize(context, 2)),
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: getSize(context, 2),
                  color: MyTheme.textcolor.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myinfobox(String title, String info) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: MyTheme.textcolor.withOpacity(0.3),
              width: getWidth(context, 0.008)),
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
        ),
        height: getHeight(context, 0.065),
        width: getWidth(context, 0.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: MyTheme.textcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: getSize(context, 1.9)),
              ),
            ),
            Expanded(
              child: Text(
                info,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    color: MyTheme.textcolor, fontSize: getSize(context, 1.7)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
