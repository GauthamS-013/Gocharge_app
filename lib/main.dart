import 'dart:async';
import 'package:ev_charging/user/booknow.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin/Admin_Addstation.dart';
import 'admin/Admindashboard.dart';
import 'user/Findstation.dart';
import 'user/LoginPage.dart';
import 'user/RegistrationPage.dart';
import 'user/Roadmap.dart';
import 'SplashScreen.dart';
import 'user/Viewbooking.dart';

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
