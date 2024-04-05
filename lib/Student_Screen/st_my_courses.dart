import 'package:flutter/material.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class StMyCourses extends StatefulWidget {
  const StMyCourses({super.key});

  @override
  State<StMyCourses> createState() => _StMyCoursesState();
}

class _StMyCoursesState extends State<StMyCourses> {
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

  int activeIndex = 3;

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

    return Scaffold(
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
                        'My Courses',
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
              padding: const EdgeInsets.only(top: 5, left: 20, right: 75),
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
    );
  }
}
