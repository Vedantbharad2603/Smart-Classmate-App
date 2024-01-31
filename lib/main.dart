import 'package:flutter/material.dart';
import 'package:smartclassmate/Start_Screen/login.dart';
import 'package:flutter/services.dart';
import 'package:smartclassmate/tools/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  MyTheme.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
