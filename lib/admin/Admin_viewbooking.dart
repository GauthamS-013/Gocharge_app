import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class adminViewbooking extends StatefulWidget {
  const adminViewbooking({Key? key}) : super(key: key);

  @override
  State<adminViewbooking> createState() => _ViewbookingState();
}

class _ViewbookingState extends State<adminViewbooking> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;
    final userEmail = currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: Text("View Booking"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ev_stations')
            .where('ownerEmail', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final stations = snapshot.data?.docs ?? [];

          if (stations.isEmpty) {
            return Center(child: Text('No stations found.'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('bookings')
                .where('stationName', whereIn: stations.map((doc) => doc['name']).toList())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final bookings = snapshot.data?.docs ?? [];

              if (bookings.isEmpty) {
                return Center(child: Text('No bookings found.'));
              }

              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final bookingData = bookings[index].data() as Map<String, dynamic>;
                  final userName = bookingData['name'] ?? '';
                  final bookingDate = bookingData['date'];
                  final bookingTime = bookingData['time'];

                  String formattedDate = '';
                  if (bookingDate is Timestamp) {
                    formattedDate = DateFormat('yyyy-MM-dd').format(bookingDate.toDate());
                  } else if (bookingDate is String) {
                    formattedDate = bookingDate;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: ListTile(
                        title: Text('Booking Date: $formattedDate',style: TextStyle(fontSize: 18)),
                        subtitle: Text('Booking Time: $bookingTime',style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
