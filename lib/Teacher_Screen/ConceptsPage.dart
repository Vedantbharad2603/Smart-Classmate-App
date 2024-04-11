import 'package:flutter/material.dart';
import 'package:smartclassmate/tools/theme.dart';

class ConceptsPage extends StatefulWidget {
  final int courseid;
  final String courseName;

  ConceptsPage({Key? key, required this.courseid, required this.courseName})
      : super(key: key);

  @override
  _ConceptsPageState createState() => _ConceptsPageState();
}

class _ConceptsPageState extends State<ConceptsPage> {
  TextEditingController _conceptController = TextEditingController();
  String? _selectedConcept;

  List<String> _editableConcepts = [];
  List<String> concepts = [];

  @override
  void initState() {
    super.initState();
    // Create a copy of the concepts list to make it modifiable
    // _editableConcepts.addAll(widget.concepts);
  }

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
        title: Text('Concepts', style: TextStyle(color: MyTheme.textcolor)),
      ),
      body: ListView.builder(
        itemCount: _editableConcepts.length,
        itemBuilder: (context, index) {
          String concept = _editableConcepts[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedConcept = concept;
                });
                _showConceptOptions(context);
              },
              child: Card(
                color: MyTheme.background,
                elevation: 5.0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    concept,
                    style: TextStyle(color: MyTheme.textcolor, fontSize: 16.0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyTheme.mainbutton,
        onPressed: () {
          _showAddConceptDialog(context);
        },
        child: Icon(Icons.add, color: MyTheme.mainbuttontext),
      ),
    );
  }

  void _showAddConceptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text(
            "Add Concept",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: TextField(
            style: TextStyle(color: MyTheme.textcolor),
            controller: _conceptController,
            decoration: InputDecoration(
                labelText: 'Concept Name',
                labelStyle: TextStyle(color: MyTheme.textcolor)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: MyTheme.button2),
              ),
            ),
            TextButton(
              onPressed: () {
                String newConcept = _conceptController.text;
                setState(() {
                  _editableConcepts.add(newConcept);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                "Add",
                style: TextStyle(color: MyTheme.button1),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConceptOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: MyTheme.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: MyTheme.button1,
                ),
                title: Text(
                  'Edit Concept',
                  style: TextStyle(color: MyTheme.textcolor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showEditConceptDialog(context, _selectedConcept!);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.upload_file,
                  color: MyTheme.button1,
                ),
                title: Text(
                  'Upload PDF',
                  style: TextStyle(color: MyTheme.textcolor),
                ),
                onTap: () {
                  // Implement PDF upload logic here
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditConceptDialog(BuildContext context, String concept) {
    _conceptController.text = concept;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyTheme.background,
          title: Text(
            "Edit Concept",
            style: TextStyle(color: MyTheme.textcolor),
          ),
          content: TextField(
            style: TextStyle(color: MyTheme.textcolor),
            controller: _conceptController,
            decoration: InputDecoration(
              labelText: 'Concept Name',
              labelStyle: TextStyle(color: MyTheme.textcolor),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: MyTheme.button2),
              ),
            ),
            TextButton(
              onPressed: () {
                String editedConcept = _conceptController.text;
                int index = _editableConcepts.indexOf(concept);
                setState(() {
                  _editableConcepts[index] = editedConcept;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                "Save",
                style: TextStyle(color: MyTheme.button1),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _conceptController.dispose();
    super.dispose();
  }
}
