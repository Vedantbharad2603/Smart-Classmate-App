// ignore_for_file: file_names
// ignore_for_file: use_build_context_synchronously, prefer_final_fields, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConceptsPage extends StatefulWidget {
  final int courseid;
  final String courseName;
  final int? levelid;
  final String? courseLevelName;

  const ConceptsPage(
      {Key? key,
      required this.courseid,
      required this.courseName,
      this.levelid,
      this.courseLevelName})
      : super(key: key);

  @override
  _ConceptsPageState createState() => _ConceptsPageState();
}

class _ConceptsPageState extends State<ConceptsPage> {
  TextEditingController _conceptController = TextEditingController();
  String? _selectedConcept;
  int? _selectedConceptid;

  List<Map<String, dynamic>> concepts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCourses();
    // Create a copy of the concepts list to make it modifiable
    // _editableConcepts.addAll(widget.concepts);
  }

  Future<bool> updateDetails(int idin, String cName) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> body = {"id": idin, "concept_name": cName};
    try {
      http.Response response = await http.put(
        Uri.parse(
            Apiconst.updateConcepts), // Use the correct endpoint for updating
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text("Name updated"),
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
        fetchCourses();
      });
    }
  }

  Future<void> fetchCourses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> body;
      if (widget.levelid != null) {
        body = {"courseLevelId": widget.levelid, "courseId": widget.courseid};
      } else {
        body = {"courseId": widget.courseid};
      }
      // Map<String, int> body = {'courseId': id};
      final response = await http.post(
        Uri.parse(Apiconst.getConcepts),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          concepts.clear();
          concepts.addAll(data.map((e) => e as Map<String, dynamic>).toList());
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

  Future<void> addConcepts(String cName) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> body;
      if (widget.levelid != null) {
        body = {
          "concept_name": cName,
          "courseLevelId": widget.levelid,
          "courseId": widget.courseid
        };
      } else {
        body = {"concept_name": cName, "courseId": widget.courseid};
      }
      final response = await http.post(
        Uri.parse(Apiconst.addCourseConcepts),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        // Show success popup
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Course Concept added successfully'),
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
      } else {
        throw Exception('Failed to add Course level');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to add Course Concepts: $e'),
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
    } finally {
      setState(() {
        _isLoading = false;
        // fetchCourses(widget.courseid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                title: Text(
                  widget.courseLevelName ?? widget.courseName,
                  style: TextStyle(color: MyTheme.textcolor),
                ),
              ),
              body: ListView.builder(
                itemCount: concepts.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> concept = concepts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedConcept = concept["concept_name"];
                          _selectedConceptid = concept["id"];
                        });
                        _showConceptOptions(context);
                      },
                      child: Card(
                        color: MyTheme.background,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            concept['concept_name'],
                            style: TextStyle(
                                color: MyTheme.textcolor, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
            "Add Concept",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: TextField(
            style: TextStyle(color: MyTheme.textcolor),
            controller: _conceptController,
            decoration: InputDecoration(
                labelText: 'Concept Name',
                labelStyle: TextStyle(color: MyTheme.textcolor)),
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
                addConcepts(_conceptController.text);
                // String newConcept = _conceptController.text;
                // setState(() {
                //   _editableConcepts.add(newConcept);
                // });
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

  void _showConceptOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: MyTheme.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: MyTheme.button1,
                ),
                title: Text(
                  'Edit Concept',
                  style: TextStyle(color: MyTheme.textcolor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showEditConceptDialog(context, _selectedConcept!);
                },
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.upload_file,
              //     color: MyTheme.button1,
              //   ),
              //   title: Text(
              //     'Upload PDF',
              //     style: TextStyle(color: MyTheme.textcolor),
              //   ),
              //   onTap: () {
              //     // Implement PDF upload logic here
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  void _showEditConceptDialog(BuildContext context, String concept) {
    _conceptController.text = concept;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text(
            "Edit Concept",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: TextField(
            style: TextStyle(color: MyTheme.textcolor),
            controller: _conceptController,
            decoration: InputDecoration(
              labelText: 'Concept Name',
              labelStyle: TextStyle(color: MyTheme.textcolor),
            ),
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
                updateDetails(_selectedConceptid!, _conceptController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                "Save",
                style: TextStyle(color: MyTheme.button1),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _conceptController.dispose();
    super.dispose();
  }
}
