import 'package:flutter/material.dart';

import 'animated_button.dart';

class RegisterOrLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyClassroom",style: TextStyle(color: Colors.white, fontSize: 20),),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.school, size: 80, color: Colors.deepPurple), // 🎓 Icon
                SizedBox(height: 20),
                Text(
                  "Welcome to MyClassroom",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Please Register or Login to Get Started",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 30),
                AnimatedButton(
                  text: "Register",
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // Navigate to Register
                  },
                ),
                SizedBox(height: 20),
                AnimatedButton(
                  text: "Login",
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // Navigate to Login
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
