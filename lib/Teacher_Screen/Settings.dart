// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  void Function() onThemeToggleMaster;
  void Function() onThemeToggleProfile;
  Settings(
      {Key? key,
      required this.onThemeToggleMaster,
      required this.onThemeToggleProfile})
      : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
              Text(
                'Settings',
                style: TextStyle(
                    fontSize: getSize(context, 2.8), color: MyTheme.textcolor),
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
                            Text(
                              "Dark Theme",
                              style: TextStyle(
                                color: MyTheme.mainbuttontext,
                                fontSize: getSize(context, 2.5),
                                fontWeight: FontWeight.bold,
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
                            Text(
                              "Notifications",
                              style: TextStyle(
                                color: MyTheme.mainbuttontext,
                                fontSize: getSize(context, 2.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          activeColor: MyTheme.mainbuttontext,
                          value: notifications,
                          onChanged: (val) {
                            notifications = !notifications;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // mycards("Select Theme", () {
              //   setState(() {
              //     MyTheme.toggleTheme;
              //   });
              // }),
              // mycards("Notifications", () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget mycards(String name, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.all(getSize(context, 1.2)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getSize(context, 1.2)),
          color: Colors.white,
          border:
              Border.all(color: Colors.grey, width: getWidth(context, 0.004)),
        ),
        child: Padding(
          padding: EdgeInsets.all(getSize(context, 0.9)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getSize(context, 2.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: getSize(context, 3),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
