import 'package:ev_charging/admin/Admin_Addstation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user/Stationdetails.dart';

class Station {
  final String? name;
  final String? city;

  Station({this.name, this.city});
}

class admin_managestation extends StatefulWidget {
  const admin_managestation({Key? key}) : super(key: key);

  @override
  State<admin_managestation> createState() => _admin_managestationState();
}

class _admin_managestationState extends State<admin_managestation> {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference stationsCollection =
  FirebaseFirestore.instance.collection('ev_stations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Stations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stationsCollection
            .where('ownerEmail', isEqualTo: user?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          List<Station> stations = documents.map((doc) {
            return Station(
              name: doc['name'],
              city: doc['city'],
            );
          }).toList();

          return ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 80,
                  width: 90,
                  color: Colors.grey,
                  child: ListTile(
                    title: Text(
                      'Name: ${stations[index].name}',
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      'City: ${stations[index].city}',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://media.istockphoto.com/id/901999846/vector/icon-charging-stations-of-electric-cars.jpg?s=612x612&w=0&k=20&c=mmCSrOptMqHGPugfm-iaHUoJqykLV5vJ24grr9YkcvI=',
                          ),
                        ),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Stationsdetail(),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 130,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addstation()),
            );
          },
          backgroundColor: Colors.green,
          child: Row(
            children: [Icon(Icons.add), Text(" Add Station")],
          ),
        ),
      ),
    );
  }
}
