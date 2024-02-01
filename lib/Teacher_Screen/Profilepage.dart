import 'package:flutter/material.dart';
import 'package:smartclassmate/Start_Screen/login.dart';
import 'package:smartclassmate/Student_Screen/st_downloads.dart';
import 'package:smartclassmate/Student_Screen/st_edit_profile.dart';
import 'package:smartclassmate/Student_Screen/st_my_courses.dart';
import 'package:smartclassmate/tools/helper.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 253, 233),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(getSize(context, 1)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(getSize(context, 1)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
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
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 241, 101),
                                  radius: getSize(context, 4.2),
                                  child: Text(
                                    "V",
                                    style: TextStyle(
                                        fontSize: getSize(context, 4.1),
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: getSize(context, 3)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "VEDANT BHARAD",
                                        style: TextStyle(
                                            fontSize: getSize(context, 3.1),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: getHeight(context, 0.01),
                                      ),
                                      Text(
                                        "@vedantbharad010124",
                                        style: TextStyle(
                                            fontSize: getSize(context, 1.7),
                                            fontWeight: FontWeight.bold),
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
                              Padding(
                                padding: EdgeInsets.all(getSize(context, 1)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: getWidth(context, 0.008)),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.transparent,
                                  ),
                                  height: getHeight(context, 0.065),
                                  width: getWidth(context, 0.25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Shift",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: getSize(context, 1.9)),
                                      ),
                                      Text(
                                        "2",
                                        style: TextStyle(
                                            fontSize: getSize(context, 1.7)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: getWidth(context, 0.008)),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.transparent,
                                  ),
                                  height: getHeight(context, 0.065),
                                  width: getWidth(context, 0.25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Course",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: getSize(context, 1.9)),
                                      ),
                                      Text(
                                        "advance",
                                        style: TextStyle(
                                            fontSize: getSize(context, 1.7)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: getWidth(context, 0.008)),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.transparent,
                                  ),
                                  height: getHeight(context, 0.065),
                                  width: getWidth(context, 0.25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Shift",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: getSize(context, 1.9)),
                                      ),
                                      Text(
                                        "2",
                                        style: TextStyle(
                                            fontSize: getSize(context, 1.7)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                      borderRadius: BorderRadius.circular(getSize(context, 1)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
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
                                size: getSize(context, 4), color: Colors.black),
                            Text(
                              "Content",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getSize(context, 2.7),
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        customContainerWithInkWell("My Courses", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StMyCourses(),
                            ),
                          );
                        }, Icons.library_books_outlined),
                        customContainerWithInkWell("Downloads", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StDownloads(),
                            ),
                          );
                        }, Icons.download),
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
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
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
                                size: getSize(context, 4), color: Colors.black),
                            Text(
                              "Rreferences",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getSize(context, 2.7),
                                  color: Colors.black),
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
                        customContainerWithInkWell(
                            "About Us", () {}, Icons.info_outline_rounded),
                        customContainerWithInkWell("Settings", () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => StSettings(),
                          //   ),
                          // );
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
                )
              ],
            ),
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
            color: Colors.white,
            border:
                Border.all(color: Colors.grey, width: getWidth(context, 0.004)),
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
                        color: Colors.grey[400],
                      ),
                      child: Icon(
                        myicon,
                        color: const Color.fromARGB(255, 76, 136, 15),
                        size: getSize(context, 2),
                      ),
                    ),
                    SizedBox(
                      width: getWidth(context, 0.03),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          color: Colors.black, fontSize: getSize(context, 2)),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: getSize(context, 2),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
