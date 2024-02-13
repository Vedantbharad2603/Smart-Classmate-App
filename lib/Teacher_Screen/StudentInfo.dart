import 'package:flutter/material.dart';
import 'package:smartclassmate/Start_Screen/login.dart';
import 'package:smartclassmate/Student_Screen/st_downloads.dart';
import 'package:smartclassmate/Student_Screen/st_edit_profile.dart';
import 'package:smartclassmate/Student_Screen/st_my_courses.dart';
import 'package:smartclassmate/Student_Screen/st_settings.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

// ignore: must_be_immutable
class StudentInfo extends StatefulWidget {
  StudentInfo({super.key});

  @override
  State<StudentInfo> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<StudentInfo> {
  List<Map<String, dynamic>> studentData = [
    {
      'studentname': 'Vedant020124',
      'name': 'Vedant Bharad',
      'course': 'Advance',
      'shift': 1,
      'lastmonth': '4/2024'
    }
  ];
  List<MapEntry<DateTime, int>> dateIntList = [
    MapEntry(DateTime(2024, 2, 1), 0),
    MapEntry(DateTime(2024, 2, 2), 1),
    MapEntry(DateTime(2024, 2, 3), 1),
    MapEntry(DateTime(2024, 2, 4), 1),
    MapEntry(DateTime(2024, 2, 5), 2),
    MapEntry(DateTime(2024, 2, 6), 2),
    MapEntry(DateTime(2024, 2, 7), 2),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          title:
              Text('Student Info.', style: TextStyle(color: MyTheme.textcolor)),
        ),
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
                              CircleAvatar(
                                backgroundColor: MyTheme.highlightcolor,
                                radius: getSize(context, 4.2),
                                child: Text(
                                  studentData[0]['name'][0],
                                  style: TextStyle(
                                      fontSize: getSize(context, 4.1),
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: getSize(context, 3)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      studentData[0]['name'],
                                      style: TextStyle(
                                          color: MyTheme.textcolor,
                                          fontSize: getSize(context, 3.1),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: getHeight(context, 0.01),
                                    ),
                                    Text(
                                      "@" + studentData[0]['studentname'],
                                      style: TextStyle(
                                          color: MyTheme.textcolor
                                              .withOpacity(0.7),
                                          fontSize: getSize(context, 1.7),
                                          fontWeight: FontWeight.bold),
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
                                          "Student",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            myinfobox(
                                "Shift", studentData[0]['shift'].toString()),
                            myinfobox("Course", studentData[0]['course']),
                            myinfobox(
                                "Last Month", studentData[0]['lastmonth']),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              showAttendance("Your Attendance", context, dateIntList),
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
                      customContainerWithInkWell("View Courses", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StMyCourses(),
                          ),
                        );
                      }, Icons.library_books_outlined),
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
                        //StEditProfile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StEditProfile(),
                          ),
                        );
                      }, Icons.person_outline_sharp),
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
            Text(
              title,
              style: TextStyle(
                  color: MyTheme.textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: getSize(context, 1.9)),
            ),
            Text(
              info,
              style: TextStyle(
                  color: MyTheme.textcolor, fontSize: getSize(context, 1.7)),
            )
          ],
        ),
      ),
    );
  }
}
