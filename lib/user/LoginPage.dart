import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging/user/DashboardPage.dart';
import 'package:ev_charging/user/RegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../admin/Admindashboard.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool _showPassword = false;
  bool rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    retrieveLoginCredentials();
  }

  void retrieveLoginCredentials() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = shared.getBool('rememberMe') ?? false;
      if (rememberMe) {
        _emailController.text = shared.getString('email') ?? '';
        _passwordController.text = shared.getString('password') ?? '';
      }
    });
  }

  void saveLoginCredentials(String email, String password) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setBool('rememberMe', rememberMe);
    shared.setString('email', rememberMe ? email : '');
    shared.setString('password', rememberMe ? password : '');
  }

  void clearLoginCredentials() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.remove('rememberMe');
    await shared.remove('email');
    await shared.remove('password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: key,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Colors.green),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    labelText: 'Email',
                  ),
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please enter a valid email";
                    }
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  validator: (p) {
                    if (p!.isEmpty) {
                      return "Please enter a password";
                    } else if (p.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    } else if (p.contains(' ')) {
                      return 'Password should not contain blank spaces.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value!;
                      });
                    },
                  ),
                  Text('Remember me'),
                ],
              ),
              SizedBox(height: 80.0),
              ElevatedButton(
                onPressed: () async {
                  bool validate = key.currentState!.validate();
                  if (validate) {
                    saveLoginCredentials(
                      _emailController.text,
                      _passwordController.text,
                    );
                    signIn(
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
                style: ButtonStyle(
                  minimumSize:
                  MaterialStateProperty.all<Size>(Size(50.0, 36.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: Text('New user? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "User") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDashboard(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (key.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}

