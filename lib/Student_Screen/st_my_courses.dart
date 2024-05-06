import 'package:flutter/material.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StMyCourses extends StatefulWidget {
  final int courseid;
  final int levelid;
  final int cstatus;

  const StMyCourses(
      {Key? key,
      required this.courseid,
      required this.levelid,
      required this.cstatus})
      : super(key: key);

  @override
  State<StMyCourses> createState() => _StMyCoursesState();
}

class _StMyCoursesState extends State<StMyCourses> {
  List<String> concepts = [
    // "Writing-CP_SM",
    // "Writing-Address",
    // "Vocab",
    // "Noun",
    // "Capital letters",
    // "C/U",
    // "Sin/Plu",
    // "Possessive",
    // "Test",
    // "Opp",
    // "Adj",
    // "c.ofAdj",
    // "Gender",
    // "Pronouns",
    // "Articles",
    // "There is/are",
    // "Test sec-2",
    // "File given & Spiral"
  ];
  int activeIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCourses();
    activeIndex = widget.cstatus;
    // Create a copy of the concepts list to make it modifiable
    // _editableConcepts.addAll(widget.concepts);
  }

  Future<void> fetchCourses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> body;
      if (widget.levelid != 0) {
        body = {
          "course_level_id": widget.levelid,
          "course_id": widget.courseid
        };
      } else {
        body = {"course_id": widget.courseid};
      }
      // Map<String, int> body = {'course_id': id};
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
          concepts
              .addAll(data.map((e) => e['concept_name'] as String).toList());
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

  @override
  Widget build(BuildContext context) {
    List<StepperData> stepperData = List.generate(concepts.length, (index) {
      bool isDone = index < activeIndex;
      return StepperData(
        title: StepperText(
          concepts[index],
          textStyle: TextStyle(
            color:
                isDone ? MyTheme.textcolor : MyTheme.textcolor.withOpacity(0.4),
            fontSize: getSize(context, 2),
            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDone ? MyTheme.highlightcolor : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: Icon(
            isDone ? Icons.check : Icons.remove,
            color: MyTheme.background,
          ),
        ),
      );
    }).toList();

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
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: SizedBox(
                            width: getWidth(context, 0.8),
                            child: Expanded(
                              child: Text(
                                'My Course',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: getSize(context, 2.8),
                                    color: MyTheme.highlightcolor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 20, right: 75),
                      child: AnotherStepper(
                        stepperList: stepperData,
                        stepperDirection: Axis.vertical,
                        iconWidth: 40,
                        iconHeight: 40,
                        activeBarColor: MyTheme.highlightcolor,
                        inActiveBarColor: Colors.grey,
                        inverted: true,
                        verticalGap: 15,
                        activeIndex: activeIndex - 1,
                        barThickness: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
