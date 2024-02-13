// ignore: file_names
import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class PendingRegistration extends StatefulWidget {
  const PendingRegistration({Key? key}) : super(key: key);

  @override
  State<PendingRegistration> createState() => _PendingRegistrationState();
}

class _PendingRegistrationState extends State<PendingRegistration> {
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
          title: Text('Registration Pending',
              style: TextStyle(color: MyTheme.textcolor)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: getHeight(context, 0.85),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: studentData.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> student = studentData[index];
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
