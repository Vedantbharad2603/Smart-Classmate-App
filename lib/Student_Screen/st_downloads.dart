// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class StDownloads extends StatefulWidget {
  const StDownloads({Key? key}) : super(key: key);

  @override
  State<StDownloads> createState() => _UploadEbookState();
}

class _UploadEbookState extends State<StDownloads> {
  bool _isLoading = false;
  bool isListEmpty = true;

  Future<List<Map<String, dynamic>>> listFiles() async {
    List<Map<String, dynamic>> files = [];
    final ListResult result =
        await FirebaseStorage.instance.ref('books').listAll();
    isListEmpty = false;
    await Future.forEach(result.items, (Reference ref) async {
      String downloadUrl = await ref.getDownloadURL();
      var metadata = await ref.getMetadata();
      files.add(
          {'name': ref.name, 'url': downloadUrl, 'date': metadata.updated});
    });
    if (files.isEmpty) {
      isListEmpty = !isListEmpty;
    }

    return files;
  }

  @override
  void initState() {
    super.initState();
    listFiles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? Container(
              color: MyTheme.background,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeAlign: 2,
                      color: MyTheme.button1,
                      backgroundColor: MyTheme.background,
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
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
              body: FutureBuilder<List<Map<String, dynamic>>>(
                future: listFiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      strokeAlign: 2,
                      color: MyTheme.button1,
                      backgroundColor: MyTheme.background,
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading files"));
                  } else {
                    final files = snapshot.data!;
                    return isListEmpty
                        ? Text(
                            "You Don't Have Any Document",
                            style: TextStyle(color: MyTheme.textcolor),
                          )
                        : ListView.builder(
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              var file = files[index];
                              return mycards(
                                  file['name'],
                                  DateFormat('dd-MM-yyyy').format(file['date']),
                                  file['url']);
                            },
                          );
                  }
                },
              ),
            ),
    );
  }

  Future<void> downloadFile(String url, String fileName) async {
    log("HEllO form ownloadFile");
    // Get the directory for the Pictures folder
    final String picturesPath = '/storage/emulated/0/Download/';

    // Create the Pictures folder if it doesn't exist
    if (!await Directory(picturesPath).exists()) {
      await Directory(picturesPath).create(recursive: true);
    }
    String filePath = "";

    filePath = '$picturesPath$fileName';

    Dio dio = Dio();

    try {
      await dio.download(url, filePath);
      log("Done");
      // print("Done");
      Get.snackbar("Success", "File downloaded Successfully",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          onTap: (snack) => OpenFilex.open(filePath));
    } catch (e) {
      log(":( + $e");
      Get.snackbar("Error", "Failed to download file",
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  Widget mycards(String bookname, String uploaddate, String url) {
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
                  Text(
                    uploaddate,
                    style: TextStyle(
                      fontSize: getSize(context, 2),
                      color: MyTheme.button1,
                    ),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    downloadFile(url, bookname);
                  },
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
