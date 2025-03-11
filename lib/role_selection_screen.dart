import 'package:flutter/material.dart';
import 'package:myclassroom/HodAdmin/hod_registration_screen.dart';
import 'package:myclassroom/Teacher/teacher_registration_screen.dart';
import 'student_login_screen.dart';
import 'Teacher/teacher_login_screen.dart';
import 'HodAdmin/hod_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Your Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StudentLoginScreen()));
              },
              child: Text("Login as Student"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherLoginScreen()));
              },
              child: Text("Login as Teacher"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HodLoginScreen()));
              },
              child: Text("Login as HOD"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HodRegistrationScreen()));
              },
              child: Text("Register as HOD"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherRegistrationScreen()));
              },
              child: Text("Register as Teacher"),
            ),
          ],
        ),
      ),
    );
  }
}
