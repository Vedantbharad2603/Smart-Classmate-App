import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class ManageTeacher extends StatefulWidget {
  const ManageTeacher({super.key});

  @override
  State<ManageTeacher> createState() => _ManageTeacherState();
}

class _ManageTeacherState extends State<ManageTeacher> {
  List<Map<String, dynamic>> teacherData = [
    {'teachername': 'Vedant', 'type': 'Admin', 'isActive': true},
    {'teachername': 'Jhanvi', 'type': 'Admin', 'isActive': true},
    {'teachername': 'VirenBhai', 'type': 'Teacher', 'isActive': true},
    {'teachername': 'Om', 'type': 'Trainee', 'isActive': true},
    {'teachername': 'Dhaivat', 'type': 'Trainee', 'isActive': true},
  ];

  List<int> shiftTypes = [1, 2];
  String searchText = '';
  late int selectedShift;

  @override
  void initState() {
    super.initState();
    teacherData.sort((a, b) => a['teachername'].compareTo(b['teachername']));
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

  void deleteTeacher(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text(
            "Confirm Deletion",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: Text(
            "Are you sure you want to delete this teacher?",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.green.withOpacity(0.7)),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  teacherData.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red.withOpacity(0.7)),
              ),
            ),
          ],
        );
      },
    );
  }

  void toggleActiveStatus(int index) {
    setState(() {
      teacherData[index]['isActive'] = !teacherData[index]['isActive'];
    });
  }

  void changeRole(int index, String newRole) {
    setState(() {
      teacherData[index]['type'] = newRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTeachers = teacherData
        .where((teacher) => teacher['teachername']
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.mainbackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Teacher Management',
            style: TextStyle(
                color: MyTheme.textcolor,
                fontSize: getSize(context, 2.8),
                fontWeight: FontWeight.bold),
          ),
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
                    labelText: 'Search Teacher',
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
                    itemCount: filteredTeachers.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> teacher = filteredTeachers[index];
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
                                            teacher['teachername'],
                                            style: TextStyle(
                                              fontSize: getSize(context, 2.7),
                                              fontWeight: FontWeight.bold,
                                              color: MyTheme.textcolor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: getHeight(context, 0.001),
                                          ),
                                          Text(
                                            teacher['type'],
                                            style: TextStyle(
                                              fontSize: getSize(context, 1.7),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () => deleteTeacher(index),
                                    icon: Icon(Icons.delete_outline),
                                    color: Colors.red,
                                  ),
                                  ElevatedButton(
                                    onPressed: () => toggleActiveStatus(index),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.disabled)) {
                                            return Colors
                                                .grey; // Disabled color
                                          }
                                          return teacher['isActive']
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.green.withOpacity(0.2);
                                        },
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: BorderSide(
                                            color: teacher['isActive']
                                                ? Colors.red.withOpacity(0.7)
                                                : Colors.green.withOpacity(0.7),
                                            width: getWidth(context, 0.005),
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Text(teacher['isActive']
                                        ? "Deactivate"
                                        : "Activate"),
                                  ),
                                  DropdownButton<String>(
                                    style: TextStyle(color: MyTheme.textcolor),
                                    dropdownColor: MyTheme.background,
                                    value: teacher['type'],
                                    onChanged: (newValue) =>
                                        changeRole(index, newValue!),
                                    items: <String>[
                                      'Admin',
                                      'Teacher',
                                      'Trainee'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
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

  Widget buildmainDropdown(String selectedValue, Function(String?) onChanged,
      context, List<String> types) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(height * 0.011),
      child: Container(
        padding: EdgeInsets.only(left: height * 0.016, right: height * 0.016),
        decoration: BoxDecoration(
          color: MyTheme.background,
          borderRadius: BorderRadius.circular(height * 0.02),
        ),
        child: DropdownButton<String>(
          dropdownColor: MyTheme.background,
          value: selectedValue,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          iconSize: height * 0.04,
          isExpanded: true,
          underline: const SizedBox(),
          style: TextStyle(color: MyTheme.textcolor, fontSize: height * 0.018),
          items: types.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
