// ignore: file_names
import 'package:flutter/material.dart';
import 'package:smartclassmate/Teacher_Screen/ConceptsPage.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class CourseLevel extends StatefulWidget {
  final String courseName;

  const CourseLevel({Key? key, required this.courseName}) : super(key: key);

  @override
  State<CourseLevel> createState() => _CourseLevelState();
}

class _CourseLevelState extends State<CourseLevel> {
  List<Map<String, dynamic>> CourseData = [
    {
      'levelname': 'level 0',
    },
    {
      'levelname': 'level 1',
    },
    {
      'levelname': 'level 2',
    },
    {
      'levelname': 'level 3',
    },
  ];

  List<int> shiftTypes = [1, 2];
  String searchText = '';
  late int selectedShift;

  @override
  void initState() {
    super.initState();
    // CourseData.sort((a, b) => a['levelname'].compareTo(b['coursename']));
    selectedShift = _getCurrentShift();
  }

  int _getCurrentShift() {
    DateTime now = DateTime.now();
    if (now.hour >= 6 && now.hour < 12) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredcouress = CourseData.where((coures) =>
        coures['levelname']
            .toLowerCase()
            .contains(searchText.toLowerCase())).toList();

    // // Sort the couress based on their names
    // filteredcouress.sort((a, b) => a['couresname']
    //     .toLowerCase()
    //     .compareTo(b['couresname'].toLowerCase()));

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
              Text('Manage Level', style: TextStyle(color: MyTheme.textcolor)),
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
                    labelText: 'Search Course',
                    labelStyle: TextStyle(color: MyTheme.textcolor),
                    suffixIcon: Icon(
                      Icons.search,
                      color: MyTheme.textcolor,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: getHeight(context, 0.75),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredcouress.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> coures = filteredcouress[index];
                      return Padding(
                        padding: EdgeInsets.all(getSize(context, 0.7)),
                        child: Container(
                          // height: getHeight(context, 0.08),
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
                                            coures['levelname'],
                                            style: TextStyle(
                                              fontSize: getSize(context, 2.4),
                                              fontWeight: FontWeight.bold,
                                              color: MyTheme.textcolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
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
                                                  GestureDetector(
                                                    onTap: () {
                                                      String courseName = coures[
                                                          'levelname']; // Assuming 'coures' is your course object
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConceptsPage(
                                                                  concepts: const [
                                                                "Writing-CP_SM",
                                                                "Writing-Address",
                                                                "Vocab",
                                                                "Noun",
                                                                "Capital letters",
                                                                "C/U",
                                                                "Sin/Plu",
                                                                "Possessive",
                                                                "Test",
                                                                "Opp",
                                                                "Adj",
                                                                "c.ofAdj",
                                                                "Gender",
                                                                "Pronouns",
                                                                "Articles",
                                                                "There is/are",
                                                                "Test sec-2",
                                                                "File given & Spiral"
                                                              ]),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: MyTheme
                                                              .highlightcolor
                                                              .withOpacity(0.6),
                                                          width: getWidth(
                                                              context, 0.008),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: MyTheme
                                                            .highlightcolor
                                                            .withOpacity(0.2),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                      child: Text(
                                                        "Edit Course",
                                                        style: TextStyle(
                                                          color:
                                                              MyTheme.textcolor,
                                                          fontSize: getSize(
                                                              context, 1.8),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //add active course and deactive course button
                                        ];
                                      },
                                    ),
                                  ],
                                ),
                              ),
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
