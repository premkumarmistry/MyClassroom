import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myclassroom/Choose_login.dart';


class TeacherDashboard extends StatefulWidget {
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  String teacherEmail = FirebaseAuth.instance.currentUser?.email ?? "";
  String? assignedBranch;
  List<String> assignedSubjects = [];

  @override
  void initState() {
    super.initState();
    fetchTeacherDetails();
  }


  Future<void> fetchTeacherDetails() async {
    try {
      print("🔍 Fetching details for teacher email: $teacherEmail");

      QuerySnapshot teacherQuery = await FirebaseFirestore.instance
          .collection("teachers")
          .where("email", isEqualTo: teacherEmail)
          .get();

      if (teacherQuery.docs.isNotEmpty) {
        var teacherDoc = teacherQuery.docs.first;
        List<String> subjectsList = List<String>.from(teacherDoc["assigned_subjects"] ?? []);

        setState(() {
          assignedSubjects = subjectsList;
          assignedBranch = teacherDoc["department"] ?? "Unknown Department";
        });

        print(" Assigned Subjects: $assignedSubjects");
        print(" Assigned Branch: $assignedBranch");
      } else {
        print(" No teacher found for email: $teacherEmail");
      }
    } catch (e) {
      print(" Error fetching teacher details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("Teacher Dashboard", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            buildDashboardCard(
              title: "Upload Study Material",
              icon: Icons.upload_file,
              color: Colors.green,
              onTap: () {
              /*  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadMaterialScreen(assignedBranch: assignedBranch, assignedSubjects: assignedSubjects)),
                );*/
              },
            ),

            SizedBox(height: 20),


            buildDashboardCard(
              title: "View Enrolled Students",
              icon: Icons.people_alt,
              color: Colors.blue,
              onTap: () {
              /*  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentListScreen(assignedBranch!)),
                );*/
              },
            ),



            SizedBox(height: 20),

            buildDashboardCard(
              title: "Manage Files",
              icon: Icons.delete_forever,
              color: Colors.redAccent,
              onTap: () {
               /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RemoveDocumentsScreen(
                      assignedBranch: assignedBranch ?? "Unknown",
                      assignedSubjects: assignedSubjects,
                    ),
                  ),
                );*/
              },
            ),
            SizedBox(height: 20),
            buildDashboardCard(
              title: "Manage Folders",
              icon: Icons.folder_delete,
              color: Colors.orange,
              onTap: () {
               /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageFoldersScreen(
                      assignedBranch: assignedBranch ?? "Unknown",
                      assignedSubjects: assignedSubjects,
                    ),
                  ),
                );*/
              },
            ),
            SizedBox(height: 20),

            buildDashboardCard(
              title: "Logout",
              icon: Icons.logout,
              color: Colors.redAccent,
              onTap: () => _logout(context),
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
        child: Padding(
          padding: EdgeInsets.all(20),
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
      MaterialPageRoute(builder: (context) => ChooseLogin()),
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