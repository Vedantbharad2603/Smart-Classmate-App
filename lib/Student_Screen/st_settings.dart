import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

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
          padding: EdgeInsets.all(8.0),
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
          color: MyTheme.mainbutton,
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
                      color: MyTheme.mainbuttontext,
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

  void _showThemeSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ThemeSelectionDialog(
          selectedThemeIndex: selectedThemeIndex,
          onThemeSelected: (int index) {
            setState(() {
              selectedThemeIndex = index;
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class ThemeSelectionDialog extends StatefulWidget {
  final int selectedThemeIndex;
  final ValueChanged<int> onThemeSelected;

  ThemeSelectionDialog({
    required this.selectedThemeIndex,
    required this.onThemeSelected,
  });

  @override
  _ThemeSelectionDialogState createState() => _ThemeSelectionDialogState();
}

class _ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Theme'),
            SizedBox(height: 10),
            ListTile(
              title: Text('Dark Theme'),
              leading: Radio(
                value: 0,
                groupValue: widget.selectedThemeIndex,
                onChanged: (int? value) {
                  widget.onThemeSelected(value!);
                  // _toggleTheme();
                },
              ),
            ),
            ListTile(
              title: Text('Light Theme'),
              leading: Radio(
                value: 1,
                groupValue: widget.selectedThemeIndex,
                onChanged: (int? value) {
                  widget.onThemeSelected(value!);
                },
              ),
            ),
            // Add more themes as needed
          ],
        ),
      ),
    );
  }
}
