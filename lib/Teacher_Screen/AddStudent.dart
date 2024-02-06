import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String selectedCourse = 'Not Selected';

  final List<String> courses = [
    'Not Selected',
    'Course A',
    'Course B',
    'Course C',
    'Course D',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyTheme.mainbackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: MyTheme.button1,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add Student', style: TextStyle(color: MyTheme.textcolor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildMyTextField("First Name", firstNameController, width, "String",
                255, context),
            buildMyTextField(
                "Last Name", lastNameController, width, "String", 255, context),
            buildMyTextField(
                "Password", lastNameController, width, "String", 8, context),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Select Course",
                style: TextStyle(color: MyTheme.textcolor, fontSize: 20),
              ),
            ),
            buildmainDropdown(selectedCourse, (value) {
              setState(() {
                selectedCourse = value!;
              });
            }, context, courses),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: getHeight(context, 0.05),
                  width: getWidth(context, 0.38),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: MyTheme.mainbutton,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Add Student',
                    style: TextStyle(
                      color: MyTheme.mainbuttontext,
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.06,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getHeight(context, 0.02),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildmainDropdown(String selectedValue, Function(String?) onChanged,
      context, List<String> types) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(height * 0.011),
      child: Container(
        padding: EdgeInsets.only(left: height * 0.016, right: height * 0.016),
        decoration: BoxDecoration(
          color: MyTheme.background,
          borderRadius: BorderRadius.circular(height * 0.02),
        ),
        child: DropdownButton<String>(
          dropdownColor: MyTheme.background,
          value: selectedValue,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          iconSize: height * 0.04,
          isExpanded: true,
          underline: const SizedBox(),
          style: TextStyle(color: MyTheme.textcolor, fontSize: height * 0.018),
          items: types.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ignore: unused_element
  bool _validateFields() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        // ignore: unnecessary_null_comparison
        selectedCourse != null;
  }
}
