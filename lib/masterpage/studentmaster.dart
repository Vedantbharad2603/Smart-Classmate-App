import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smartclassmate/Student_Screen/st_home_page.dart';
import 'package:smartclassmate/Student_Screen/st_messages.dart';
import 'package:smartclassmate/Student_Screen/st_profilepage.dart';
import 'package:smartclassmate/Student_Screen/st_work.dart';
import 'package:smartclassmate/tools/theme.dart';

class StudentMasterPage extends StatefulWidget {
  const StudentMasterPage({super.key});

  @override
  State<StudentMasterPage> createState() => _StudentMasterPageState();
}

class _StudentMasterPageState extends State<StudentMasterPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      STHomepage(),
      STWork(),
      STMessage(),
      STProfilePage(onThemeToggleMaster: () => setState(() {})),
    ];
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: MyTheme.background,
              color: MyTheme.textcolor,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  // text: 'Home',
                ),
                GButton(
                  icon: LineIcons.book,
                  // text: 'Work',
                ),
                GButton(
                  icon: Icons.notifications_none,
                  // text: 'Update',
                ),
                GButton(
                  icon: LineIcons.user,
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
