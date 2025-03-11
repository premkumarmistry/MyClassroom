import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myclassroom/Choose_login.dart';



class HodDashboard extends StatefulWidget {
  @override
  _HodDashboardState createState() => _HodDashboardState();
}

class _HodDashboardState extends State<HodDashboard> {
  String hodName = "HOD";
  String hodDepartment = "Department";
  String greetingMessage = "Welcome!";

  @override
  void initState() {
    super.initState();
    fetchHodDetails();
    setGreetingMessage();
  }


  void fetchHodDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot hodDoc = await FirebaseFirestore.instance.collection("hods").doc(user.uid).get();
      if (hodDoc.exists) {
        setState(() {
          hodName = hodDoc["name"] ?? "HOD";
          hodDepartment = hodDoc["department"] ?? "Department";
        });
      }
    }
  }


  void setGreetingMessage() {
    int hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      greetingMessage = "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      greetingMessage = "Good Afternoon";
    } else {
      greetingMessage = "Good Evening";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("HOD Dashboard", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "$greetingMessage, $hodName!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            Text(
              "Department: $hodDepartment",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 20),


            Expanded(
              child: ListView(
                children: [
                  buildDashboardCard(
                    title: "Assign Subjects to Teachers",
                    icon: Icons.assignment_ind,
                    color: Colors.green,
                    onTap: () {
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => AssignTeacherScreen()));
                    },
                  ),
                  SizedBox(height: 20),
                  buildDashboardCard(
                    title: "Revoke Teacher Access",
                    icon: Icons.remove_circle_outline,
                    color: Colors.redAccent,
                    onTap: () {
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => RevokeTeacherAccessScreen()));
                    },
                  ),
                  SizedBox(height: 20),
                  buildDashboardCard(
                    title: "Verify Teachers",
                    icon: Icons.verified_user,
                    color: Colors.blue,
                    onTap: () {
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyTeachersScreen()));
                    },
                  ),
                  SizedBox(height: 20),
                  /// **🔹 Logout Card**
                  buildDashboardCard(
                    title: "Announcements",
                    icon: Icons.announcement_rounded,
                    color: Colors.lightBlueAccent,
                    onTap: () {
                  //    Navigator.push(context, MaterialPageRoute(builder: (context) => HodUploadAnnouncementScreen()));
                    }
                  ),
                  SizedBox(height: 20),

                  buildDashboardCard(
                      title: "Manage Announcements",
                      icon: Icons.announcement_rounded,
                      color: Colors.lightBlueAccent,
                      onTap: () {
                      //  Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAnnouncementsScreen()));
                      }
                  ),
                  SizedBox(height: 20),
                  buildDashboardCard(
                    title: "View List of Students",
                    icon: Icons.people,
                    color: Colors.blue,
                    onTap: () {
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => StudentListScreen(hodDepartment)));
                    },
                  ),
                  SizedBox(height: 20),
                  buildDashboardCard(
                    title: "View List of Teachers",
                    icon: Icons.school,
                    color: Colors.orange,
                    onTap: () {
                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherListScreen(hodDepartment)));
                    },
                  ),
                  SizedBox(height: 20),
                      /// **🔹 Logout Card**
                      buildDashboardCard(
                      title: "Logout",
                      icon: Icons.logout,
                      color: Colors.redAccent,
                      onTap: () => _logout(context),
                      ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildDashboardCard({required String title, required IconData icon, required Color color, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2)],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

void _logout(BuildContext context) async {
  bool confirmLogout = await _showLogoutConfirmationDialog(context);
  if (confirmLogout) {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ChooseLogin()), // 🔹 Redirect to Choose Login Page
          (route) => false,
    );
  }
}


Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Logout Confirmation"),
      content: Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("Logout", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  ) ??
      false;
}