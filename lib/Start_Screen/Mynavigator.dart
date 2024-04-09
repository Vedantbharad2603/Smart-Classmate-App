import 'package:flutter/material.dart';
import 'package:smartclassmate/Start_Screen/login.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartclassmate/masterpage/studentmaster.dart';
import 'package:smartclassmate/masterpage/teachermaster.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Mynavigator extends StatelessWidget {
  const Mynavigator({Key? key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final isLoggedIn = storage.read('logedin') ?? false;

    if (!isLoggedIn) {
      // If not logged in, redirect to login page
      return LoginPage();
    }

    // If logged in, check user type
    final mydata = storage.read('login_data');
    if (mydata != null) {
      String userType = mydata['data']['login']['type'];
      print(userType);
      if (userType == 'student') {
        return const StudentMasterPage();
      } else {
        return const TeacherMasterPage();
      }
    } else {
      print('Error reading login data from storage');
      return LoginPage(); // Placeholder widget until data is loaded
    }
  }
}
