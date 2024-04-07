// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartclassmate/masterpage/studentmaster.dart';
import 'package:smartclassmate/masterpage/teachermaster.dart';
import 'package:smartclassmate/tools/apiconst.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  Future<void> _login(String username, String pass) async {
    setState(() {
      _isLoading = true;
    });

    Map<String, String> body = {
      'username': username,
      'password': pass,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(Apiconst.logincheck),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['message'] == 'Error' &&
            data['data'] == 'incorrect password') {
          // Show a popup for incorrect password
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Incorrect password. Please try again.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Save the data to get_storage
          final storage = GetStorage();
          await storage.write('login_data', data);
          await storage.write('logedin', true);
          final mydata = storage.read('login_data');
          if (mydata != null) {
            String userType = mydata['data']['login']['type'];
            log(userType.toString());
            if (userType == 'student') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentMasterPage(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherMasterPage(),
                ),
              );
            }
          } else {
            log('Error reading login data from storage'.toString());
          }
        }
      } else {
        // Handle unsuccessful login response
        print('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.mainbackground,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                color: MyTheme.mainbackground,
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 50.0),
                          width: double.infinity,
                          height: getHeight(context, 0.20),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.elliptical(20, 20),
                              bottomRight: Radius.elliptical(20, 20),
                            ),
                            color: MyTheme.mainbuttontext,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: getHeight(context, 0.05),
                                left: getWidth(context, 0.07),
                                right: getWidth(context, 0.07)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SvgPicture.asset(
                                //   'assets/logo.png',
                                //   height: getHeight(context, 0.005),
                                //   width: getWidth(context, 0.005),
                                // ),
                                SizedBox(
                                  height: getHeight(context, 0.01),
                                ),
                                SizedBox(
                                  width: getWidth(context, 0.8),
                                  child: Expanded(
                                    child: Text(
                                      "Welcome back",
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        fontSize: getSize(context, 3),
                                        fontWeight: FontWeight.bold,
                                        color: MyTheme.textcolor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: getHeight(context, 0.01),
                                ),
                                SizedBox(
                                  width: getWidth(context, 0.8),
                                  // height: 30,
                                  child: Expanded(
                                    child: Text(
                                      "Please log in to continue and get the best form our app",
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        fontSize: getSize(context, 1.8),
                                        color: MyTheme.textcolor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getWidth(context, 0.045),
                          right: getWidth(context, 0.045),
                          top: getHeight(context, 0.01)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyTheme.background,
                            borderRadius:
                                BorderRadius.circular(getSize(context, 2))),
                        child: Padding(
                          padding: EdgeInsets.all(getSize(context, 3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: getWidth(context, 0.8),
                                child: Expanded(
                                  child: Text(
                                    "Login or Sign up",
                                    style: TextStyle(
                                      color: MyTheme.textcolor,
                                      fontSize: getSize(context, 2.8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: getHeight(context, 0.02)),
                              TextField(
                                controller: _usernameController,
                                style: TextStyle(color: MyTheme.textcolor),
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                      color:
                                          MyTheme.textcolor.withOpacity(0.6)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            MyTheme.textcolor.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(
                                      getSize(context, 1.8),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            MyTheme.textcolor.withOpacity(0.8)),
                                    borderRadius: BorderRadius.circular(
                                      getSize(context, 1.8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: getHeight(context, 0.025)),
                              TextField(
                                controller: _passwordController,
                                obscureText: _isPasswordHidden,
                                style: TextStyle(color: MyTheme.textcolor),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            MyTheme.textcolor.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(
                                      getSize(context, 1.8),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            MyTheme.textcolor.withOpacity(0.8)),
                                    borderRadius: BorderRadius.circular(
                                      getSize(context, 1.8),
                                    ),
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color:
                                          MyTheme.textcolor.withOpacity(0.6)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        getSize(context, 1.8)),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isPasswordHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    color: MyTheme.mainbuttontext,
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordHidden = !_isPasswordHidden;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: getHeight(context, 0.02)),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        color: MyTheme.mainbuttontext,
                                        fontSize: getSize(context, 1.9)),
                                  ),
                                ),
                              ),
                              SizedBox(height: getHeight(context, 0.025)),
                              InkWell(
                                onTap: () {
                                  String username = _usernameController.text;
                                  String password = _passwordController.text;
                                  _login(username, password);
                                },
                                child: Container(
                                  height: getHeight(context, 0.06),
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: MyTheme.mainbutton,
                                    borderRadius: BorderRadius.circular(
                                        getSize(context, 2.5)),
                                  ),
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: MyTheme.mainbuttontext,
                                      fontWeight: FontWeight.w600,
                                      fontSize: getSize(context, 2.8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
