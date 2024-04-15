import 'package:flutter/material.dart';
import 'package:smartclassmate/Start_Screen/Mynavigator.dart';
import 'package:flutter/services.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await MyTheme.init();
  await GetStorage.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Mynavigator(),
      // theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
