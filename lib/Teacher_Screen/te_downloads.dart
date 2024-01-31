import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/helper.dart';

class TeDownloads extends StatefulWidget {
  const TeDownloads({super.key});

  @override
  State<TeDownloads> createState() => _StMyCoursesState();
}

class _StMyCoursesState extends State<TeDownloads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 253, 233),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Downloads',
                    style: TextStyle(fontSize: getSize(context, 2.8)),
                  ),
                ),
              ],
            ),
            mycards("Book1", "18-1-23"),
            mycards("Book2", "19-1-23"),
            mycards("Book3", "20-1-23"),
          ],
        ),
      ),
    );
  }

  Widget mycards(String bookname, String uploaddate) {
    return Padding(
      padding: EdgeInsets.all(getSize(context, 1.2)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getSize(context, 1.2)),
          color: Colors.white,
          border:
              Border.all(color: Colors.grey, width: getWidth(context, 0.004)),
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
                        color: Colors.black,
                        fontSize: getSize(context, 2.5),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    uploaddate,
                    style: TextStyle(
                        color: Colors.black, fontSize: getSize(context, 2)),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.download,
                    size: getSize(context, 3),
                    color: Colors.black,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
