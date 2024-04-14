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

// class MainApp extends StatelessWidget {
//   const MainApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ConnectivityResult>(
//       future: Connectivity().checkConnectivity(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final connectivityResult = snapshot.data!;
//           if (connectivityResult == ConnectivityResult.none) {
//             WidgetsBinding.instance?.addPostFrameCallback((_) {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: const Text('No Internet Connection'),
//                     content: const Text('Please connect to the internet.'),
//                     actions: <Widget>[
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             });
//           }
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: Mynavigator(),
//             // theme: ThemeData(brightness: Brightness.dark),
//           );
//         } else {
//           return const MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
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
