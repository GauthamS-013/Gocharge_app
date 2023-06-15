import 'dart:async';
import 'package:ev_charging/booknow.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Admin_Addstation.dart';
import 'Admindashboard.dart';
import 'Findstation.dart';
import 'LoginPage.dart';
import 'RegistrationPage.dart';
import 'Roadmap.dart';
import 'SplashScreen.dart';
import 'Viewbooking.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginApp());
}
class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gocharge',
       theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(),
    );
  }
}
