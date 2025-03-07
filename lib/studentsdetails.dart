import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentDetails extends StatefulWidget {
  final String usn;
  const StudentDetails({super.key, required this.usn});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text("WORKS")),
    );
  }
}


class StudentPerformancePage extends StatefulWidget {
  final String usn;

  StudentPerformancePage({super.key, required this.usn});

  @override
  _StudentPerformancePageState createState() => _StudentPerformancePageState();
}

class _StudentPerformancePageState extends State<StudentPerformancePage> {
  int status = 0;
  Map<String,dynamic>? perf;
  String academicPerformance = '';
  String feedback = '';
  Future<Map<String, dynamic>> getStudent(usn) async {
    DocumentSnapshot<Map<String, dynamic>> student =
    await FirebaseFirestore.instance.collection('students').doc(usn).get();

    return {'name':student['name'], 'usn':student['usn']};
    // List<dynamic> studentsid = querySnapshot['assigned'];
    // List<Map<String, dynamic>> res = [];
    // for(var students in studentsid) {
    //   DocumentSnapshot<Map<String, dynamic>> studlist = await FirebaseFirestore
    //       .instance.collection('students').doc(students).get();
    //   res.add({'name': studlist['name'], 'usn':studlist['usn']});
    // }
    // return res;
  }

  startwork () async{
    perf = await getStudent(widget.usn);
    setState(() {
      status = 1;
    });
    print(perf);
  }

  void initState(){
    super.initState();
    startwork();
  }
  @override
  Widget build(BuildContext context) {
    if(status == 1)
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Performance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student ID: ${perf!['name']} | Name: ${perf!['usn']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Academic Performance'),
              onChanged: (value) {
                setState(() {
                  academicPerformance = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Feedback'),
              onChanged: (value) {
                setState(() {
                  feedback = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the academic performance and feedback data
                savePerformanceAndFeedback();

                // Navigate back to the mentor detail page
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
    else
      return Center(child: CircularProgressIndicator(),);
  }

  void savePerformanceAndFeedback() {
    // Implement the logic to save the academic performance and feedback for the student
    print('Saving performance and feedback for ${perf!['name']}');
    print('Academic Performance: $academicPerformance');
    print('Feedback: $feedback');
    // Add your data storage logic here (e.g., Firebase, local storage, etc.)
  }
}

