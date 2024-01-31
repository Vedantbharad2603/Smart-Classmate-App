import 'package:flutter/material.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:smartclassmate/tools/helper.dart';

class TeStudentCourses extends StatefulWidget {
  const TeStudentCourses({super.key});

  @override
  State<TeStudentCourses> createState() => _TeStudentCoursesState();
}

class _TeStudentCoursesState extends State<TeStudentCourses> {
  List<String> concepts = [
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
  ];

  int activeIndex = 3; // Set the active index based on your progress

  List<bool> checkedSteps =
      List.filled(19, false); // Initialize all steps as unchecked

  @override
  Widget build(BuildContext context) {
    List<StepperData> stepperData = List.generate(concepts.length, (index) {
      bool isDone = index < activeIndex;
      return StepperData(
        title: StepperText(
          concepts[index],
          textStyle: TextStyle(
            color: isDone ? Colors.black87 : Colors.grey,
            fontSize: 16.0,
            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDone ? Colors.green : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: Icon(
            isDone ? Icons.check : Icons.remove,
            color: Colors.white,
          ),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 253, 233),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
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
                  child: Text(
                    'My Courses',
                    style: TextStyle(fontSize: getSize(context, 2.8)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 75),
              child: AnotherStepper(
                stepperList: stepperData,
                stepperDirection: Axis.vertical,
                iconWidth: 40,
                iconHeight: 40,
                activeBarColor: Colors.green,
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
    );
  }
}
