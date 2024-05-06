// ignore: file_names
import 'package:flutter/material.dart';
import 'package:smartclassmate/Teacher_Screen/ConceptsPage.dart';
import 'package:smartclassmate/Teacher_Screen/CourseLevel.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ManageCourse extends StatefulWidget {
  const ManageCourse({Key? key}) : super(key: key);

  @override
  State<ManageCourse> createState() => _ManageCourseState();
}

class _ManageCourseState extends State<ManageCourse> {
  TextEditingController _courseController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  Rx<bool> _hasLevels = true.obs;
  TextEditingController _editcourseController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> CourseData = [];

  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchCourses();
    CourseData.sort((a, b) => a['course_name'].compareTo(b['course_name']));
  }

  Future<void> addCourses(String cName, bool level, int months) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> body = {
        "course_name": cName,
        "has_levels": level,
        "time_duration": months,
      };
      final response = await http.post(
        Uri.parse(Apiconst.addCourses),
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
              content: Text('Course added successfully'),
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
        setState(() {
          fetchCourses();
        });
      } else {
        throw Exception('Failed to add Course');
      }
    } catch (e) {
      // Show error popup
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add Course: $e'),
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
      });
    }
  }

  Future<void> fetchCourses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(Apiconst.getCourses));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          CourseData.clear();
          CourseData.addAll(
              data.map((e) => e as Map<String, dynamic>).toList());
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

  Future<bool> updateDetails(
      int idin, String cName, bool hasLevelstemp, int duration) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> body = {
      "id": idin,
      "course_name": cName,
      "has_levels": hasLevelstemp,
      "time_duration": duration,
    };
    try {
      http.Response response = await http.put(
        Uri.parse(
            Apiconst.updateCourse), // Use the correct endpoint for updating
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text("Details updated"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Fail'),
              content: const Text("Somthing wrong while updating"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return false;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fail'),
            content: const Text("Somthing wrong while updating"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    } finally {
      setState(() {
        _isLoading = false;
        _editcourseController.text = "";
        fetchCourses();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredcouress = CourseData.where((coures) =>
        coures['course_name']
            .toLowerCase()
            .contains(searchText.toLowerCase())).toList();

    // // Sort the couress based on their names
    // filteredcouress.sort((a, b) => a['couresname']
    //     .toLowerCase()
    //     .compareTo(b['couresname'].toLowerCase()));

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
                title: Text('Manage Course',
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
                            Map<String, dynamic> coures =
                                filteredcouress[index];
                            return InkWell(
                              onTap: () {
                                String courseName = coures['course_name'];
                                bool hasLevel = coures['has_levels'];

                                if (hasLevel) {
                                  // CourseLevel
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CourseLevel(
                                          courseid: coures['id'],
                                          courseName: courseName),
                                    ),
                                  );
                                } else {
                                  // ConceptsPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConceptsPage(
                                          courseid: coures['id'],
                                          courseName: courseName),
                                    ),
                                  );
                                }
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
                                            EdgeInsets.all(getSize(context, 1)),
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
                                                    coures['course_name'],
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
                                            IconButton(
                                                onPressed: () {
                                                  _showEditConceptDialog(
                                                      context,
                                                      coures['course_name'],
                                                      coures['id'],
                                                      coures['time_duration'],
                                                      coures['has_levels']);
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: MyTheme.button1,
                                                ))
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
            "Add Course",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: MyTheme.textcolor),
                controller: _courseController,
                decoration: InputDecoration(
                    labelText: 'Course Name',
                    labelStyle: TextStyle(color: MyTheme.textcolor)),
              ),
              TextField(
                style: TextStyle(color: MyTheme.textcolor),
                controller: _monthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Duration (Months)',
                    labelStyle: TextStyle(color: MyTheme.textcolor)),
              ),
              Row(
                children: [
                  Text(
                    'Has Levels:',
                    style: TextStyle(color: MyTheme.textcolor),
                  ),
                  Obx(
                    () => Radio(
                      value: true,
                      groupValue: _hasLevels.value,
                      onChanged: (value) {
                        setState(() {
                          _hasLevels.value = true;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Yes',
                    style: TextStyle(color: MyTheme.textcolor),
                  ),
                  Obx(
                    () => Radio(
                      value: false,
                      groupValue: _hasLevels.value,
                      onChanged: (value) {
                        setState(() {
                          _hasLevels.value = false;
                        });
                      },
                    ),
                  ),
                  Text(
                    'No',
                    style: TextStyle(color: MyTheme.textcolor),
                  ),
                ],
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
                String courseName = _courseController.text;
                String monthText = _monthController.text;
                int duration = int.tryParse(monthText) ?? 0;

                if (courseName.isNotEmpty && monthText.isNotEmpty) {
                  bool hasLevels = _hasLevels.value;
                  addCourses(courseName, hasLevels, duration);
                  setState(() {
                    fetchCourses();
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill in all fields.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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

  void _showEditConceptDialog(BuildContext context, String mycourse,
      int courseid, int timeDuration, bool haslevelsin) {
    _courseController.text = mycourse;
    _monthController.text = timeDuration.toString();
    _hasLevels.value = haslevelsin;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text(
            "Add Course",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: MyTheme.textcolor),
                controller: _courseController,
                decoration: InputDecoration(
                    labelText: 'Course Name',
                    labelStyle: TextStyle(color: MyTheme.textcolor)),
              ),
              TextField(
                style: TextStyle(color: MyTheme.textcolor),
                controller: _monthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Duration (Months)',
                    labelStyle: TextStyle(color: MyTheme.textcolor)),
              ),
              Row(
                children: [
                  Text(
                    'Has Levels:',
                    style: TextStyle(color: MyTheme.textcolor),
                  ),
                  Obx(
                    () => Radio(
                      value: true,
                      groupValue: _hasLevels.value,
                      onChanged: (value) {
                        setState(() {
                          _hasLevels.value = true;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Yes',
                    style: TextStyle(color: MyTheme.textcolor),
                  ),
                  Obx(
                    () => Radio(
                      value: false,
                      groupValue: _hasLevels.value,
                      onChanged: (value) {
                        setState(() {
                          _hasLevels.value = false;
                        });
                      },
                    ),
                  ),
                  Text(
                    'No',
                    style: TextStyle(color: MyTheme.textcolor),
                  ),
                ],
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
                String courseName = _courseController.text;
                String monthText = _monthController.text;
                int duration = int.tryParse(monthText) ?? 0;

                if (courseName.isNotEmpty && monthText.isNotEmpty) {
                  bool hasLevelstemp = _hasLevels.value;
                  updateDetails(courseid, courseName, hasLevelstemp, duration);
                  setState(() {
                    fetchCourses();
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill in all fields.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                "Update",
                style: TextStyle(color: MyTheme.button1),
              ),
            ),
          ],
        );
      },
    );
  }
}
