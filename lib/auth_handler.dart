import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myclassroom/HodAdmin/hod_dashboard.dart';
import 'package:myclassroom/Teacher/teacher_dashboard.dart';
import 'package:myclassroom/dashboard_screen.dart';
import 'package:myclassroom/register_or_login.dart';
import 'package:myclassroom/role_selection_screen.dart';

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        User? user = snapshot.data;
        if (user == null) {
          return RegisterOrLoginScreen();
        }

        return FutureBuilder<String?>(
          future: getUserRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            String? role = roleSnapshot.data;
            bool isEmailVerified = user.emailVerified;

            if (!isEmailVerified) {
              return RoleSelectionScreen();
            }

            switch (role) {
              case "student":
                return DashboardScreen();
              case "teacher":
                return TeacherDashboard();
              case "hod":
                return HodDashboard();
              default:
                return RegisterOrLoginScreen();
            }
          },
        );
      },
    );
  }


  Future<String?> getUserRole(String uid) async {
    try {

      DocumentSnapshot studentDoc =
      await FirebaseFirestore.instance.collection("students").doc(uid).get();
      if (studentDoc.exists) return "student";

      DocumentSnapshot teacherDoc =
      await FirebaseFirestore.instance.collection("teachers").doc(uid).get();
      if (teacherDoc.exists) return "teacher";

      DocumentSnapshot hodDoc =
      await FirebaseFirestore.instance.collection("hods").doc(uid).get();
      if (hodDoc.exists) return "hod";

      return null;
    } catch (e) {
      print(" Error fetching user role: $e");
      return null;
    }
  }
}
