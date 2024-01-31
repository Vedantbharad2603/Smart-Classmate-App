import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class STMessage extends StatefulWidget {
  const STMessage({Key? key}) : super(key: key);

  @override
  State<STMessage> createState() => _STMessageState();
}

class _STMessageState extends State<STMessage> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> updates = [
    {
      'datetime': '2024-02-02 11:30:26.953530',
      'description': 'Tomorrow we have conversation',
    },
    {
      'datetime': '2024-02-02 11:35:26.953530',
      'description': 'Jhanvi and her group have GD',
    },
    {
      'datetime': '2024-02-02 11:28:26.953530',
      'description': 'All the group member have to report me before 4:30.',
    },
  ];
  Future<void> _handleRefresh() async {
    // Simulate reloading data (replace this with your actual refresh logic)
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      updates = updates;
    });
  }

  @override
  Widget build(BuildContext context) {
    updates.sort((a, b) =>
        DateTime.parse(a['datetime']).compareTo(DateTime.parse(b['datetime'])));
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.mainbackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            "Update",
            style: TextStyle(
                color: MyTheme.textcolor,
                fontSize: getSize(context, 2.7),
                fontWeight: FontWeight.bold),
          ),
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.notifications_none,
            //     size: getSize(context, 3),
            //     color: MyTheme.textcolor,
            //   ),
            // ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => STProfilePage(),
                //   ),
                // );
              },
              child: Padding(
                padding: EdgeInsets.only(
                    right: getSize(context, 1),
                    top: getHeight(context, 0.007),
                    bottom: getHeight(context, 0.007)),
                child: CircleAvatar(
                  radius: getSize(context, 3),
                  backgroundColor: MyTheme.highlightcolor,
                  child: Icon(Icons.person,
                      color: MyTheme.background, size: getSize(context, 3.6)),
                ),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: updates.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      message: updates[index]['description'],
                      dateTime: updates[index]['datetime'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String dateTime;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    String formattedDateTime =
        DateFormat('dd/MM/yyyy  HH:mm').format(parsedDateTime);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MyTheme.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: MyTheme.boxshadow,
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MyTheme.textcolor,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                formattedDateTime,
                style: TextStyle(
                  color: MyTheme.button1.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
