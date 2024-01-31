import 'package:flutter/material.dart';

class TeAttendance extends StatefulWidget {
  const TeAttendance({Key? key}) : super(key: key);

  @override
  State<TeAttendance> createState() => _TeAttendanceState();
}

class _TeAttendanceState extends State<TeAttendance> {
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
  ];

  int selectedShift = 1; // Default shift
  String searchText = ''; // Variable to store search text

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
        backgroundColor: const Color.fromARGB(255, 243, 253, 233),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            "Student Attendance",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => STProfilePage(),
                //   ),
                // );
              },
              child: Padding(
                padding: EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
                child: CircleAvatar(
                  radius: 24.0,
                  backgroundColor: Color.fromARGB(255, 0, 241, 101),
                  child: Icon(Icons.person, color: Colors.black, size: 28.8),
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
                DropdownButton<int>(
                  value: selectedShift,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedShift = newValue!;
                    });
                  },
                  items: [1, 2]
                      .map<DropdownMenuItem<int>>(
                        (int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('Shift $value'),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _markAllStudentsPresent();
                      },
                      child: Text('Present All'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _markAllStudentsAbsent();
                      },
                      child: Text('Absent All'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Student',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    int status = filteredStudents[index]['status'];
                    return Card(
                      child: ListTile(
                        title: Text(filteredStudents[index]['studentname']),
                        subtitle: Text(_getStatusText(status)),
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
                                status == 3 ? Colors.orange : Colors.grey, () {
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
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // _saveData();
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.blue,
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
