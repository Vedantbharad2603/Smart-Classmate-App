import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class STWork extends StatefulWidget {
  const STWork({Key? key}) : super(key: key);

  @override
  State<STWork> createState() => _STWorkState();
}

List<Map<String, dynamic>> yourwork = [
  {
    'date': '2/2/24',
    'description':
        'Complete 30 Wh questions, 30 affirmative sentences, and 30 negative sentences Complete 30 Wh questions, 30 affirmative sentences, and 30 negative sentences',
    'uploaded': true,
  },
  {
    'date': '6/2/24',
    'description':
        'Complete 30 Wh questions, 30 affirmative sentences, and 30 negative sentences Complete 30 Wh questions, 30 affirmative sentences, and 30 negative sentences',
    'uploaded': false,
  },
  {
    'date': '12/2/24',
    'description':
        'Complete 30 Wh questions, 30 affirmative sentences, and 30 negative sentences Complete 30 Wh questions, 30 affirmative sentences, and 30 negative sentences',
    'uploaded': true,
  },
];

class _STWorkState extends State<STWork> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Uploaded and Not Uploaded
      child: SafeArea(
        child: Scaffold(
          backgroundColor: MyTheme.mainbackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text(
              "Your Work",
              style: TextStyle(
                  color: MyTheme.textcolor,
                  fontSize: getSize(context, 2.7),
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.notifications_none,
              //     size: getSize(context, 3),
              //     color: MyTheme.textcolor,
              //   ),
              // ),
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
                    "Not Uploaded",
                    style: TextStyle(color: MyTheme.textcolor),
                  ),
                ),
                Tab(
                  child: Text(
                    "Uploaded",
                    style: TextStyle(color: MyTheme.textcolor),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              buildTabView(false), // Not Uploaded Tab View
              buildTabView(true), // Uploaded Tab View
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabView(bool uploaded) {
    List<Map<String, dynamic>> filteredList =
        yourwork.where((work) => work['uploaded'] == uploaded).toList();

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
    return SizedBox(
      width: getWidth(context, 0.8),
      child: Padding(
        padding: EdgeInsets.all(getSize(context, 1.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                        RichText(
                          text: TextSpan(
                            text: 'Date: ',
                            style: TextStyle(
                              fontSize: getSize(context, 2),
                              color: MyTheme.textcolor,
                              decoration: work['uploaded']
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: work['date'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.button1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        moreOptions(
                          [
                            'More info',
                            work['uploaded'] ? 'Reupload Work' : 'Upload Work'
                          ],
                          [
                            () {
                              // Handle More info
                              showFullDescriptionDialog(
                                  work['description'], context);
                            },
                            () async {
                              // Handle Upload or Reupload based on the 'uploaded' status
                              if (work['uploaded']) {
                              } else {
                                // Open file explorer to pick a PDF file
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf']);

                                if (result != null) {
                                  String fileName = result.files.single.name;

                                  // Display the selected file name and provide upload and cancel buttons
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                    // barrierColor: MyTheme.background,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: MyTheme.background,
                                        title: Text(
                                          'Selected File: $fileName',
                                          style: TextStyle(
                                              color: MyTheme.textcolor),
                                        ),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        MyTheme.button1),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0), // Adjust the value as needed
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Close the dialog
                                              },
                                              child: Text(
                                                'Upload',
                                                style: TextStyle(
                                                    color: MyTheme.background),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        MyTheme.button2),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0), // Adjust the value as needed
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Close the dialog
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: MyTheme.background),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  // User canceled the file picker
                                }
                              }
                            },
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getHeight(context, 0.02),
                    ),
                    Text(
                      truncateDescription(work['description'], 10),
                      style: TextStyle(
                        color: MyTheme.textcolor,
                        fontSize: getSize(context, 2),
                        decoration: work['uploaded']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String truncateDescription(String description, int maxWords) {
    List<String> words = description.split(' ');
    if (words.length > maxWords) {
      return '${words.sublist(0, maxWords).join(' ')}...';
    } else {
      return description;
    }
  }

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
