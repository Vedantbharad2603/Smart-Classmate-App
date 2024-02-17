// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smartclassmate/Start_Screen/login.dart';
import 'package:smartclassmate/Teacher_Screen/AddEvent.dart';
import 'package:smartclassmate/Teacher_Screen/AddStudent.dart';
import 'package:smartclassmate/Teacher_Screen/AddTeacher.dart';
import 'package:smartclassmate/Teacher_Screen/EditProfile.dart';
import 'package:smartclassmate/Teacher_Screen/ListofHolidays.dart';
import 'package:smartclassmate/Teacher_Screen/ManageCourse.dart';
import 'package:smartclassmate/Teacher_Screen/ManageTeacher.dart';
import 'package:smartclassmate/Teacher_Screen/PendingRegistration.dart';
import 'package:smartclassmate/Teacher_Screen/Settings.dart';
import 'package:smartclassmate/Teacher_Screen/UploadEbook.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class Profilepage extends StatefulWidget {
  void Function() onThemeToggleMaster;
  Profilepage({super.key, required this.onThemeToggleMaster});

  @override
  State<Profilepage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profilepage> {
  String role = "Admin";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.mainbackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(getSize(context, 1)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(context, 1)),
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
                                  giveuserinfo('Username: Vedant Bharad',
                                      'Password: Ved@nt123', context);
                                },
                                child: CircleAvatar(
                                  backgroundColor: MyTheme.highlightcolor,
                                  radius: getSize(context, 4.2),
                                  child: Text(
                                    "V",
                                    style: TextStyle(
                                        fontSize: getSize(context, 4.1),
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: getSize(context, 3)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "VEDANT BHARAD",
                                      style: TextStyle(
                                          color: MyTheme.textcolor,
                                          fontSize: getSize(context, 3.1),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: getHeight(context, 0.01),
                                    ),
                                    Text(
                                      "@vedantbharad010124",
                                      style: TextStyle(
                                          color: MyTheme.textcolor
                                              .withOpacity(0.7),
                                          fontSize: getSize(context, 1.7),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: getHeight(context, 0.01),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Loreto",
                                          style: TextStyle(
                                              color: MyTheme.textcolor
                                                  .withOpacity(0.7),
                                              fontSize: getSize(context, 1.7),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.arrow_right_rounded,
                                          size: 30,
                                          color: MyTheme.textcolor,
                                        ),
                                        Text(
                                          role,
                                          style: TextStyle(
                                              color: MyTheme.textcolor
                                                  .withOpacity(0.7),
                                              fontSize: getSize(context, 1.7),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
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
                    borderRadius: BorderRadius.circular(getSize(context, 1)),
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
                          Text(
                            "Content",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: getSize(context, 2.7),
                                color: MyTheme.textcolor),
                          ),
                        ],
                      ),
                      customContainerWithInkWell("Upload", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadEbook(),
                          ),
                        );
                      }, Icons.upload),
                      SizedBox(
                        height: getHeight(context, 0.018),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  ...chackrole(role),
                ],
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
                          Text(
                            "Rreferences",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: getSize(context, 2.7),
                                color: MyTheme.textcolor),
                          ),
                        ],
                      ),
                      customContainerWithInkWell("Edit Profile", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(),
                          ),
                        );
                      }, Icons.person_outline_sharp),
                      customContainerWithInkWell("Settings", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Settings(
                                onThemeToggleMaster: widget.onThemeToggleMaster,
                                onThemeToggleProfile: () => setState(() {})),
                          ),
                        );
                      }, Icons.settings),
                      customContainerWithInkWell("Logout", () {
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
              ),
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
                    Text(
                      text,
                      style: TextStyle(
                          color: MyTheme.textcolor,
                          fontSize: getSize(context, 2)),
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

  List<Widget> chackrole(String role) {
    if (role == "Admin") {
      List<Widget> adminOptions = [
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
                    Text(
                      "Manage",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getSize(context, 2.7),
                          color: MyTheme.textcolor),
                    ),
                  ],
                ),
                customContainerWithInkWell("Manage Holidays", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListofHolidays(),
                    ),
                  );
                }, Icons.date_range_rounded),
                customContainerWithInkWell("Add Event", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEventPage(),
                    ),
                  );
                }, LineIcons.calendarPlus),
                customContainerWithInkWell("Add Students", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddStudentPage(),
                    ),
                  );
                }, LineIcons.userCircle),
                customContainerWithInkWell("Manage Courses", () {
                  // giveuserinfo('Under development', '', context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageCourse(),
                    ),
                  );
                }, Icons.my_library_books_outlined),
                customContainerWithInkWell("Add Teacher", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTeacherPage(),
                    ),
                  );
                }, LineIcons.chalkboardTeacher),
                customContainerWithInkWell("Manage Teacher", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageTeacher(),
                    ),
                  );
                }, Icons.manage_accounts),
                customContainerWithInkWell("Registration Pending", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PendingRegistration(),
                    ),
                  );
                }, LineIcons.userClock),
                SizedBox(
                  height: getHeight(context, 0.02),
                ),
              ],
            ),
          ),
        ),
      ];

      return adminOptions;
    } else {
      // Return an empty list if the role is not "Admin"
      return [];
    }
  }
}
