// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartclassmate/Model/EventModel.dart';
import 'package:smartclassmate/Student_Screen/st_show_events.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class STHomepage extends StatefulWidget {
  const STHomepage({super.key});

  @override
  State<STHomepage> createState() => _STHomepageState();
}

List<MapEntry<DateTime, int>> dateIntList = [
  // MapEntry(DateTime(2024, 4, 1), 1),
  // MapEntry(DateTime(2024, 4, 2), 2),
  // MapEntry(DateTime(2024, 4, 3), 3),
  // MapEntry(DateTime(2024, 4, 4), 1),
  // MapEntry(DateTime(2024, 4, 5), 3),
  // MapEntry(DateTime(2024, 4, 6), 3),
  // MapEntry(DateTime(2024, 4, 7), 3),
];

class _STHomepageState extends State<STHomepage> {
  late int studentid;
  String full_name_d = "";
  String username_d = "";
  String password_d = "";
  String holidayName = "";
  String holidayDate = "";
  String coursename = "";
  bool _isLoading = false;
  List<EventModel> events = [];
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> work = [];
  @override
  void initState() {
    super.initState();
    GetStorage storage = GetStorage();
    final mydata = storage.read('login_data');
    if (mydata != null) {
      studentid = mydata['data']['userdata']['id'] ?? 0;
      full_name_d = mydata['data']['userdata']['full_name'] ?? "";
      username_d = mydata['data']['login']['username'] ?? "";
      password_d = mydata['data']['login']['password'] ?? "";
      coursename = mydata['data']['courseinfo']['course_name'] ?? "";
    }
    fetchWork(studentid);
    fetchEvents();
    fetchHoliday();
    fetchAttendance(studentid);
  }

  int mapStatusToInt(String status) {
    switch (status) {
      case 'Present':
        return 1;
      case 'Absent':
        return 2;
      case 'On Leave':
        return 3;
      default:
        return -1;
    }
  }

