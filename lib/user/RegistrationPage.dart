import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'DashboardPage.dart';
import 'LoginPage.dart';

class MyUser {
  final String name;
  final String email;
  final String contact;
  final String role;

  MyUser({
    required this.name,
    required this.email,
    required this.contact,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'contact': contact,
      'role': role,
    };
  }
}

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
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  String role = "User";
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
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String contact = _contactController.text.trim();

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save the user details to the database
      MyUser user = MyUser(
        name: name,
        email: email,
        contact: contact,
        role: _currentItemSelected,
      );

      // Store the user data in the database
      DatabaseReference userRef = _database.child('users').push();
      userRef.set({
        'name': name,
        'email': email,
        'contact': contact,
        'role': _currentItemSelected,
      });

      // Store additional user information in Firebase Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());

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

  var options = [
    'User',
    'Admin',
  ];
  var _currentItemSelected = "User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Name',
                  ),
                  validator: (n) {
                    if (n!.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Email',
                  ),
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Contact',
                  ),
                  validator: (nu) {
                    if (nu!.isEmpty) {
                      return "Please enter a contact number";
                    }
                    if (nu.length != 10) {
                      return "Enter a contact containing 10 numbers";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 3.0, right: 3.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Role: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    DropdownButton<String>(
                      isDense: true,
                      isExpanded: false,
                      iconEnabledColor: Colors.green,
                      focusColor: Colors.black,
                      items: options.map(
                            (String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (newValueSelected) {
                        setState(() {
                          _currentItemSelected = newValueSelected!;
                          role = newValueSelected;
                        });
                      },
                      value: _currentItemSelected,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () async {
                  bool validate = k1.currentState!.validate();
                  print(validate);
                  if (validate == true) {
                    if (check == true) {
                      SharedPreferences shared =
                      await SharedPreferences.getInstance();
                      await shared.setBool("isLogged", true);
                    }
                    _register();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(50.0, 36.0),
                  ),
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
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
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
