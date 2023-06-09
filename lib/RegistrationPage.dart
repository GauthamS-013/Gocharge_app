import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'DashboardPage.dart';
import 'LoginPage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool check = false;
  bool _showPassword = false;
String? v;
  bool _isEmailValid = true;
  bool _isContactValid = true;
  GlobalKey<FormState> k1 = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    Firebase.initializeApp();
  }
  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Registration successful, navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } catch (e) {
      // Registration failed, handle the error
      print('Registration error: $e');
      // You can show an error message to the user or handle the error in a different way
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text('Registration'),
      // ),
      body: Form(
        key: k1,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Registration",
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Colors.green),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      labelText: 'Name',
                    ),
                    validator: (n) {
                      if (n!.isEmpty) {
                        return "Please enter a name";
                      }
                    }),
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
                    }),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      labelText: 'Contact',
                    ),
                    validator: (nu) {
                      if (nu!.isEmpty) {
                        return "PLease enter a contact number";
                      }
                      if (nu!.length != 10) {
                        return "Enter a contact containing 10 numbers";
                      }
                    }),
              ),
              SizedBox(height: 16.0),
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
                    }),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () async {
                  bool validate = k1.currentState!.validate();
                  print(validate);
                  if (validate == true) {
                    if (check == true) {
                      SharedPreferences shared = await SharedPreferences.getInstance();
                      await shared.setBool("isLogged", true);
                    }
                    _register();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
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
                  'Register',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Already a user? Login here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
