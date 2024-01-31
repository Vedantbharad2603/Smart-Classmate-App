import 'package:flutter/material.dart';
import 'package:smartclassmate/Student_Screen/st_profilepage.dart';
import 'package:smartclassmate/tools/helper.dart';

class TeHomepage extends StatefulWidget {
  const TeHomepage({super.key});

  @override
  State<TeHomepage> createState() => _TeHomepageState();
}

List<MapEntry<DateTime, int>> dateIntList = [
  MapEntry(DateTime(2024, 1, 1), 0),
  MapEntry(DateTime(2024, 1, 2), 1),
  MapEntry(DateTime(2024, 1, 3), 1),
  MapEntry(DateTime(2024, 1, 4), 1),
  MapEntry(DateTime(2024, 1, 5), 2),
  MapEntry(DateTime(2024, 1, 6), 2),
  MapEntry(DateTime(2024, 1, 7), 2),
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

class _TeHomepageState extends State<TeHomepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 243, 253, 233),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text(
              "Homepage",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getSize(context, 2.7),
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.notifications_none,
              //     size: getSize(context, 3),
              //     color: Colors.black,
              //   ),
              // ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => STProfilePage(),
                  //   ),
                  // );
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      right: getSize(context, 1),
                      top: getHeight(context, 0.007),
                      bottom: getHeight(context, 0.007)),
                  child: CircleAvatar(
                    radius: getSize(context, 3),
                    backgroundColor: Color.fromARGB(255, 0, 241, 101),
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
                          RichText(
                            text: TextSpan(
                              text: 'Hello, ',
                              style: TextStyle(
                                fontSize: getSize(context, 2),
                                color: Color.fromARGB(255, 201, 208, 103),
                                // rgba(201, 208, 103, 1)
                              ),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: 'VEDANT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Course ',
                              style: TextStyle(
                                fontSize: getSize(context, 1.7),
                                color: Colors.black,
                              ),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: 'Advance',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
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
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Ram Lalla Pran Prathishtha",
                            style: TextStyle(
                                fontSize: getSize(context, 2),
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "21-01-2023",
                            style: TextStyle(
                                fontSize: getSize(context, 2),
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getSize(context, 2)),
                        ),
                        SizedBox(
                          height: getHeight(context, 0.01),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: getSize(context, 0.5),
                                blurRadius: getSize(context, 0.8),
                                offset: Offset(0, getSize(context, 0.3)),
                              ),
                            ],
                            borderRadius:
                                BorderRadius.circular(getSize(context, 1)),
                            color: Colors.white,
                          ),
                          // height: getHeight(context, 0.12),
                          width: getWidth(context, 1),
                          child: Padding(
                            padding: EdgeInsets.all(getSize(context, 0.8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Till :- ',
                                    style: TextStyle(
                                      fontSize: getSize(context, 2),
                                      color: Colors.black,
                                    ),
                                    children: const <TextSpan>[
                                      TextSpan(
                                        text: '2/2/24',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: getHeight(context, 0.02),
                                ),
                                Text(
                                  truncateDescription(
                                    "Complete 30 Wh quesitions,30 affirmative sentence and 30 negative sentences Complete 30 Wh quesitions,30 affirmative sentence and 30 negative sentences",
                                    15,
                                  ),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getSize(context, 2)),
                                ),
                              ],
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
                    child: Text(
                      "Upcoming events",
                      style: TextStyle(
                          color: Colors.black, fontSize: getSize(context, 2)),
                    ),
                  ),
                ),
                Container(
                  height: getHeight(context, 0.14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      upcomingEvents.length,
                      (index) => SizedBox(
                        width: getWidth(context, 0.8), // Adjust width as needed
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
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: getSize(context, 0.5),
                                      blurRadius: getSize(context, 0.8),
                                      offset: Offset(0, getSize(context, 0.3)),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(
                                      getSize(context, 1)),
                                  color: Colors.white,
                                ),
                                width: getWidth(context, 1),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(getSize(context, 0.8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Date: ',
                                          style: TextStyle(
                                            fontSize: getSize(context, 2),
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: upcomingEvents[index]
                                                  ['date'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: getHeight(context, 0.02),
                                      ),
                                      Text(
                                        truncateDescription(
                                          upcomingEvents[index]['description'],
                                          6,
                                        ),
                                        style: TextStyle(
                                          color: Colors.black,
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
                horizontalLine(),
                showAttendance("Your Attendance", context, dateIntList),
                horizontalLine(),
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
