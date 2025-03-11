import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myclassroom/Choose_login.dart';
import 'package:myclassroom/splash_screen.dart';
import 'package:myclassroom/Choose_register.dart';

import 'dashboard_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  User? _user;
  bool isEmailVerified = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await user.reload();
        setState(() {
          _user = user;
          isEmailVerified = user.emailVerified;
          _isLoading = false;
        });
      } else {
        setState(() {
          _user = null;
          isEmailVerified = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pariksha Madad Kendra",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      /* _user == null
          ? RegisterOrLoginScreen()
          : isEmailVerified
          ? MainDashboard()
          : RoleSelectionScreen(), */
      routes: {
        '/register': (context) => ChooseRegister(),
        '/dashboard': (context) => DashboardScreen(),
        '/login': (context) => ChooseLogin(),
      },
    );
  }
}


