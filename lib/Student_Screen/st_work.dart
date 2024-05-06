// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class STWork extends StatefulWidget {
  const STWork({Key? key}) : super(key: key);

  @override
  State<STWork> createState() => _STWorkState();
}

class _STWorkState extends State<STWork> {
  late int studentid;
  String username_d = "";
  String password_d = "";
  List<Map<String, dynamic>> work = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    GetStorage storage = GetStorage();
    final mydata = storage.read('login_data');
    if (mydata != null) {
      studentid = mydata['data']['userdata']['id'] ?? 0;
      username_d = mydata['data']['login']['username'] ?? "";
      password_d = mydata['data']['login']['password'] ?? "";
    }
    fetchWork(studentid);
  }

  Future<void> fetchWork(int studid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> body = {"studid": studid};
      final response = await http.post(
        Uri.parse(Apiconst.getStudentAllWork),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          List<Map<String, dynamic>> tempwork = [];
          for (var item in data) {
            tempwork.add({
              'id': item['id'],
              'homework_details': item['homework_details'],
              'is_submited': item['is_submited'],
              'homework_date': item['homework_date'],
              'remark': item['remark'],
              'teachername': item['teachername'],
              'checker_teacher': item['checker_teacher']
            });
          }
          setState(() {
            work = tempwork; // Update the events list
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Submited and Not Submited
      child: SafeArea(
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
                  title: Text(
                    overflow: TextOverflow.fade,
                    "Your Work",
                    style: TextStyle(
                        color: MyTheme.textcolor,
                        fontSize: getSize(context, 2.7),
                        fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        giveuserinfo('Username: $username_d',
                            'Password: $password_d', context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: getSize(context, 1),
                            top: getHeight(context, 0.007),
                            bottom: getHeight(context, 0.007)),
                        child: CircleAvatar(
                          radius: getSize(context, 3),
                          backgroundColor: MyTheme.highlightcolor,
                          child: Icon(Icons.person,
                              color: Colors.black, size: getSize(context, 3.6)),
                        ),
                      ),
                    )
                  ],
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          "Not Submited",
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: MyTheme.textcolor),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Submited",
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: MyTheme.textcolor),
                        ),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    buildTabView(false), // Not Submited Tab View
                    buildTabView(true), // Submited Tab View
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildTabView(bool Submited) {
    List<Map<String, dynamic>> filteredList =
        work.where((work) => work['is_submited'] == Submited).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: getHeight(context, 1),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(
                filteredList.length,
                (index) => buildWorkItem(context, filteredList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWorkItem(BuildContext context, Map<String, dynamic> work) {
    String workinfo = "${work['teachername']}: ${work['homework_details']}";
    String remarkinfo = "${work['checker_teacher']}: ${work['remark']}";
    return SizedBox(
      width: getWidth(context, 0.8),
      child: Padding(
        padding: EdgeInsets.all(getSize(context, 1.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                showFullDescriptionDialog(
                    "Work", work['homework_details'], context);
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: MyTheme.boxshadow,
                      spreadRadius: getSize(context, 0.5),
                      blurRadius: getSize(context, 0.8),
                      offset: Offset(0, getSize(context, 0.3)),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(getSize(context, 1)),
                  color: MyTheme.background,
                ),
                width: getWidth(context, 1),
                child: Padding(
                  padding: EdgeInsets.all(getSize(context, 0.8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            // color: MyTheme.button1,
                            width: getWidth(context, 0.4),
                            height: getHeight(context, 0.03),
                            child: Row(
                              children: [
                                Text(
                                  "Date: ",
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    fontSize: getSize(context, 2),
                                    color: MyTheme.button1,
                                    // rgba(201, 208, 103, 1)
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    work['homework_date'],
                                    // truncateDescription(
                                    //   studentname,
                                    //   1,
                                    // ),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: getSize(context, 2),
                                        fontWeight: FontWeight.bold,
                                        color: MyTheme.textcolor),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.upload,
                          //     color: MyTheme.button1,
                          //   ),
                          //   onPressed: () async {
                          //     // Handle Upload or Reupload based on the 'Submited' status
                          //     if (work['Submited']) {
                          //       // Handle Reupload Work
                          //     } else {
                          //       // Open file explorer to pick a PDF file
                          //       FilePickerResult? result =
                          //           await FilePicker.platform.pickFiles(
                          //         type: FileType.custom,
                          //         allowedExtensions: ['pdf'],
                          //       );

                          //       if (result != null) {
                          //         String fileName = result.files.single.name;

                          //         // Display the selected file name and provide upload and cancel buttons
                          //         // ignore: use_build_context_synchronously
                          //         showDialog(
                          //           // barrierColor: MyTheme.background,
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return AlertDialog(
                          //               backgroundColor: MyTheme.background,
                          //               title: Text(
                          //                 'Selected File: $fileName',
                          //                 style: TextStyle(
                          //                   color: MyTheme.textcolor,
                          //                 ),
                          //               ),
                          //               content: Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceAround,
                          //                 children: [
                          //                   ElevatedButton(
                          //                     style: ButtonStyle(
                          //                       backgroundColor:
                          //                           MaterialStateProperty.all(
                          //                               MyTheme.mainbutton),
                          //                       shape:
                          //                           MaterialStateProperty.all<
                          //                               RoundedRectangleBorder>(
                          //                         RoundedRectangleBorder(
                          //                           borderRadius:
                          //                               BorderRadius.circular(
                          //                                   15.0), // Adjust the value as needed
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     onPressed: () {
                          //                       Navigator.pop(
                          //                           context); // Close the dialog
                          //                     },
                          //                     child: Text(
                          //                       'Upload',
                          //                       style: TextStyle(
                          //                         color: MyTheme.mainbuttontext,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   ElevatedButton(
                          //                     style: ButtonStyle(
                          //                       backgroundColor:
                          //                           MaterialStateProperty.all(
                          //                               MyTheme.button2
                          //                                   .withOpacity(0.2)),
                          //                       shape:
                          //                           MaterialStateProperty.all<
                          //                               RoundedRectangleBorder>(
                          //                         RoundedRectangleBorder(
                          //                           borderRadius:
                          //                               BorderRadius.circular(
                          //                                   15.0), // Adjust the value as needed
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     onPressed: () {
                          //                       Navigator.pop(
                          //                           context); // Close the dialog
                          //                     },
                          //                     child: Text(
                          //                       'Cancel',
                          //                       style: TextStyle(
                          //                         color: MyTheme.button2,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       } else {
                          //         // User canceled the file picker
                          //       }
                          //     }
                          //   },
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: getHeight(context, 0.02),
                      ),
                      Text(
                        workinfo,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: work['is_submited']
                                ? MyTheme.textcolor.withOpacity(0.5)
                                : MyTheme.textcolor,
                            fontSize: getSize(context, 2),
                            decoration: work['is_submited']
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: MyTheme.textcolor),
                      ),
                      if (work['is_submited'])
                        Text(
                          remarkinfo,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: MyTheme.textcolor,
                            fontSize: getSize(context, 2),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // String truncateDescription(String description, int maxWords) {
  //   List<String> words = description.split(' ');
  //   if (words.length > maxWords) {
  //     return '${words.sublist(0, maxWords).join(' ')}...';
  //   } else {
  //     return description;
  //   }
  // }

  // void showFullDescriptionDialog(String fullDescription, BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Full Description"),
  //         content: Text(fullDescription),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
