// student_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  final String studentId;
  StudentPage({required this.studentId});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  String? assignedTeacherId;
  int status = 0;

  Future<String> getMentorId() async {
    QuerySnapshot<Map<String, dynamic>>? temp;
    try {
      temp = await FirebaseFirestore.instance
          .collection('students')
          .where('email', isEqualTo: widget.studentId)
          .get();
    } catch (e) {
      print(e);
    }
    if (temp == null || temp.docs.first['assignedto'] == '') return '';
    return temp.docs.first['assignedto'];
  }

  Future<String> getMentorName(String id) async {
    return await FirebaseFirestore.instance
        .collection('mentors')
        .doc(id)
        .get()
        .then((value) => value.data()!['name']);
  }

  startWork() async {
    String tempid = await getMentorId();
    assignedTeacherId = await getMentorName(tempid);
    setState(() {
      status = 1;
    });
  }

  void initState() {
    super.initState();
    startWork();
  }

  @override
  Widget build(BuildContext context) {
    if (status == 1)
      return Scaffold(
        appBar: AppBar(
          title: Text('Student Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Student!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Assigned Teacher: $assignedTeacherId',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    else
      return Center(
        child: CircularProgressIndicator(),
      );
  }
}
