import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class StDownloads extends StatefulWidget {
  const StDownloads({super.key});

  @override
  State<StDownloads> createState() => _StMyCoursesState();
}

class _StMyCoursesState extends State<StDownloads> {
  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: getWidth(context, 0.8),
                    child: Expanded(
                      child: Text(
                        'Downloads',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: getSize(context, 2.8),
                            color: MyTheme.textcolor),
                      ),
                    ),
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
                  SizedBox(
                    width: getWidth(context, 0.6),
                    child: Expanded(
                      child: Text(
                        bookname,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: MyTheme.textcolor,
                            fontSize: getSize(context, 2.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getWidth(context, 0.6),
                    child: Expanded(
                      child: Text(
                        uploaddate,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: MyTheme.button1,
                            fontSize: getSize(context, 2)),
                      ),
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
