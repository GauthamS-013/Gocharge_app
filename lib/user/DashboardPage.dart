import 'package:ev_charging/user/LoginPage.dart';
import 'package:ev_charging/user/ManageEVVehiclesPage.dart';
import 'package:ev_charging/user/Viewbooking.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Findstation.dart';
import 'ProfilePage.dart';
import 'mapscreen.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Perform profile icon action
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
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
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: [
          DashboardButton(
            icon: Icons.directions_car,
            title: 'Manage EV Vehicle',
            onTap: () {
              // Perform action when 'Manage EV Vehicle' button is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageEVVehiclesPage()),
              );
            },
          ),
          DashboardButton(
            icon: Icons.place,
            title: 'Find Station',
            onTap: () {
              // Perform action when 'Find Station' button is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindStationPage()),
              );
            },
          ),
          DashboardButton(
            icon: Icons.calendar_today,
            title: 'View Booking',
            onTap: () {
              // Perform action when 'View Booking' button is tapped
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Viewbooking()));
            },
          ),
          DashboardButton(
            icon: Icons.map,
            title: 'Roadmap',
            onTap: () {
              // Perform action when 'Roadmap' button is tapped
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DashboardButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            SizedBox(height: 8.0),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
