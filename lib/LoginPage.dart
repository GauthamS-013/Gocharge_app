import 'package:ev_charging/DashboardPage.dart';
import 'package:ev_charging/RegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool check = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Login successful, handle the userCredential as needed
      User? user = userCredential.user;
      if (user != null) {
        // User logged in successfully, navigate to the dashboard page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      }
    } catch (e) {
      // Handle login errors
      String errorMessage = e.toString();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
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
                    }),
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
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Checkbox(
                      value: check,
                      onChanged: (value) {
                        setState(() {
                          check = value!;
                        });
                      }),
                  Text('Remember me'),
                ],
              ),
              SizedBox(height: 80.0),
              ElevatedButton(
                onPressed: ()async {
                  bool validate = key.currentState!.validate();
                  if (validate == true) {
                    if (check == true) {
                      SharedPreferences shared = await SharedPreferences.getInstance();
                      await shared.setBool("isLogged", true);
                    }
                    _login();
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
}
