import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myclassroom/HodAdmin/hod_registration_screen.dart';
import 'package:myclassroom/StudentRegistrationScreen.dart';
import 'package:myclassroom/Teacher/teacher_registration_screen.dart';


class ChooseRegister extends StatefulWidget {
  @override
  _ChooseRegisterState createState() => _ChooseRegisterState();
}

class _ChooseRegisterState extends State<ChooseRegister> {
  bool studentEnabled = false;
  bool teacherEnabled = false;
  bool hodEnabled = false;
  String studentMessage = "";
  String teacherMessage = "";
  String hodMessage = "";

  @override
  void initState() {
    super.initState();
    fetchRegistrationStatus();
  }


  Future<void> fetchRegistrationStatus() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot studentDoc = await firestore.collection("registration_control").doc("students").get();
      DocumentSnapshot teacherDoc = await firestore.collection("registration_control").doc("teachers").get();
      DocumentSnapshot hodDoc = await firestore.collection("registration_control").doc("hods").get();

      setState(() {
        studentEnabled = studentDoc["isEnabled"];
        teacherEnabled = teacherDoc["isEnabled"];
        hodEnabled = hodDoc["isEnabled"];

        studentMessage = studentDoc["message"];
        teacherMessage = teacherDoc["message"];
        hodMessage = hodDoc["message"];
      });
    } catch (e) {
      print(" Error fetching registration status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("Register as", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildRoleCard(
              context,
              title: "Student",
              imagePath: "assets/student.png",
              isEnabled: studentEnabled,
              message: studentMessage,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentRegistrationScreen())),
            ),
            SizedBox(height: 20),
            buildRoleCard(
              context,
              title: "Teacher",
              imagePath: "assets/professor.png",
              isEnabled: teacherEnabled,
              message: teacherMessage,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherRegistrationScreen())),
            ),
            SizedBox(height: 20),
            buildRoleCard(
              context,
              title: "HoD",
              imagePath: "assets/hod.png",
              isEnabled: hodEnabled,
              message: hodMessage,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HodRegistrationScreen())),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildRoleCard(BuildContext context,
      {required String title, required String imagePath, required bool isEnabled, required String message, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: isEnabled ? onTap : () => showDisabledMessage(context, message),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 100,
        decoration: BoxDecoration(
          gradient: isEnabled ? LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]) : LinearGradient(colors: [Colors.grey, Colors.grey.shade200]),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2)],
        ),
        child: Row(
          children: [
            SizedBox(width: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Image.asset(imagePath, width: 50, height: 50),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }


  void showDisabledMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
