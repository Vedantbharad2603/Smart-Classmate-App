// ignore: file_names
import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<Map<String, dynamic>> studentData = [
    {'studentname': 'Vedant020124', 'name': 'Vedant', 'shift': 1, 'status': -1},
    {'studentname': 'Jhanvi020124', 'name': 'Jhanvi', 'shift': 1, 'status': -1},
    {
      'studentname': 'VirenBhai020124',
      'name': 'VirenBhai',
      'shift': 2,
      'status': -1
    },
    {'studentname': 'Om020124', 'name': 'Om', 'shift': 2, 'status': -1},
    {
      'studentname': 'Dhaivat020124',
      'name': 'Dhaivat',
      'shift': 2,
      'status': -1
    },
  ];

  List<int> shiftTypes = [1, 2];
  String searchText = '';
  late int selectedShift;

  @override
  void initState() {
    super.initState();
    studentData.sort((a, b) => a['name'].compareTo(b['name']));
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
    List<Map<String, dynamic>> filteredStudents = studentData
        .where((student) =>
            student['shift'] == selectedShift &&
            student['studentname']
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();

    // // Sort the students based on their names
    // filteredStudents.sort((a, b) => a['studentname']
    //     .toLowerCase()
    //     .compareTo(b['studentname'].toLowerCase()));

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.mainbackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            "Student Attendance",
            style: TextStyle(
                color: MyTheme.textcolor,
                fontSize: getSize(context, 2.7),
                fontWeight: FontWeight.bold),
          ),
          actions: [
            InkWell(
              onTap: () {
                giveuserinfo('Username: Vedant Bharad', context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
                child: CircleAvatar(
                  radius: 24.0,
                  backgroundColor: MyTheme.highlightcolor,
                  child: Icon(Icons.person,
                      color: Colors.black, size: getSize(context, 3)),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "Shift",
                    style: TextStyle(
                        color: MyTheme.textcolor,
                        fontSize: getSize(context, 2.4)),
                  ),
                ),
                Container(
                  color: MyTheme.background,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: getWidth(context, 0.02),
                      right: getWidth(context, 0.02),
                    ),
                    child: buildDropdown(
                      selectedShift,
                      (int? newValue) {
                        setState(() {
                          selectedShift = newValue!;
                        });
                      },
                      shiftTypes,
                      context,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        _markAllStudentsPresent();
                      },
                      child: Container(
                        height: getHeight(context, 0.05),
                        width: getWidth(context, 0.3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: MyTheme.mainbutton,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Present All',
                          style: TextStyle(
                            color: MyTheme.mainbuttontext,
                            fontWeight: FontWeight.w600,
                            fontSize: getSize(context, 2.2),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // _markAllStudentsPresent();
                      },
                      child: Container(
                        height: getHeight(context, 0.05),
                        width: getWidth(context, 0.11),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: MyTheme.button1.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.download,
                          color: MyTheme.button1,
                          size: getSize(context, 2.6),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _markAllStudentsAbsent();
                      },
                      child: Container(
                        height: getHeight(context, 0.05),
                        width: getWidth(context, 0.3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: MyTheme.button2.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Absent All',
                          style: TextStyle(
                            color: MyTheme.button2,
                            fontWeight: FontWeight.w600,
                            fontSize: getSize(context, 2.2),
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     _markAllStudentsAbsent();
                    //   },
                    //   child: Text('Absent All'),
                    // ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  style: TextStyle(color: MyTheme.textcolor),
                  decoration: InputDecoration(
                    labelText: 'Search Student',
                    labelStyle: TextStyle(color: MyTheme.textcolor),
                    suffixIcon: Icon(
                      Icons.search,
                      color: MyTheme.textcolor,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: getHeight(context, 0.5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      int status = filteredStudents[index]['status'];
                      return Card(
                        color: MyTheme.background,
                        child: ListTile(
                          title: Text(
                            filteredStudents[index]['name'],
                            style: TextStyle(color: MyTheme.textcolor),
                          ),
                          subtitle: Text(
                            _getStatusText(status),
                            style: TextStyle(
                                color: MyTheme.textcolor.withOpacity(0.5)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildIconButton(Icons.check,
                                  status == 1 ? Colors.green : Colors.grey, () {
                                // _updateStatus(index, 1); // Mark as Present
                                _updateStatus(
                                    filteredStudents[index]['studentname'],
                                    1); // Mark as Present
                              }),
                              _buildIconButton(Icons.cancel,
                                  status == 0 ? Colors.red : Colors.grey, () {
                                // _updateStatus(index, 0); // Mark as Absent
                                _updateStatus(
                                    filteredStudents[index]['studentname'],
                                    0); // Mark as Absent
                              }),
                              _buildIconButton(Icons.note_alt,
                                  status == 3 ? Colors.orange : Colors.grey,
                                  () {
                                // _updateStatus(index, 3); // Mark as On Leave
                                _updateStatus(
                                    filteredStudents[index]['studentname'],
                                    3); // Mark as On Leave
                              }),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // _saveData();
          },
          backgroundColor: MyTheme.mainbutton,
          child: Icon(
            Icons.upload,
            color: MyTheme.mainbuttontext,
            size: getSize(context, 3),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, Function() onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: color,
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case -1:
        return '';
      case 1:
        return 'Present';
      case 0:
        return 'Absent';
      case 3:
        return 'On Leave';
      default:
        return '';
    }
  }

  void _updateStatus(String studentname, int newStatus) {
    int index = studentData.indexWhere(
      (student) => student['studentname'] == studentname,
    );

    if (index != -1) {
      setState(() {
        studentData[index]['status'] = newStatus;
      });
    }
  }

  void _markAllStudentsPresent() {
    setState(() {
      for (var student in studentData) {
        if (student['shift'] == selectedShift) {
          student['status'] = 1; // Mark as Present
        }
      }
    });
  }

  void _markAllStudentsAbsent() {
    setState(() {
      for (var student in studentData) {
        if (student['shift'] == selectedShift) {
          student['status'] = 0; // Mark as Absent
        }
      }
    });
  }
}
