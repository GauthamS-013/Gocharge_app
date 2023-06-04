import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String contact;

  ProfilePage([this.name='NAME', this.email="EMAIL", this.contact='1234567890']);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  String _oldPasswordError = '';
  String _newPasswordError = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _contactController.text = widget.contact;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    // Update profile logic here
    String name = _nameController.text;
    String email = _emailController.text;
    String contact = _contactController.text;

    // Perform profile update operations

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile Updated'),
          content: Text('Your profile has been updated successfully.'),
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

  void _changePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  errorText: _oldPasswordError,
                ),
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  errorText: _newPasswordError,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String oldPassword = _oldPasswordController.text;
                String newPassword = _newPasswordController.text;

                // Validate old password
                if (oldPassword != 'currentPassword') {
                  setState(() {
                    _oldPasswordError = 'Incorrect password';
                  });
                  return;
                } else {
                  setState(() {
                    _oldPasswordError = '';
                  });
                }

                // Validate new password
                if (newPassword.length < 8 ||
                    !newPassword.contains(RegExp(r'\d')) ||
                    newPassword.contains(' ')) {
                  setState(() {
                    _newPasswordError =
                    'Password must be at least 8 characters long, contain at least one number, and no blank spaces.';
                  });
                  return;
                } else {
                  setState(() {
                    _newPasswordError = '';
                  });
                }

                // Perform password update operations

                Navigator.of(context).pop();
              },
              child: Text('Change'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _contactController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Contact',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}