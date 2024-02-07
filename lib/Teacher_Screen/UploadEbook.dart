// ignore_for_file: use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class UploadEbook extends StatefulWidget {
  const UploadEbook({Key? key}) : super(key: key);

  @override
  State<UploadEbook> createState() => _UploadEbookState();
}

Future<void> _pickBook(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    String selectedFileName = result.files.single.name;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text(
            'You are Uploading $selectedFileName for all Students',
            style: TextStyle(
              color: MyTheme.textcolor,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(MyTheme.mainbutton),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the value as needed
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text(
                  'Upload',
                  style: TextStyle(
                    color: MyTheme.mainbuttontext,
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      MyTheme.button2.withOpacity(0.2)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the value as needed
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: MyTheme.button2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UploadEbookState extends State<UploadEbook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.mainbackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Uploaded Ebooks List',
          style: TextStyle(
              color: MyTheme.textcolor,
              fontSize: getSize(context, 2.8),
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: MyTheme.button1,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            mycards("Book1", "18-1-23", "All"),
            mycards("Book2", "19-1-23", "Vedant"),
            mycards("Book3", "20-1-23", "All"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickBook(context),
        tooltip: 'Upload Ebook',
        child: Icon(Icons.add),
        backgroundColor: MyTheme.highlightcolor,
      ),
    );
  }

  Widget mycards(String bookname, String uploaddate, String receiver) {
    return Padding(
      padding: EdgeInsets.all(getSize(context, 1.2)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getSize(context, 1.2)),
          color: MyTheme.background,
          border: Border.all(
              color: MyTheme.textcolor.withOpacity(0.3),
              width: getWidth(context, 0.004)),
        ),
        child: Padding(
          padding: EdgeInsets.all(getSize(context, 0.9)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: getWidth(context, 0.03),
                  ),
                  Text(
                    bookname,
                    style: TextStyle(
                        color: MyTheme.textcolor,
                        fontSize: getSize(context, 2.5),
                        fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: TextSpan(
                      text: uploaddate,
                      style: TextStyle(
                        fontSize: getSize(context, 2),
                        color: MyTheme.button1,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' to ',
                          style: TextStyle(color: MyTheme.textcolor),
                        ),
                        TextSpan(
                          text: receiver,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyTheme.textcolor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.download,
                    size: getSize(context, 3),
                    color: MyTheme.highlightcolor,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
