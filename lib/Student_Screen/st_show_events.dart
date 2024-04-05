import 'package:flutter/material.dart';
import 'package:smartclassmate/Model/Event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:get/get.dart';

class StShowEvents extends StatefulWidget {
  const StShowEvents({Key? key}) : super(key: key);

  @override
  State<StShowEvents> createState() => _StShowEventsState();
}

class _StShowEventsState extends State<StShowEvents> {
  late CalendarFormat _calendarFormat;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Map<DateTime, List<Event>> _events;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _events = {
      DateTime.utc(2024, 3, 19): [
        Event(
            'Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1Event 1',
            'Shift 1'),
      ],
      DateTime.utc(2024, 3, 25): [
        Event('Event 2', 'Shift 2'),
      ],
      DateTime.utc(2024, 3, 26): [
        Event('Event 3', 'Shift 2'),
      ],
    };
    // _events = {
    //   DateTime.now(): [
    //     Event('Event 1', 'Shift 1'),
    //     Event('Event 2', 'Shift 2'),
    //     Event('Event 3', 'Shift 1'),
    //   ],
    //   DateTime.now().add(Duration(days: 1)): [
    //     Event('Event 4', 'Shift 2'),
    //   ],
    // };
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                  formatButtonTextStyle: TextStyle(color: MyTheme.button1),
                  formatButtonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: MyTheme.button1.withOpacity(0.5),
                    ),
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      color:
                          MyTheme.mainbuttontext), // Change weekday text color
                  weekendStyle: TextStyle(
                      color: MyTheme.button2
                          .withOpacity(0.7)), // Change weekend text color
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
                      color: MyTheme.background2, fontWeight: FontWeight.bold),
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
              SizedBox(
                height: getHeight(context, 0.02),
              ),
              Container(
                height: getHeight(context, 0.39),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _events.length,
                        itemBuilder: (context, index) {
                          DateTime date = _events.keys.elementAt(index);
                          List<Event> events = _events[date]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date: ${date.toIso8601String().substring(0, 10)}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.textcolor,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: events.length,
                                itemBuilder: (context, innerIndex) {
                                  Event event = events[innerIndex];
                                  return ListTile(
                                    title: Text(
                                      "Event: ${event.title}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MyTheme.textcolor,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Shift: ${event.shift}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: MyTheme.button1,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10),
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
    );
  }

  void _addEvent(Event event) {
    _events.update(_selectedDay, (existingEvents) {
      if (existingEvents != null) {
        existingEvents.add(event);
        return existingEvents;
      } else {
        return [event];
      }
    }, ifAbsent: () => [event]);

    // Print the whole list of events in the log
    _events.forEach((key, value) {
      print('Date: $key');
      value.forEach((event) {
        print('Event: ${event.title}, Shift: ${event.shift}');
      });
    });
  }

  void _deleteEvent(Event event) {
    _events.update(_selectedDay, (existingEvents) {
      existingEvents?.remove(event);
      return existingEvents;
    });
  }
}
