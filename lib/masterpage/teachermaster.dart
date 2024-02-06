import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smartclassmate/Teacher_Screen/SearchStudent.dart';
import 'package:smartclassmate/Teacher_Screen/Profilepage.dart';
import 'package:smartclassmate/Teacher_Screen/Messages.dart';
import 'package:smartclassmate/Teacher_Screen/Attendance.dart';
import 'package:smartclassmate/tools/theme.dart';

class TeacherMasterPage extends StatefulWidget {
  const TeacherMasterPage({super.key});

  @override
  State<TeacherMasterPage> createState() => _TeacherMasterPageState();
}

class _TeacherMasterPageState extends State<TeacherMasterPage> {
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Messages(),
      SearchStudent(),
      Attendance(),
      Profilepage(onThemeToggleMaster: () => setState(() {})),
    ];
    double screenWidth = MediaQuery.of(context).size.width;

    double fontSize = screenWidth * 0.06;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: MyTheme.mainbackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              backgroundColor: MyTheme.mainbackground,
              rippleColor: MyTheme.background,
              hoverColor: MyTheme.background,
              gap: 8,
              activeColor: MyTheme.button1,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: MyTheme.background,
              color: MyTheme.textcolor,
              tabs: [
                GButton(
                  icon: Icons.message,
                  iconSize: fontSize,
                  // text: 'Notice Board',
                ),
                GButton(
                  icon: LineIcons.search,
                  iconSize: fontSize,
                  // text: 'Search',
                ),
                GButton(
                  icon: Icons.account_box,
                  iconSize: fontSize,
                  // text: 'Attendance',
                ),
                GButton(
                  icon: LineIcons.user,
                  iconSize: fontSize,
                  // text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
