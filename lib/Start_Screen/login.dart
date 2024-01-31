// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:smartclassmate/masterpage/studentmaster.dart';
import 'package:smartclassmate/masterpage/teachermaster.dart';
import 'package:smartclassmate/tools/helper.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      // alignment: Alignment.topCenter,
                      width: double.infinity,
                      height: getHeight(context, 0.20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(20, 20),
                          bottomRight: Radius.elliptical(20, 20),
                        ),
                        color: Color.fromARGB(255, 76, 136, 15),
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
                            const Text(
                              "APP LOGO",
                            ),
                            SizedBox(
                              height: getHeight(context, 0.01),
                            ),
                            Text(
                              "Welcome back",
                              style: TextStyle(
                                  fontSize: getSize(context, 3),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: getHeight(context, 0.01),
                            ),
                            Text(
                              "Please log in to continue and get the best form our app",
                              style: TextStyle(
                                  fontSize: getSize(context, 1.8),
                                  color: Colors.white),
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
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(getSize(context, 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login or Sign up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getSize(context, 2.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: getHeight(context, 0.02)),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(getSize(
                                    context,
                                    1.8)), // Adjust the value as needed
                              ),
                            ),
                          ),
                          SizedBox(height: getHeight(context, 0.025)),
                          TextField(
                            controller: _passwordController,
                            obscureText: _isPasswordHidden,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(getSize(
                                    context,
                                    1.8)), // Adjust the value as needed
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                color: Color.fromARGB(255, 76, 136, 15),
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
                              onTap: () {
                                // Add your 'Forgot Password' logic here
                                // For example, show a dialog or navigate to a forgot password page
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 76, 136, 15),
                                    fontSize: getSize(context, 1.9)),
                              ),
                            ),
                          ),
                          SizedBox(height: getHeight(context, 0.025)),
                          InkWell(
                            onTap: () {
                              String username = _usernameController.text;
                              String password = _passwordController.text;
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

                              // Add your authentication logic here
                              // For example, you can check credentials against a database

                              // For simplicity, let's just print the credentials for now
                            },
                            child: Container(
                              height: getHeight(context, 0.06),
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 76, 136, 15),
                                borderRadius: BorderRadius.circular(
                                    getSize(context, 2.5)),
                              ),
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
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
