import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myclassroom/auth_handler.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthHandler()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.deepPurple,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200.h),
                Image.asset(
                  'assets/img.png',
                  width: 300.w,
                  height: 300.h,
                ),
                SizedBox(height: 20.h),
                SizedBox(height: 250.h),
                Text(
                  "All Right Reserved",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
