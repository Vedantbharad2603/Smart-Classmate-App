import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:smartclassmate/tools/theme.dart';

class HolidayData {
  final String name;
  final String date;
  bool consider;

  HolidayData({
    required this.name,
    required this.date,
    this.consider = true, // Default value is true
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'consider': consider,
    };
  }
}

class ListofHolidays extends StatefulWidget {
  @override
  _ListofHolidaysState createState() => _ListofHolidaysState();
}

class _ListofHolidaysState extends State<ListofHolidays> {
  List<HolidayData> holidayDataList = []; // Store fetched holiday data
  List<bool> selected = []; // Track selected holidays
  late Future<List<HolidayData>> _futureHolidays;

  @override
  void initState() {
    super.initState();
    _futureHolidays = fetchHolidays();
  }

  Future<List<HolidayData>> fetchHolidays() async {
    final response = await http.get(
      Uri.parse(
          'https://calendarific.com/api/v2/holidays?&api_key=RiOlrpYvgp0a5J5T8Z8iUza6kjGILmC7&country=IN&year=2024'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> fetchedHolidays = data['response']['holidays'];

      // Initialize the selected list with false values
      selected = List.generate(fetchedHolidays.length, (index) => true);

      // Store fetched holiday data with default consider value as true
      holidayDataList = fetchedHolidays
          .map((holiday) => HolidayData(
                name: holiday['name'],
                date: holiday['date']['iso'],
              ))
          .toList();

      // Write data to file
      writeToFile(json.encode(holidayDataList));

      return holidayDataList;
    } else {
      throw Exception('Failed to load holidays');
    }
  }

  Future<void> writeToFile(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/holidays.txt');
    await file.writeAsString(data);
  }

  Future<String> readFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/holidays.txt');
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print('Error reading file: $e');
      return '';
    }
  }

  void printSelectedHolidays() {
    List<Map<String, dynamic>> selectedHolidays = [];
    for (int i = 0; i < holidayDataList.length; i++) {
      if (selected[i]) {
        selectedHolidays.add(holidayDataList[i].toJson());
      }
    }
    print(json.encode(selectedHolidays));
  }

  @override
  Widget build(BuildContext context) {
    // Get current month
    final currentMonth = DateTime.now().month;

    // Check if the current month is January (month number is 1)
    final isJanuary = currentMonth == DateTime.january;
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: MyTheme.mainbuttontext,
            ),
            onPressed: () {
              setState(() {
                printSelectedHolidays();
              });
            },
          ),
          if (isJanuary)
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: MyTheme.button1,
              ),
              onPressed: () {
                setState(() {
                  _futureHolidays = fetchHolidays();
                });
              },
            ),
        ],
        title:
            Text('Manage Holidays', style: TextStyle(color: MyTheme.textcolor)),
      ),
      body: FutureBuilder<List<HolidayData>>(
        future: _futureHolidays,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<HolidayData> fetchedHolidays = snapshot.data!;
            return ListView.builder(
              itemCount: fetchedHolidays.length,
              itemBuilder: (context, index) {
                var holiday = fetchedHolidays[index];
                return ListTile(
                  title: Text(
                    holiday.name,
                    style: TextStyle(color: MyTheme.textcolor),
                  ),
                  subtitle: Text(holiday.date,
                      style:
                          TextStyle(color: MyTheme.textcolor.withOpacity(0.6))),
                  trailing: Checkbox(
                    activeColor: MyTheme.mainbuttontext,
                    checkColor: MyTheme.mainbutton,
                    value: selected[index],
                    onChanged: (bool? value) {
                      setState(() {
                        selected[index] = value!;
                      });
                    },
                    side: BorderSide(color: MyTheme.textcolor, width: 2),
                    // fillColor: MaterialStateProperty.resolveWith<Color?>(
                    //   (Set<MaterialState> states) {
                    //     if (!states.contains(MaterialState.selected)) {
                    //       return MyTheme.textcolor.withOpacity(
                    //           0.5); // Color of the unticked checkbox
                    //     }
                    //     return null; // Use default value for selected checkbox
                    //   },
                    // ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Clear selected list to avoid memory leaks
    selected.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read data from file every time the widget rebuilds
    readFromFile().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          holidayDataList = (json.decode(value) as List)
              .map((item) => HolidayData(
                    name: item['name'],
                    date: item['date'],
                    consider: item['consider'],
                  ))
              .toList();
          selected = List.generate(holidayDataList.length, (index) => false);
        });
      }
    });
  }
}
