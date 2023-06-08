import 'package:ev_charging/Admin_viewbooking.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Admin_managestation.dart';
import 'LoginPage.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                SharedPreferences log = await SharedPreferences.getInstance();
                await log.clear();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text("Logout"))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashboardButton(
                label: 'Manage Stations',
                icon: Icons.settings,
                onPressed: () {
                  // Handle button press for managing stations
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => admin_managestation()));
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                label: 'View Bookings',
                icon: Icons.calendar_today,
                onPressed: () {
                  // Handle button press for viewing bookings
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => adminViewbooking()));
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                label: 'Demand Forecasting',
                icon: Icons.trending_up,
                onPressed: () {
                  // Handle button press for demand forecasting
                  // Add your logic here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const DashboardButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label,
        style: TextStyle(fontSize: 24),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.all(60.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
