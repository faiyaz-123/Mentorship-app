// mentor_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentor_app/studentsdetails.dart';

class MentorPage extends StatefulWidget {
  final String mentorId;

  MentorPage({required this.mentorId});

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  int status = 0;
  Future<List<Map<String, dynamic>>> getUsers(String mentorId) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('mentors')
            .doc(mentorId)
            .get();
    List<dynamic> studentsid = querySnapshot['assigned'];
    List<Map<String, dynamic>> res = [];
    for (var students in studentsid) {
      DocumentSnapshot<Map<String, dynamic>> studlist = await FirebaseFirestore
          .instance
          .collection('students')
          .doc(students)
          .get();
      res.add({'name': studlist['name'], 'usn': studlist['usn']});
    }
    return res;
  }

  startWork() async {
    QuerySnapshot<Map<String, dynamic>> temp = await FirebaseFirestore.instance
        .collection('mentors')
        .where('email', isEqualTo: widget.mentorId)
        .get();
    String id = temp.docs.first.id;
    studentlist = getUsers(id);
    setState(() {
      status = 1;
    });
  }

  late Future<List<Map<String, dynamic>>> studentlist;
  @override
  void initState() {
    super.initState();
    startWork();
  }

  @override
  Widget build(BuildContext context) {
    if (status == 1)
      return Scaffold(
        appBar: AppBar(
          title: Text('Mentor Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Mentor!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Allocated Students:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: studentlist,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Map<String, dynamic>> userList = snapshot.data ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: userList.map((user) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    StudentPerformancePage(usn: user['usn'])));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white,
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 25,
                                      offset: Offset(0, 4),
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Name: ${user['name']}',
                                          ),
                                        ],
                                      ),

                                      Text(
                                        'USN: ${user['usn']}',
                                      ),

                                      // Add a divider between users
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
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
