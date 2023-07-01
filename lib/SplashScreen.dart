import 'dart:async';

import 'package:ev_charging/startpage.dart';
import 'package:ev_charging/user/DashboardPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user/LoginPage.dart';
import 'user/RegistrationPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green, // Replace with your desired background color
        child: Center(
          child: Image.asset(
            'assets/gocharge.png',
            // Replace with the actual path and filename of your logo image
            width: 2000, // Adjust the width as per your preference
            height: 2000, // Adjust the height as per your preference
          ),
        ),
      ),
    );
  }
}
