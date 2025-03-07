import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentRegistrationForm extends StatefulWidget {
  @override
  _StudentRegistrationFormState createState() =>
      _StudentRegistrationFormState();
}

class _StudentRegistrationFormState extends State<StudentRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Declare variables to store form data
  String fullName = '';
  String usn = '';
  String phno = '';
  String email = '';
  String pass = '';
  // Add more variables for other form fields...
  Future<void> fireRegister(String fullname, String usn, String phno,
      String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final db = FirebaseFirestore.instance;
      db.collection('students').doc(usn).set({
        'contact': phno,
        'name': fullname,
        'email': email,
        'usn': usn,
        'assignedto': ''
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Student Registration Form'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    fullName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'USN'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your USN';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contact'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Contact No.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phno = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email id';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Create Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    pass = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                /*               TextFormField(
                  decoration: InputDecoration(labelText: 'Emergency Contact'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Emergency Contacts';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Aadhar number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Aadhar no';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Father\'s name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your father\'s name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Father\'s occupation'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your father\'s occupation';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Father\'s contact'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your father\'s contact';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mother\'s name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mother\'s name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mother\'s occupation'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mother\'s occupation';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mother\'s contact'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mother\'s contact';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Date of birth'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your DOB';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Blood Group'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your blood group';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    usn = value!;
                  },
                ),
                // Add more TextFormField widgets for other form fields...
                SizedBox(height: 20),
*/
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      fireRegister(fullName, usn, phno, email, pass);
                      // Process the form data (e.g., send to a server or save locally)

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration successful!'),
                        ),
                      );
                    }
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
