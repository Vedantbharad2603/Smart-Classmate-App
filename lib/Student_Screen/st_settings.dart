import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

// ignore: must_be_immutable
class StSettings extends StatefulWidget {
  void Function() onThemeToggleMaster;
  void Function() onThemeToggleProfile;
  StSettings(
      {Key? key,
      required this.onThemeToggleMaster,
      required this.onThemeToggleProfile})
      : super(key: key);

  @override
  State<StSettings> createState() => _StSettingsState();
}

class _StSettingsState extends State<StSettings> {
  int selectedThemeIndex = 0;
  bool notifications = true;
  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: getWidth(context, 0.8),
                child: Expanded(
                  child: Text(
                    'Settings',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: getSize(context, 2.8),
                        color: MyTheme.textcolor),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(getSize(context, 1.2)),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSize(context, 1.2)),
                    color: MyTheme.mainbutton,
                    border: Border.all(
                        color: Colors.grey, width: getWidth(context, 0.004)),
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
                              width: getWidth(context, 0.5),
                              child: Expanded(
                                child: Text(
                                  "Dark Theme",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: MyTheme.mainbuttontext,
                                    fontSize: getSize(context, 2.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          activeColor: MyTheme.mainbuttontext,
                          value: MyTheme.isDarkMode,
                          onChanged: (val) {
                            MyTheme.toggleTheme;
                            widget.onThemeToggleMaster();
                            widget.onThemeToggleProfile();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(getSize(context, 1.2)),
              //   child: Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(getSize(context, 1.2)),
              //       color: MyTheme.mainbutton,
              //       border: Border.all(
              //           color: Colors.grey, width: getWidth(context, 0.004)),
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.all(getSize(context, 0.9)),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 "Notifications",
              //                 style: TextStyle(
              //                   color: MyTheme.mainbuttontext,
              //                   fontSize: getSize(context, 2.5),
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           Switch(
              //             activeColor: MyTheme.mainbuttontext,
              //             value: notifications,
              //             onChanged: (val) {
              //               notifications = !notifications;
              //               setState(() {});
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
