// ignore_for_file: unused_element, avoid_print

import 'package:flutter/material.dart';
import 'package:smartclassmate/Model/Event.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Map<DateTime, List<EventData>> _events;
  Rx<String> selectedShift = ''.obs;
  late String shift;
  List<Map<String, dynamic>> shifts = [];
  List<EventData> events = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchShifts();
    fetchEvents();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _events = {};
  }

  Future<void> fetchEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(Apiconst.listallEvents));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          List<EventData> fetchedEvents =
              data.map((e) => EventData.fromJson(e)).toList();
          setState(() {
            events = fetchedEvents; // Update the events list
          });
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

  Future<void> fetchShifts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(Apiconst.listallShift));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          final List<dynamic> shiftsData = data['data'];
          shifts = shiftsData.map((shift) {
            return {
              'id': shift['id'],
              'shiftName': shift['shiftName'].toString(),
            };
          }).toList();
          setState(() {});
          print(shifts);
        } else {
          throw Exception('Data key not found in API response');
        }
      } else {
        throw Exception('Failed to fetch shifts');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addEvent(String description, DateTime date, int id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> body = {
        "event_description": description,
        "event_date": date.toIso8601String(),
        "shiftdatumId": id,
      };
      final response = await http.post(
        Uri.parse(Apiconst.addEvent),
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
              content: Text('Event added successfully'),
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
      } else {
        throw Exception('Failed to add event');
      }
    } catch (e) {
      // Show error popup
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add event: $e'),
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
        fetchEvents();
      });
    }
  }

  String? getShiftNameById(int id, List<Map<String, dynamic>>? shifts) {
    if (shifts == null || shifts.isEmpty) return null;

    // Find the shift with the matching id
    Map<String, dynamic>? shift = shifts.firstWhere(
      (shift) => shift['id'] == id,
    );

    // Return the shift name if it exists, otherwise return null
    return shift != null ? shift['shiftName'] : null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                title: Text('Events Manage',
                    style: TextStyle(color: MyTheme.textcolor)),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TableCalendar(
                        headerStyle: HeaderStyle(
                          formatButtonShowsNext: false,
                          rightChevronIcon: Icon(
                            Icons.arrow_right,
                            size: 30,
                            color: MyTheme.textcolor,
                          ),
                          leftChevronIcon: Icon(
                            Icons.arrow_left,
                            size: 30,
                            color: MyTheme.textcolor,
                          ),
                          titleTextStyle: TextStyle(color: MyTheme.button1),
                          formatButtonTextStyle:
                              TextStyle(color: MyTheme.button1),
                          formatButtonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: MyTheme.button1.withOpacity(0.5),
                            ),
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: MyTheme
                                  .mainbuttontext), // Change weekday text color
                          weekendStyle: TextStyle(
                              color: MyTheme.button2.withOpacity(
                                  0.7)), // Change weekend text color
                        ),
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        calendarStyle: CalendarStyle(
                          markerSize: 8,
                          markerDecoration: BoxDecoration(
                              color: MyTheme.mainbuttontext.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20)),
                          defaultTextStyle: TextStyle(color: MyTheme.textcolor),
                          todayTextStyle: TextStyle(
                              color: MyTheme.background2,
                              fontWeight: FontWeight.bold),
                          weekendTextStyle: TextStyle(
                              color: MyTheme.textcolor.withOpacity(0.3),
                              fontWeight: FontWeight.bold),
                          todayDecoration: BoxDecoration(
                            color: MyTheme.highlightcolor,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: MyTheme.button1.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        eventLoader: (day) {
                          return _events[day] ?? [];
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String eventDescription = '';
                                return AlertDialog(
                                  backgroundColor: MyTheme.background2,
                                  scrollable: true,
                                  title: Text(
                                    'Add Event Description',
                                    style: TextStyle(color: MyTheme.textcolor),
                                  ),
                                  content: Column(
                                    children: [
                                      TextField(
                                        style:
                                            TextStyle(color: MyTheme.textcolor),
                                        onChanged: (value) {
                                          eventDescription = value;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Enter event description',
                                            hintStyle: TextStyle(
                                                color: MyTheme.textcolor
                                                    .withOpacity(0.7))),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Select Shift',
                                        style:
                                            TextStyle(color: MyTheme.textcolor),
                                      ),
                                      Obx(
                                        () => buildmainDropdown(
                                            selectedShift.value, (value) {
                                          setState(() {
                                            selectedShift.value = value!;
                                          });
                                        }, context, shifts),
                                      )
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style:
                                            TextStyle(color: MyTheme.button2),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Handle adding event for _selectedDay
                                        // print(eventDescription +
                                        //     " " +
                                        //     _focusedDay.toString() +
                                        //     " " +
                                        //     selectedShift.value);
                                        addEvent(eventDescription, _focusedDay,
                                            int.parse(selectedShift.value));
                                        setState(() {
                                          fetchEvents();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Add',
                                        style: TextStyle(
                                            color: MyTheme.mainbuttontext),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: getHeight(context, 0.05),
                            width: getWidth(context, 0.38),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: MyTheme.mainbutton,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Add Event',
                              style: TextStyle(
                                color: MyTheme.mainbuttontext,
                                fontWeight: FontWeight.w600,
                                fontSize: width * 0.06,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getHeight(context, 0.02),
                      ),
                      SizedBox(
                        height: getHeight(context, 0.3),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  EventData event = events[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date: ${event.event_date.substring(0, 10)}",
                                        // .toIso8601String().substring(0, 10)
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: MyTheme.textcolor,
                                        ),
                                      ),
                                      ListTile(
                                        title: RichText(
                                          text: TextSpan(
                                            text: 'Event: ',
                                            style: TextStyle(
                                              fontSize: getSize(context, 2),
                                              color: MyTheme.button1,
                                              // rgba(201, 208, 103, 1)
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: event.event_description,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: MyTheme.textcolor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: RichText(
                                          text: TextSpan(
                                            text: 'Shift: ',
                                            style: TextStyle(
                                              fontSize: getSize(context, 1.7),
                                              color: MyTheme.mainbuttontext,
                                              // rgba(201, 208, 103, 1)
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: getShiftNameById(
                                                    event.shiftdatumId, shifts),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: MyTheme.textcolor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildmainDropdown(
    String selectedValue,
    Function(String?) onChanged,
    context,
    List<Map<String, dynamic>> shifts,
  ) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: shifts.map((shift) {
        return RadioListTile<String>(
          title: Text(
            shift['shiftName'],
            style: TextStyle(color: MyTheme.textcolor),
          ),
          value: shift['id'].toString(), // Use unique identifier as value
          groupValue: selectedValue,
          onChanged: onChanged,
        );
      }).toList(),
    );
  }
}
