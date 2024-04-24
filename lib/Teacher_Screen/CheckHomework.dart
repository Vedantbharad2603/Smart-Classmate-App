// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckHomework extends StatefulWidget {
  const CheckHomework({Key? key}) : super(key: key);

  @override
  State<CheckHomework> createState() => _CheckHomeworkState();
}

class _CheckHomeworkState extends State<CheckHomework> {
  TextEditingController workRemark = TextEditingController();
  bool _isLoading = false;
  late int checkerid;
  List<Map<String, dynamic>> works = [];
  @override
  void initState() {
    super.initState();
    GetStorage storage = GetStorage();
    final mydata = storage.read('login_data');

    if (mydata != null) {
      checkerid = mydata['data']['userdata']['id'] ?? 0;
    }
    fetchWorkToCheck();
    // studentData.sort((a, b) => a['full_name'].compareTo(b['full_name']));
  }

  Future<void> fetchWorkToCheck() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(Apiconst.listworkTeacher));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // print(responseData['data'][0]['login']);
        if (responseData.containsKey('data')) {
          List<dynamic> data = responseData['data'];
          List<Map<String, dynamic>> tempwork = [];
          for (var item in data) {
            tempwork.add({
              'id': item['id'],
              'homework_details': item['homework_details'],
              'is_submited': item['is_submited'],
              'homework_date': item['homework_date'],
              'remark': item['remark'],
              'studentdatumId': item['studentdatumId'],
              'teacherdatumId': item['teacherdatumId'],
              'student_name': item['student_name']
            });
          }
          setState(() {
            works = tempwork;
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

  Future<bool> updateDetails(int idin, String remarks, String workinfo,
      String workdate, int studid, int teacherid) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> body = {
      "id": idin,
      "homework_details": workinfo,
      "is_submited": true,
      "homework_date": workdate,
      "remark": remarks,
      "studentdatumId": studid,
      "teacherdatumId": teacherid,
      "checkerTeacherId": checkerid
    };
    try {
      http.Response response = await http.put(
        Uri.parse(Apiconst.updateWork),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text("Remark Uploaded"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Fail'),
              content: const Text("Somthing wrong while Uploading Remark"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return false;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fail'),
            content: const Text("Somthing wrong while Uploading Remark"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    } finally {
      setState(() {
        _isLoading = false;
        workRemark.text = "";
        fetchWorkToCheck();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                title: Text(
                  'Check Homework',
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
                child: Column(
                  children: [
                    SizedBox(
                      height: getHeight(context, 0.7),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: works.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> work = works[index];
                          return mycards(
                              work['student_name'],
                              work['homework_date'],
                              work['homework_details'],
                              work['id'],
                              work['studentdatumId'],
                              work['teacherdatumId']);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget mycards(String studentName, String workDate, String workDetails,
      int workid, int studid, int teacherid) {
    return Padding(
      padding: EdgeInsets.all(getSize(context, 1.2)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getSize(context, 1.2)),
          color: MyTheme.background,
          border: Border.all(
              color: MyTheme.textcolor.withOpacity(0.3),
              width: getWidth(context, 0.004)),
        ),
        child: Padding(
          padding: EdgeInsets.all(getSize(context, 0.9)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: getWidth(context, 0.03),
                  ),
                  Text(
                    studentName,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: MyTheme.textcolor,
                        fontSize: getSize(context, 2.2),
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        workDate,
                        style: TextStyle(
                          fontSize: getSize(context, 2),
                          color: MyTheme.mainbuttontext,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    workDetails,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: getSize(context, 2),
                        fontWeight: FontWeight.bold,
                        color: MyTheme.textcolor),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    giveRemarkDialog(context, workid, workDate, workDetails,
                        studid, teacherid);
                  },
                  icon: Icon(
                    Icons.check_circle_outlined,
                    size: getSize(context, 3),
                    color: MyTheme.button1,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void giveRemarkDialog(BuildContext context, int workid, String workDate,
      String workDetails, int studid, int teacherid) {
    // workRemark.text = concept;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text(
            "Give remark",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: TextField(
            style: TextStyle(color: MyTheme.textcolor),
            controller: workRemark,
            decoration: InputDecoration(
              labelText: 'Remark',
              labelStyle: TextStyle(color: MyTheme.textcolor),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: MyTheme.button2),
              ),
            ),
            TextButton(
              onPressed: () {
                updateDetails(workid, workRemark.text, workDetails, workDate,
                    studid, teacherid);
                Navigator.of(context).pop();
              },
              child: Text(
                "Save",
                style: TextStyle(color: MyTheme.button1),
              ),
            ),
          ],
        );
      },
    );
  }
}
