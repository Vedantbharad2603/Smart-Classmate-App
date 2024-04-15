// ignore: file_names
import 'package:flutter/material.dart';
import 'package:smartclassmate/Teacher_Screen/ConceptsPage.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseLevel extends StatefulWidget {
  final int courseid;
  final String courseName;

  const CourseLevel(
      {Key? key, required this.courseid, required this.courseName})
      : super(key: key);

  @override
  State<CourseLevel> createState() => _CourseLevelState();
}

class _CourseLevelState extends State<CourseLevel> {
  TextEditingController _levelNameController = TextEditingController();
  List<Map<String, dynamic>> courselevellist = [];

  String searchText = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCourses(widget.courseid);
    // CourseLevel.sort((a, b) => a['levelname'].compareTo(b['coursename']));
  }

  Future<void> fetchCourses(int id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, int> body = {'courseId': id};
      final response = await http.post(
        Uri.parse(Apiconst.getCourseLevels),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          courselevellist.clear();
          courselevellist
              .addAll(data.map((e) => e as Map<String, dynamic>).toList());
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

  Future<void> addCourselevel(String lName) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> body = {
        "level_name": lName,
        "courseId": widget.courseid
      };
      final response = await http.post(
        Uri.parse(Apiconst.addCourseLevels),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        // Show success popup
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Course level added successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to add Course level');
      }
    } catch (e) {
      // Show error popup
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add Course level: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
        fetchCourses(widget.courseid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredcouress = courselevellist
        .where((coures) => coures['level_name']
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    // // Sort the couress based on their names
    // filteredcouress.sort((a, b) => a['couresname']
    //     .toLowerCase()
    //     .compareTo(b['couresname'].toLowerCase()));

    return SafeArea(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
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
                title: Text(widget.courseName,
                    style: TextStyle(color: MyTheme.textcolor)),
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
                          labelText: 'Search Course Level',
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
                            Map<String, dynamic> coures =
                                filteredcouress[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ConceptsPage(
                                              courseid: coures['id'],
                                              courseName: widget.courseName,
                                              levelid: coures['id'],
                                              courseLevelName:
                                                  coures['level_name'],
                                            )));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(getSize(context, 0.7)),
                                child: Container(
                                  // height: getHeight(context, 0.08),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        getSize(context, 1)),
                                    color: MyTheme.background,
                                    boxShadow: [
                                      BoxShadow(
                                        color: MyTheme.boxshadow,
                                        spreadRadius: getSize(context, 0.5),
                                        blurRadius: getSize(context, 0.8),
                                        offset:
                                            Offset(0, getSize(context, 0.3)),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.all(getSize(context, 2)),
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
                                                    coures['level_name'],
                                                    style: TextStyle(
                                                      fontSize:
                                                          getSize(context, 2.4),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: MyTheme.textcolor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            // PopupMenuButton(
                                            //   color: MyTheme.background2,
                                            //   icon: Icon(Icons.more_vert,
                                            //       color: MyTheme.textcolor),
                                            //   itemBuilder:
                                            //       (BuildContext context) {
                                            //     return [
                                            //       PopupMenuItem(
                                            //         child: InkWell(
                                            //           onTap: () {
                                            //             // Handle Give Work action
                                            //           },
                                            //           child: Row(
                                            //             children: [
                                            //               GestureDetector(
                                            //                 onTap: () {
                                            //                   // String courseName = coures[
                                            //                   //     'levelname']; // Assuming 'coures' is your course object

                                            //                   //             concepts: const [
                                            //                   //           "Writing-CP_SM",
                                            //                   //           "Writing-Address",
                                            //                   //           "Vocab",
                                            //                   //           "Noun",
                                            //                   //           "Capital letters",
                                            //                   //           "C/U",
                                            //                   //           "Sin/Plu",
                                            //                   //           "Possessive",
                                            //                   //           "Test",
                                            //                   //           "Opp",
                                            //                   //           "Adj",
                                            //                   //           "c.ofAdj",
                                            //                   //           "Gender",
                                            //                   //           "Pronouns",
                                            //                   //           "Articles",
                                            //                   //           "There is/are",
                                            //                   //           "Test sec-2",
                                            //                   //           "File given & Spiral"
                                            //                   //         ]),
                                            //                   //   ),
                                            //                   // );
                                            //                 },
                                            //                 child: Container(
                                            //                   decoration:
                                            //                       BoxDecoration(
                                            //                     border:
                                            //                         Border.all(
                                            //                       color: MyTheme
                                            //                           .highlightcolor
                                            //                           .withOpacity(
                                            //                               0.6),
                                            //                       width: getWidth(
                                            //                           context,
                                            //                           0.008),
                                            //                     ),
                                            //                     borderRadius:
                                            //                         BorderRadius
                                            //                             .circular(
                                            //                                 15),
                                            //                     color: MyTheme
                                            //                         .highlightcolor
                                            //                         .withOpacity(
                                            //                             0.2),
                                            //                   ),
                                            //                   padding:
                                            //                       const EdgeInsets
                                            //                           .symmetric(
                                            //                           vertical:
                                            //                               10,
                                            //                           horizontal:
                                            //                               10),
                                            //                   child: Text(
                                            //                     "Edit Course",
                                            //                     style:
                                            //                         TextStyle(
                                            //                       color: MyTheme
                                            //                           .textcolor,
                                            //                       fontSize:
                                            //                           getSize(
                                            //                               context,
                                            //                               1.8),
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .bold,
                                            //                     ),
                                            //                   ),
                                            //                 ),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       //add active course and deactive course button
                                            //     ];
                                            //   },
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
              floatingActionButton: FloatingActionButton(
                backgroundColor: MyTheme.mainbutton,
                onPressed: () {
                  _showAddConceptDialog(context);
                },
                child: Icon(Icons.add, color: MyTheme.mainbuttontext),
              ),
            ),
    );
  }

  void _showAddConceptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text(
            "Add Level",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: MyTheme.textcolor),
                controller: _levelNameController,
                decoration: InputDecoration(
                    labelText: 'Course Level Name',
                    labelStyle: TextStyle(color: MyTheme.textcolor)),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: MyTheme.button2),
              ),
            ),
            TextButton(
              onPressed: () {
                addCourselevel(_levelNameController.text);
                _levelNameController.text = "";
                // Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                "Add",
                style: TextStyle(color: MyTheme.button1),
              ),
            ),
          ],
        );
      },
    );
  }
}
