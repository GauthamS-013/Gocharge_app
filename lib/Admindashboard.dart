import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardButton(
              label: 'Manage Stations',
              icon: Icons.settings,
              onPressed: () {
                // Handle button press for managing stations
                // Add your logic here
              },
            ),
            SizedBox(height: 20),
            DashboardButton(
              label: 'View Bookings',
              icon: Icons.calendar_today,
              onPressed: () {
                // Handle button press for viewing bookings
                // Add your logic here
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
        backgroundColor: Colors.grey,
        foregroundColor: Colors.black,
        padding: EdgeInsets.all(60.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
