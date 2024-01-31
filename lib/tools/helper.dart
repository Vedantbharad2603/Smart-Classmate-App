import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:smartclassmate/tools/theme.dart';

double getHeight(context, double i) {
  double result = MediaQuery.of(context).size.height * i;
  return result;
}

double getWidth(context, double i) {
  double result = MediaQuery.of(context).size.width * i;
  return result;
}

double getSize(context, double i) {
  double result = MediaQuery.of(context).size.width * i / 50;
  return result;
}

Widget horizontalLine() {
  return SizedBox(
    height: 1,
    width: double.infinity,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: MyTheme.highlightcolor,
      ),
    ),
  );
}

Widget moreOptions(
    List<String> optionNames, List<void Function()> onClickEvents) {
  return PopupMenuButton<String>(
    color: MyTheme.background,
    onSelected: (value) {
      // Handle the selected option
      // You can add different cases based on the value
      // For example, you can open a dialog, navigate to another page, etc.
      for (int i = 0; i < optionNames.length; i++) {
        if (value == optionNames[i]) {
          onClickEvents[i]();
          break;
        }
      }
    },
    itemBuilder: (BuildContext context) {
      List<PopupMenuEntry<String>> items = [];
      for (String option in optionNames) {
        items.add(
          PopupMenuItem<String>(
            value: option,
            child: Text(option),
            textStyle: TextStyle(color: MyTheme.textcolor),
          ),
        );
      }
      return items;
    },
    child: Icon(
      Icons.more_vert,
      color: MyTheme.button1,
    ),
  );
}

Future<void> showFullDescriptionDialog(String fullDescription, context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: MyTheme.background,
        title: Text(
          "Work",
          style: TextStyle(color: MyTheme.highlightcolor),
        ),
        content: Text(
          fullDescription,
          style: TextStyle(color: MyTheme.textcolor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text(
              "OK",
              style: TextStyle(color: MyTheme.button2),
            ),
          ),
        ],
      );
    },
  );
}

Widget showAttendance(
    String boxtitle, context, List<MapEntry<DateTime, int>> dateIntList) {
  return Padding(
    padding: EdgeInsets.all(getSize(context, 1)),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(getSize(context, 1)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: getHeight(context, 0.02),
          ),
          Row(
            children: [
              Icon(Icons.arrow_right_outlined,
                  size: getSize(context, 4), color: MyTheme.textcolor),
              Text(
                boxtitle,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getSize(context, 2.7),
                    color: MyTheme.textcolor),
              ),
            ],
          ),
          Center(
            child: HeatMapCalendar(
              monthFontSize: getSize(context, 3.7),
              weekTextColor: MyTheme.textcolor,
              textColor: MyTheme.background,
              iconcolor: MyTheme.button1,
              colorTipSize: 0,
              defaultColor: Colors.grey,
              flexible: false,
              monarrowsize: getSize(context, 3.7),
              size: getSize(context, 4.8),
              moncolor: MyTheme.textcolor,
              colorMode: ColorMode.color,
              datasets: Map.fromEntries(dateIntList),
              colorsets: const {
                0: Colors.red,
                1: Colors.green,
                2: Colors.orange,
              },
              onClick: (value) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text(value.toString())));
              },
            ),
          ),
          SizedBox(
            height: getHeight(context, 0.01),
          ),
          SizedBox(
            height: getHeight(context, 0.002),
            child: Container(
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: getHeight(context, 0.01),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Container(
                    height: getHeight(context, 0.029),
                    width: getHeight(context, 0.029),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius:
                            BorderRadius.circular(getSize(context, 0.6))),
                  ),
                  SizedBox(
                    width: getWidth(context, 0.02),
                  ),
                  Text(
                    "Absent",
                    style: TextStyle(
                        fontSize: getSize(context, 1.8),
                        color: MyTheme.textcolor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    height: getHeight(context, 0.029),
                    width: getHeight(context, 0.029),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            BorderRadius.circular(getSize(context, 0.6))),
                  ),
                  SizedBox(
                    width: getWidth(context, 0.02),
                  ),
                  Text(
                    "Present",
                    style: TextStyle(
                        fontSize: getSize(context, 1.8),
                        color: MyTheme.textcolor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    height: getHeight(context, 0.029),
                    width: getHeight(context, 0.029),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius:
                            BorderRadius.circular(getSize(context, 0.6))),
                  ),
                  SizedBox(
                    width: getWidth(context, 0.02),
                  ),
                  Text(
                    "On Leave",
                    style: TextStyle(
                        fontSize: getSize(context, 1.8),
                        color: MyTheme.textcolor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: getWidth(context, 0.025),
          ),
        ],
      ),
    ),
  );
}