  void fetchAttendance(int studid) async {
    try {
      Map<String, dynamic> body = {"id": studid};
      final response = await http.post(
        Uri.parse(Apiconst.getStudAttendance),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          final List<dynamic> attendanceData = data['data'];
          dateIntList.clear(); // Clear the existing data
          for (var attendance in attendanceData) {
            DateTime date = DateTime.parse(attendance['date']).toLocal();
            int status = mapStatusToInt(attendance['status']);
            dateIntList.add(MapEntry(date, status));
          }
          log(dateIntList.toString());
        } else {
          throw Exception('Data key not found in API response');
        }
      } else {
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<void> fetchEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(Apiconst.listallEvents));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          List<EventModel> fetchedEvents =
              data.map((e) => EventModel.fromJson(e)).toList();
          setState(() {
            events = fetchedEvents; // Update the events list
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

  Future<void> fetchWork(int studid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> body = {"studid": studid};
      final response = await http.post(
        Uri.parse(Apiconst.getStudentAllWork),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          List<Map<String, dynamic>> tempwork = [];
          for (var item in data) {
            if (!item['is_submited']) {
              tempwork.add({
                'id': item['id'],
                'homework_details': item['homework_details'],
                'is_submited': item['is_submited'],
                'homework_date': item['homework_date']
              });
            }
          }
          setState(() {
            work = tempwork; // Update the events list
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

  Future<void> fetchHoliday() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(Apiconst.upcomingholiday));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          final holidayData = data['data'];
          holidayName = holidayData['holiday_name'];
          holidayDate = holidayData['holiday_date'];
        } else {
          throw Exception('Data key not found in API response');
        }
      } else {
        throw Exception('Failed to fetch Holiday');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              // backgroundColor: const Color.fromARGB(255, 243, 253, 233),
              backgroundColor: MyTheme.mainbackground,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                title: Text(
                  "Homepage",
                  overflow: TextOverflow.fade,
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
                          bottom: getHeight(context, 0.007)),
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
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(getSize(context, 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                // color: MyTheme.button1,
                                width: getWidth(context, 0.5),
                                child: Row(
                                  children: [
                                    Text(
                                      "Hello, ",
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        fontSize: getSize(context, 2),
                                        color: MyTheme.button1,
                                        // rgba(201, 208, 103, 1)
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        full_name_d,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: getSize(context, 2),
                                            fontWeight: FontWeight.bold,
                                            color: MyTheme.textcolor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                // color: MyTheme.button1,
                                width: getWidth(context, 0.5),
                                child: Row(
                                  children: [
                                    Text(
                                      "Course ",
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        fontSize: getSize(context, 1.6),
                                        color: MyTheme.textcolor,
                                        // rgba(201, 208, 103, 1)
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        coursename,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: getSize(context, 1.6),
                                            fontWeight: FontWeight.bold,
                                            color: MyTheme.button1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              showFullDescriptionDialog("Upcoming Holidays",
                                  "$holidayDate - $holidayName", context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Upcoming Holidays",
                                  style: TextStyle(
                                    fontSize: getSize(context, 1.5),
                                    color: MyTheme.textcolor,
                                  ),
                                ),
                                SizedBox(
                                  width: getWidth(context, 0.25),
                                  child: Expanded(
                                    child: Text(
                                      textAlign: TextAlign.end,
                                      holidayName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: getSize(context, 1.8),
                                          color: MyTheme.textcolor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: getWidth(context, 0.25),
                                  child: Expanded(
                                    child: Text(
                                      holidayDate,
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: getSize(context, 1.8),
                                          color: MyTheme.textcolor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    horizontalLine(),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(getSize(context, 1.5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pending Homework",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: MyTheme.textcolor,
                                  fontSize: getSize(context, 2)),
                            ),
                            SizedBox(
                              height: getHeight(context, 0.01),
                            ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: MyTheme.boxshadow,
                            //         spreadRadius: getSize(context, 0.5),
                            //         blurRadius: getSize(context, 0.8),
                            //         offset: Offset(0, getSize(context, 0.3)),
                            //       ),
                            //     ],
                            //     borderRadius:
                            //         BorderRadius.circular(getSize(context, 1)),
                            //     color: MyTheme.background,
                            //   ),
                            //   // height: getHeight(context, 0.12),
                            //   width: getWidth(context, 1),
                            //   child: InkWell(
                            //     onTap: () {
                            //       showFullDescriptionDialog(
                            //           "Work", workinfo, context);
                            //     },
                            //     child: Padding(
                            //       padding:
                            //           EdgeInsets.all(getSize(context, 0.8)),
                            //       child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Container(
                            //             // color: MyTheme.button1,
                            //             width: getWidth(context, 0.5),
                            //             child: Row(
                            //               children: [
                            //                 Text(
                            //                   "Till :- ",
                            //                   overflow: TextOverflow.fade,
                            //                   style: TextStyle(
                            //                     fontSize: getSize(context, 2.1),
                            //                     color: MyTheme.textcolor,
                            //                     // rgba(201, 208, 103, 1)
                            //                   ),
                            //                 ),
                            //                 Expanded(
                            //                   child: Text(
                            //                     "2/2/24",
                            //                     overflow: TextOverflow.ellipsis,
                            //                     style: TextStyle(
                            //                         fontSize:
                            //                             getSize(context, 2.1),
                            //                         fontWeight: FontWeight.bold,
                            //                         color: MyTheme.button1),
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //           SizedBox(
                            //             height: getHeight(context, 0.02),
                            //           ),
                            //           Text(
                            //             truncateDescription(
                            //               workinfo,
                            //               15,
                            //             ),
                            //             style: TextStyle(
                            //                 color: MyTheme.textcolor,
                            //                 fontSize: getSize(context, 2)),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // )
                            SizedBox(
                              height: getHeight(context, 0.14),
                              child: work.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No homework pending, Enjoy your day",
                                        style: TextStyle(
                                            color: MyTheme.textcolor,
                                            fontSize: getSize(context, 2)),
                                      ),
                                    )
                                  : ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                        work.length,
                                        (index) => InkWell(
                                          onTap: () {
                                            showFullDescriptionDialog(
                                                "Work",
                                                work[index]['homework_details'],
                                                context);
                                          },
                                          child: SizedBox(
                                            width: getWidth(context, 0.9),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  getSize(context, 1.5)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              MyTheme.boxshadow,
                                                          spreadRadius: getSize(
                                                              context, 0.5),
                                                          blurRadius: getSize(
                                                              context, 0.8),
                                                          offset: Offset(
                                                              0,
                                                              getSize(context,
                                                                  0.3)),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              getSize(
                                                                  context, 1)),
                                                      color: MyTheme.background,
                                                    ),
                                                    width: getWidth(context, 1),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          getSize(
                                                              context, 0.8)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: getWidth(
                                                                context, 0.5),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Date: ",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        getSize(
                                                                            context,
                                                                            1.6),
                                                                    color: MyTheme
                                                                        .textcolor,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    work[index][
                                                                        'homework_date'],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize: getSize(
                                                                            context,
                                                                            1.6),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: MyTheme
                                                                            .button1),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                context, 0.02),
                                                          ),
                                                          Text(
                                                            truncateDescription(
                                                              work[index][
                                                                  'homework_details'],
                                                              6,
                                                            ),
                                                            style: TextStyle(
                                                              color: MyTheme
                                                                  .textcolor,
                                                              fontSize: getSize(
                                                                  context, 2),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    horizontalLine(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: getHeight(context, 0.02),
                          left: getWidth(context, 0.02)),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Upcoming events",
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: MyTheme.textcolor,
                                  fontSize: getSize(context, 2)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: getWidth(context, 0.02)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const StShowEvents(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: MyTheme.mainbutton,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: MyTheme.mainbuttontext
                                              .withOpacity(0.6))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: getWidth(context, 0.02),
                                        right: getWidth(context, 0.02),
                                        top: 7,
                                        bottom: 7),
                                    child: Text(
                                      "More info",
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          color: MyTheme.mainbuttontext,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          events.length,
                          (index) => InkWell(
                            onTap: () {
                              showFullDescriptionDialog("Event",
                                  events[index].event_description, context);
                            },
                            child: SizedBox(
                              width: getWidth(context, 0.8),
                              child: Padding(
                                padding: EdgeInsets.all(getSize(context, 1.5)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: MyTheme.boxshadow,
                                            spreadRadius: getSize(context, 0.5),
                                            blurRadius: getSize(context, 0.8),
                                            offset: Offset(
                                                0, getSize(context, 0.3)),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(
                                            getSize(context, 1)),
                                        color: MyTheme.background,
                                      ),
                                      width: getWidth(context, 1),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            getSize(context, 0.8)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              // color: MyTheme.button1,
                                              width: getWidth(context, 0.5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Date: ",
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      fontSize:
                                                          getSize(context, 1.6),
                                                      color: MyTheme.textcolor,
                                                      // rgba(201, 208, 103, 1)
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      events[index].event_date,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: getSize(
                                                              context, 1.6),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              MyTheme.button1),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: getHeight(context, 0.02),
                                            ),
                                            Text(
                                              truncateDescription(
                                                events[index].event_description,
                                                6,
                                              ),
                                              style: TextStyle(
                                                color: MyTheme.textcolor,
                                                fontSize: getSize(context, 2),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    horizontalLine(),
                    SizedBox(
                      height: getHeight(context, 0.012),
                    ),
                    showAttendance("Your Attendance", context, dateIntList),
                    SizedBox(
                      height: getHeight(context, 0.012),
                    ),
                    // horizontalLine(),
                    // showAttendance("Your Attendance", context, dateIntList),
                  ],
                ),
              )),
    );
  }

  String truncateDescription(String description, int maxWords) {
    List<String> words = description.split(' ');
    if (words.length > maxWords) {
      return words.sublist(0, maxWords).join(' ') + '...';
    } else {
      return description;
    }
  }
}
