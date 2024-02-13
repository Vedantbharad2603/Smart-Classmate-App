// ignore: file_names
import 'package:flutter/material.dart';
import 'package:smartclassmate/Teacher_Screen/StudentInfo.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class SearchStudent extends StatefulWidget {
  const SearchStudent({Key? key}) : super(key: key);

  @override
  State<SearchStudent> createState() => _SearchStudentState();
}

class _SearchStudentState extends State<SearchStudent> {
  List<Map<String, dynamic>> studentData = [
    {
      'studentname': 'Vedant020124',
      'name': 'Vedant',
      'course': 'Advance',
      'shift': 1
    },
    {
      'studentname': 'Jhanvi020124',
      'name': 'Jhanvi',
      'course': 'Basic',
      'shift': 1
    },
    {
      'studentname': 'VirenBhai020124',
      'name': 'VirenBhai',
      'course': 'Advance',
      'shift': 2
    },
    {'studentname': 'Om020124', 'name': 'Om', 'course': 'Advance', 'shift': 2},
    {
      'studentname': 'Dhaivat020124',
      'name': 'Dhaivat',
      'course': 'Advance',
      'shift': 2
    },
  ];

  List<int> shiftTypes = [1, 2];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    studentData.sort((a, b) => a['name'].compareTo(b['name']));
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredStudents = studentData
        .where((student) => student['studentname']
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    // // Sort the students based on their names
    // filteredStudents.sort((a, b) => a['studentname']
    //     .toLowerCase()
    //     .compareTo(b['studentname'].toLowerCase()));

    return SafeArea(
      child: Scaffold(
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
                giveuserinfo(
                    'Username: Vedant Bharad', 'Password: Ved@nt123', context);
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
                      Map<String, dynamic> student = filteredStudents[index];
                      return Padding(
                        padding: EdgeInsets.all(getSize(context, 0.7)),
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
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(getSize(context, 1)),
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
                                            student['name'],
                                            style: TextStyle(
                                              fontSize: getSize(context, 2.4),
                                              fontWeight: FontWeight.bold,
                                              color: MyTheme.textcolor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: getHeight(context, 0.001),
                                          ),
                                          Text(
                                            "@${student['studentname']}",
                                            style: TextStyle(
                                              fontSize: getSize(context, 1.6),
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
                                              width: getWidth(context, 0.008),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.transparent,
                                          ),
                                          height: getHeight(context, 0.050),
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      getSize(context, 1.6),
                                                  color: MyTheme.textcolor,
                                                ),
                                              ),
                                              Text(
                                                "${student['course']}",
                                                style: TextStyle(
                                                  fontSize:
                                                      getSize(context, 1.4),
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
                                      itemBuilder: (BuildContext context) {
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
                                                      student['studentname'],
                                                      7,
                                                      MyTheme.highlightcolor
                                                          .withOpacity(0.2),
                                                      MyTheme.highlightcolor
                                                          .withOpacity(0.6),
                                                      context),
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
                                                      student['studentname'],
                                                      7,
                                                      MyTheme.button1
                                                          .withOpacity(0.2),
                                                      MyTheme.button1
                                                          .withOpacity(0.8),
                                                      context),
                                                ],
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: InkWell(
                                              onTap: () {
                                                // Handle Show Profile action
                                              },
                                              child: Row(
                                                children: [
                                                  studentbutton(
                                                      () {},
                                                      "Give eBook",
                                                      student['studentname'],
                                                      7,
                                                      MyTheme.mainbutton,
                                                      MyTheme.mainbuttontext,
                                                      context),
                                                ],
                                              ),
                                            ),
                                          ),
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
}
