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
                  final bookingData = bookings[index].data() as Map<String, dynamic>?;

                  if (bookingData == null) {
                    return SizedBox.shrink(); // Skip this item if data is null
                  }

                  final userEmail = bookingData['userEmail'] as String?;

                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(userEmail).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final userData = snapshot.data?.data() as Map<String, dynamic>?;

                      if (userData == null) {
                        return SizedBox.shrink(); // Skip this item if data is null
                      }

                      final userName = userData['name'] as String?;

                      final bookingDate = bookingData['date'];

                      String formattedDate = '';
                      if (bookingDate is Timestamp) {
                        formattedDate = DateFormat('yyyy-MM-dd').format(bookingDate.toDate());
                      } else if (bookingDate is String) {
                        formattedDate = bookingDate;
                      }

                      return Card(
                        elevation: 2.0,
                        child: ListTile(
                          title: Text('User Name: $userName'),
                          subtitle: Text('Booking Date: $formattedDate'),
                        ),
                      );
                    },
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
