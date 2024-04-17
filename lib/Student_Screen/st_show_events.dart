import 'package:flutter/material.dart';
import 'package:smartclassmate/Model/Event.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StShowEvents extends StatefulWidget {
  const StShowEvents({Key? key}) : super(key: key);

  @override
  State<StShowEvents> createState() => _StShowEventsState();
}

class _StShowEventsState extends State<StShowEvents> {
  late CalendarFormat _calendarFormat;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  List<EventData> events = [];
  List<Map<String, dynamic>> shifts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchShifts();
    fetchEvents();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    // _events = {
    //   DateTime.utc(2024, 3, 19): [
    //     EventData(
    //         'EventData 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1',
    //         'Shift 1'),
    //   ],
    //   DateTime.utc(2024, 3, 25): [
    //     EventData('EventData 2', 'Shift 2'),
    //   ],
    //   DateTime.utc(2024, 3, 26): [
    //     EventData('EventData 3', 'Shift 2'),
    //   ],
    // };
    // _events = {
    //   DateTime.now(): [
    //     EventData('EventData 1', 'Shift 1'),
    //     EventData('EventData 2', 'Shift 2'),
    //     EventData('EventData 3', 'Shift 1'),
    //   ],
    //   DateTime.now().add(Duration(days: 1)): [
    //     EventData('EventData 4', 'Shift 2'),
    //   ],
    // };
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
                title: Text('List of Events',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: MyTheme.textcolor)),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TableCalendar(
                        headerStyle: HeaderStyle(
                          // formatButtonShowsNext: false,
                          formatButtonVisible: false,
                          rightChevronIcon: Icon(
                            Icons.arrow_right,
                            size: getSize(context, 4),
                            color: MyTheme.textcolor,
                          ),
                          leftChevronIcon: Icon(
                            Icons.arrow_left,
                            size: getSize(context, 4),
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
}
