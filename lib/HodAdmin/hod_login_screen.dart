import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hod_dashboard.dart';

class HodLoginScreen extends StatefulWidget {
  @override
  _HodLoginScreenState createState() => _HodLoginScreenState();
}

class _HodLoginScreenState extends State<HodLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;


  void loginHod() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields!")));
      return;
    }

    setState(() => isLoading = true);

    try {

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed!")));
        return;
      }


      if (!user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please verify your email before logging in!")));
        return;
      }


      DocumentSnapshot userDoc = await _firestore.collection("hods").doc(user.uid).get();
      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not found in HODs database!")));
        return;
      }


      bool isVerified = userDoc["isVerified"] ?? false;
      if (!isVerified) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Admin has not verified your account yet!")));
        return;
      }


      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HodDashboard()));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("HOD Login", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "HOD Login",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    SizedBox(height: 20),


                    buildTextField("Email", emailController, isEmail: true),


                    buildTextField("Password", passwordController, isPassword: true),

                    SizedBox(height: 25),


                    GestureDetector(
                      onTap: loginHod,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget buildTextField(String label, TextEditingController controller, {bool isEmail = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: isEmail
              ? Icon(Icons.email, color: Colors.deepPurple)
              : isPassword
              ? Icon(Icons.lock, color: Colors.deepPurple)
              : Icon(Icons.person, color: Colors.deepPurple),
        ),
        validator: (value) {
          if (value!.isEmpty) return "Enter $label";
          return null;
        },
      ),
    );
  }
}
