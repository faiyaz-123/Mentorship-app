import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mentor_app/admin.dart';
import 'package:mentor_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentor_app/mentor.dart';
import 'package:mentor_app/registration.dart';
import 'package:mentor_app/student.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyLogin(),
    );
  }
}

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  void _login(context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final db = await FirebaseFirestore.instance;

      switch (_selectedRole) {
        case "Admin":
          // Admin login logic
          print("Admin login: $_username, $_password");
          //NAVIGATE HERE
          db
              .collection("admins")
              .where("email", isEqualTo: _username)
              .get()
              .then(
            (querySnapshot) {
              if (querySnapshot.docs.isEmpty)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invalid Credentials!'),
                  ),
                );
              else {
                try {
                  final userlog = FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _username, password: _password);
                } catch (e) {
                  print(e);
                }
              }
            },
            onError: (e) => print("Error completing: $e"),
          );

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminPage()));
          break;
        case "Mentor":
          // Staff login logic
          print("Mentor login: $_username, $_password");
          db
              .collection("mentors")
              .where("email", isEqualTo: _username)
              .get()
              .then(
            (querySnapshot) {
              if (querySnapshot.docs.isEmpty)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invalid Credentials!'),
                  ),
                );
              else {
                try {
                  final userlog = FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _username, password: _password);
                } catch (e) {
                  print(e);
                }
              }
            },
            onError: (e) => print("Error completing: $e"),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MentorPage(mentorId: _username)));
          break;
        case "Student":
          // Student login logic
          print("Student login: $_username, $_password");
          db
              .collection("students")
              .where("email", isEqualTo: _username)
              .get()
              .then(
            (querySnapshot) {
              if (querySnapshot.docs.isEmpty)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invalid Credentials!'),
                  ),
                );
              else {
                try {
                  final userlog = FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _username, password: _password);
                } catch (e) {
                  print(e);
                }
              }
            },
            onError: (e) => print("Error completing: $e"),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentPage(studentId: _username)));

          break;
        default:
          break;
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  String _selectedRole = "Admin"; // Def
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STUDENT MENTORSHIP APP"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Image.network(
                    "https://sanjivaniacs.org.in/wp-content/uploads/mentor-ic.jpg"),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: "Username"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your username";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value ?? "";
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Password"),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value ?? "";
                        },
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        items:
                            ["Admin", "Mentor", "Student"].map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value ?? "Admin";
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Select Role",
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StudentRegistrationForm()));
                              // print("H");
                            },
                            child: Text("Register as Student"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _login(context);
                              // print("H");
                            },
                            child: Text("Login"),
                          ),
                        ],
                      ),
                    ],
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
