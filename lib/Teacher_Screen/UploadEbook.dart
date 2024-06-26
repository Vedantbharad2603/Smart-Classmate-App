// ignore_for_file: use_build_context_synchronously, file_names
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:open_file/open_file.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class UploadEbook extends StatefulWidget {
  const UploadEbook({Key? key}) : super(key: key);

  @override
  State<UploadEbook> createState() => _UploadEbookState();
}

class _UploadEbookState extends State<UploadEbook> {
  bool _isLoading = false;
  bool isListEmpty = true;

  double uploadProgress = 0.0;

  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      if (result.files.single.size > 50 * 1024 * 1024) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(''),
              content: const Text("File Size must be less then 50MB"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      String filePath = 'books/$fileName';
      try {
        setState(() {
          _isLoading = true;
        });
        UploadTask task = FirebaseStorage.instance.ref(filePath).putFile(file);

        // Listen for changes in the upload task
        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            uploadProgress =
                (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        }, onError: (e) {
          // Handle any errors
        });

        // Wait for upload to complete
        await task;

        Get.snackbar("Success", "File Uploaded Successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } on FirebaseException catch (e) {
        Get.snackbar("Error", "Failed to upload file: ${e.message}",
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        "${uploadProgress.floor()} % Uploaded",
                        style: TextStyle(
                            color: MyTheme.button1,
                            fontSize: getSize(context, 2)),
                      ),
                    )
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
                    return const Center(child: Text("Error loading files"));
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
              floatingActionButton: FloatingActionButton(
                onPressed: () => uploadFile(),
                tooltip: 'Upload Ebook',
                backgroundColor: MyTheme.highlightcolor,
                child: const Icon(Icons.add),
              ),
            ),
    );
  }

  Future<void> downloadFile(String url, String fileName) async {
    // Get the directory for the Pictures folder
    const String picturesPath = '/storage/emulated/0/Download/';

    String filePath = '$picturesPath$fileName';
    bool fileExists = File(filePath).existsSync();
    if (fileExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Already Downloaded'),
            content: const Text("The file is already downloaded"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  OpenFile.open(filePath);
                },
                child: const Text('OPEN'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the function if the file is already downloaded
    }

    Dio dio = Dio();

    try {
      await dio.download(url, filePath);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text("File downloaded Successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  OpenFile.open(filePath);
                },
                child: const Text('OPEN'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text("Failed to download file"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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
