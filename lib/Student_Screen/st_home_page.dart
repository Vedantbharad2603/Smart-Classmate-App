// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
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
  MapEntry(DateTime(2024, 2, 1), 0),
  MapEntry(DateTime(2024, 2, 2), 1),
  MapEntry(DateTime(2024, 2, 3), 1),
  MapEntry(DateTime(2024, 2, 4), 1),
  MapEntry(DateTime(2024, 2, 5), 2),
  MapEntry(DateTime(2024, 2, 6), 2),
  MapEntry(DateTime(2024, 2, 7), 2),
];
List<Map<String, dynamic>> upcomingEvents = [
  {
    'title': 'Upcoming Event 1',
    'date': '2/2/24',
    'description': 'Event details for Event 1.',
  },
  {
    'title': 'Upcoming Event 2',
    'date': '6/2/24',
    'description': 'Event details for Event 2.',
  },
  {
    'title': 'Upcoming Event 3',
    'date': '12/2/24',
    'description': 'Event details for Event 3.',
  },
];
String workinfo =
    "Complete 30 Wh quesitions,30 affirmative sentence and 30 negative sentences Complete 30 Wh quesitions,30 affirmative sentence and 30 negative sentences";

class _STHomepageState extends State<STHomepage> {
  String role = "";
  String full_name_d = "";
  String username_d = "";
  String password_d = "";
  String holidayName = "";
  String holidayDate = "";
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    GetStorage storage = GetStorage();
    final mydata = storage.read('login_data');
    fetchHoliday();
    if (mydata != null) {
      full_name_d = mydata['data']['userdata']['full_name'] ?? "";
      username_d = mydata['data']['login']['username'] ?? "";
      password_d = mydata['data']['login']['password'] ?? "";
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
          print(holidayName + " " + holidayDate);
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
          ? const Center(child: CircularProgressIndicator())
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
                              Container(
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
                              Container(
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
                                        "Advance",
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
                          Column(
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
                              "Today's Homework",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: MyTheme.textcolor,
                                  fontSize: getSize(context, 2)),
                            ),
                            SizedBox(
                              height: getHeight(context, 0.01),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: MyTheme.boxshadow,
                                    spreadRadius: getSize(context, 0.5),
                                    blurRadius: getSize(context, 0.8),
                                    offset: Offset(0, getSize(context, 0.3)),
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.circular(getSize(context, 1)),
                                color: MyTheme.background,
                              ),
                              // height: getHeight(context, 0.12),
                              width: getWidth(context, 1),
                              child: InkWell(
                                onTap: () {
                                  showFullDescriptionDialog(
                                      "Work", workinfo, context);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(getSize(context, 0.8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // color: MyTheme.button1,
                                        width: getWidth(context, 0.5),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Till :- ",
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                fontSize: getSize(context, 2.1),
                                                color: MyTheme.textcolor,
                                                // rgba(201, 208, 103, 1)
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "2/2/24",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        getSize(context, 2.1),
                                                    fontWeight: FontWeight.bold,
                                                    color: MyTheme.button1),
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
                                          workinfo,
                                          15,
                                        ),
                                        style: TextStyle(
                                            color: MyTheme.textcolor,
                                            fontSize: getSize(context, 2)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
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
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const StShowEvents(),
                                  //   ),
                                  // );
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
                                        top: getHeight(context, 0.008),
                                        bottom: getHeight(context, 0.008)),
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
                    Container(
                      height: getHeight(context, 0.14),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          upcomingEvents.length,
                          (index) => InkWell(
                            onTap: () {
                              showFullDescriptionDialog(
                                  "Event",
                                  upcomingEvents[index]['description'],
                                  context);
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
                                      // height: getHeight(context, 0.1),
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
                                            Container(
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
                                                      upcomingEvents[index]
                                                          ['date'],
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
                                                upcomingEvents[index]
                                                    ['description'],
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
