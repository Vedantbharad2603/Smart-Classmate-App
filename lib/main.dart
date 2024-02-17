import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:smartclassmate/Start_Screen/login.dart';
import 'package:flutter/services.dart';
import 'package:smartclassmate/tools/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await MyTheme.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
