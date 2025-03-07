// admin_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String selectedStudent = "";
String selectedTeacher = "";

// student_model.dart
class Student {
  final String id;
  final String name;

  Student({required this.id, required this.name});
}

// staff_model.dart

// mentor_model.dart

// teacher_model.dart
class Teacher {
  final String id;
  final String name;

  Teacher({required this.id, required this.name});
}

// assignment_model.dart

// data_service.dart

Future<List<Map<String, dynamic>>> getUsers(String type) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
  await FirebaseFirestore.instance.collection(type).get();

  List<Map<String, dynamic>> studentsid = [];
  for (var docs in querySnapshot.docs) {
    studentsid.add(docs.data());
  }

  return studentsid;
}

List<Map<String, dynamic>> studentlist = [];
List<Map<String, dynamic>> mentorlist = [];

class DataService {
  Future<Map<String, dynamic>> getStudents(usn) async {
    DocumentSnapshot<Map<String, dynamic>> student =
    await FirebaseFirestore.instance.collection('students').doc(usn).get();

    return {'name': student['name'], 'usn': student['usn']};
  }

  static List<Student> students = [
    Student(id: '1', name: 'Student AAA'),
    Student(id: '2', name: 'Student B'),
    // Add more students
  ];

  static List<Teacher> teachers = [
    Teacher(id: '101', name: 'Teacher X'),
    Teacher(id: '102', name: 'Teacher Y'),
    // Add more teachers
  ];
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int status = 0;
  List<Map<String, String>> assignments = [];
  void assignTeacher(String studentId, String teacherId) {
    final db = FirebaseFirestore.instance;
    db.collection('mentors').doc(teacherId).update({
      'assigned': FieldValue.arrayUnion([studentId])
    });
    db.collection('students').doc(studentId).update({'assignedto': teacherId});
  }

  Future<List<Map<String, String>>> fetchDataFromFirestore() async {
    try {
      // Replace 'mentors' with your collection name
      QuerySnapshot mentorsSnapshot =
      await FirebaseFirestore.instance.collection('mentors').get();

      for (QueryDocumentSnapshot mentorDoc in mentorsSnapshot.docs) {
        String mentorId = mentorDoc.id;

        // Access the 'assigned' array for each mentor
        List<dynamic> assignedArray = mentorDoc['assigned'];

        for (dynamic assignedItem in assignedArray) {
          // Assuming 'assignedItem' is a String, update the type accordingly
          String assignedItemId = assignedItem.toString();

          // Create a map with mentorId and assignedItemId
          Map<String, String> dataMap = {
            'mentorId': mentorId,
            'assignedItemId': assignedItemId
          };

          // Add the map to the result list
          assignments.add(dataMap);
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return assignments;
  }

  void _showAssignmentsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Assignments'),
          content: Column(
            children: [
              for (var assigns in assignments)
                ListTile(
                  title: Text(
                      'Student: ${assigns['assignedItemId']} | Teacher: ${assigns['mentorId']}'),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  startWork() async {
    studentlist = await getUsers('students');
    mentorlist = await getUsers('mentors');
    assignments = await fetchDataFromFirestore();
    print("assign: $assignments");
    print(studentlist);
    print(mentorlist);
    selectedStudent = studentlist.first['usn'];
    selectedTeacher = mentorlist.first['id'];
    setState(() {
      status = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    startWork();
  }

  var test = studentlist.map((Map<String, dynamic> student) {
    return DropdownMenuItem<String>(
      value: student['usn'],
      child: Text(student['name']),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    if (status == 1)
      return Scaffold(
        appBar: AppBar(
          title: Text('Admin Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedStudent,
                onChanged: (String? value) {
                  setState(() {
                    selectedStudent = value!;
                  });
                },
                items: studentlist.map((Map<String, dynamic> student) {
                  return DropdownMenuItem<String>(
                    value: student['usn'],
                    child: Text(student['name']),
                  );
                }).toList(),
                hint: Text('Select Student'),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedTeacher,
                onChanged: (String? value) {
                  setState(() {
                    selectedTeacher = value!;
                  });
                },
                items: mentorlist.map((Map<String, dynamic> mentor) {
                  return DropdownMenuItem<String>(
                    value: mentor['id'],
                    child: Text(mentor['name']),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedStudent.isNotEmpty &&
                      selectedTeacher.isNotEmpty) {
                    assignTeacher(selectedStudent, selectedTeacher);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mentor Assigned!'),
                      ),
                    );
                    // Show a success message or navigate to another page if needed
                  }
                },
                child: Text('Assign Teacher'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showAssignmentsDialog();
                },
                child: Text('Show Assignments'),
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
