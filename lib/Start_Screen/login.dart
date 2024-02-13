// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:smartclassmate/masterpage/studentmaster.dart';
import 'package:smartclassmate/masterpage/teachermaster.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.mainbackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: MyTheme.mainbackground,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
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
                            Text(
                              "Welcome back",
                              style: TextStyle(
                                fontSize: getSize(context, 3),
                                fontWeight: FontWeight.bold,
                                color: MyTheme.textcolor,
                              ),
                            ),
                            SizedBox(
                              height: getHeight(context, 0.01),
                            ),
                            Text(
                              "Please log in to continue and get the best form our app",
                              style: TextStyle(
                                fontSize: getSize(context, 1.8),
                                color: MyTheme.textcolor,
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
                          Text(
                            "Login or Sign up",
                            style: TextStyle(
                              color: MyTheme.textcolor,
                              fontSize: getSize(context, 2.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: getHeight(context, 0.02)),
                          TextField(
                            controller: _usernameController,
                            style: TextStyle(color: MyTheme.textcolor),
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                  color: MyTheme.textcolor.withOpacity(0.6)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyTheme.textcolor.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(
                                  getSize(context, 1.8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyTheme.textcolor.withOpacity(0.8)),
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
                                    color: MyTheme.textcolor.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(
                                  getSize(context, 1.8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyTheme.textcolor.withOpacity(0.8)),
                                borderRadius: BorderRadius.circular(
                                  getSize(context, 1.8),
                                ),
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: MyTheme.textcolor.withOpacity(0.6)),
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
                              // String password = _passwordController.text;
                              if (username == "student") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentMasterPage(),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TeacherMasterPage(),
                                  ),
                                );
                              }
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
      ),
    );
  }
}
