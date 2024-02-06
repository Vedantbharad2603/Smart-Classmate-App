import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartclassmate/tools/helper.dart';
import 'package:smartclassmate/tools/theme.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class Message {
  final String datetime;
  final String description;

  Message({required this.datetime, required this.description});
}

class _MessagesState extends State<Messages> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> updates = [
    Message(
      datetime: '2024-02-01 11:30:26.953530',
      description: 'Tomorrow we have a conversation',
    ),
    Message(
      datetime: '2024-02-01 11:35:26.953530',
      description: 'Jhanvi and her group have GD',
    ),
    Message(
      datetime: '2024-02-01 11:28:26.953530',
      description: 'All the group members have to report to me before 4:30.',
    ),
  ];

  final ScrollController _scrollController = ScrollController();

  bool _shouldShowDateHeader(int index) {
    if (index == 0) {
      return true; // Always show date header for the first message
    }

    DateTime currentDate = DateTime.parse(updates[index].datetime);
    DateTime previousDate = DateTime.parse(updates[index - 1].datetime);

    return currentDate.day != previousDate.day ||
        currentDate.month != previousDate.month ||
        currentDate.year != previousDate.year;
  }

  Future<void> _handleRefresh() async {
    // Simulate reloading data (replace this with your actual refresh logic)
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      updates = updates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.mainbackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            "Messages",
            style: TextStyle(
              color: MyTheme.textcolor,
              fontSize: getSize(context, 2.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                giveuserinfo(
                    'Username: Vedant Bharad', 'Password: Ved@nt123', context);
              },
              child: Padding(
                padding: EdgeInsets.only(
                  right: getSize(context, 1),
                  top: getHeight(context, 0.007),
                  bottom: getHeight(context, 0.007),
                ),
                child: CircleAvatar(
                  radius: getSize(context, 3),
                  backgroundColor: MyTheme.highlightcolor,
                  child: Icon(Icons.person,
                      color: Colors.black, size: getSize(context, 3.6)),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: updates.length,
                  itemBuilder: (context, index) {
                    bool showDateHeader = _shouldShowDateHeader(index);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDateHeader)
                          Center(
                            child: Container(
                              height: 30,
                              width: getWidth(context, 0.50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MyTheme.background,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat('MMMM d, yyyy').format(
                                    DateTime.parse(updates[index].datetime),
                                  ),
                                  style: TextStyle(
                                    color: MyTheme.textcolor.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ChatBubble(
                          message: updates[index].description,
                          dateTime: updates[index].datetime,
                          onDelete: () => _deleteMessage(index),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: MyTheme
                              .background, // Set your desired background color
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: MyTheme.textcolor.withOpacity(0.6),
                              width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextField(
                          style:
                              TextStyle(color: MyTheme.textcolor, fontSize: 18),
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Messages',
                            hintStyle: TextStyle(
                                color: MyTheme.textcolor.withOpacity(0.6),
                                fontSize: 18),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            // border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: MyTheme.mainbutton,
                    ),
                    child: IconButton(
                      onPressed: _addNewMessage,
                      icon: const Icon(Icons.send),
                      color: MyTheme
                          .mainbuttontext, // Set your desired button color
                      padding: const EdgeInsets.all(8),
                      splashRadius: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewMessage() {
    if (_messageController.text.isNotEmpty) {
      DateTime now = DateTime.now();
      String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(now);

      setState(() {
        updates.add(
          Message(
            datetime: formattedDateTime,
            description: _messageController.text,
          ),
        );
        _messageController.clear();
        // Scroll to the bottom after adding a new message
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _deleteMessage(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text(
            'Delete Message',
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: Text(
            'Are you sure you want to delete this message?',
            style: TextStyle(color: MyTheme.textcolor),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(MyTheme.button2.withOpacity(0.2)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the value as needed
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  updates.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: MyTheme.button2),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    MyTheme.mainbuttontext.withOpacity(0.2)),
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
                style: TextStyle(color: MyTheme.mainbuttontext),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String dateTime;
  final VoidCallback onDelete;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.dateTime,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    String formattedDateTime = DateFormat('hh:mm a').format(parsedDateTime);

    return GestureDetector(
      onLongPress: onDelete,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyTheme.background,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: MyTheme.boxshadow,
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: MyTheme.textcolor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // IconButton(
                    //   onPressed: onDelete,
                    //   icon: Icon(
                    //     Icons.delete,
                    //     color: MyTheme.textcolor.withOpacity(0.7),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDateTime,
                  style: TextStyle(
                    color: MyTheme.textcolor.withOpacity(0.7),
                    fontSize: 12,
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
