import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'booknow.dart';

class Station {
  final String? name;
  final double? longitude;
  final double? lattitude;
  final String? city;

  Station({this.name, this.longitude, this.lattitude,this.city});
}

class FindStationPage extends StatefulWidget {
  @override
  _FindStationPageState createState() => _FindStationPageState();
}

class _FindStationPageState extends State<FindStationPage> {
  late List<Station> stations = [];
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _fetchStations();
      });
    } catch (e) {
      print('Failed to get current location: $e');
    }
  }

  void _fetchStations() {
    double range = 20.0; // Range in kilometers

    FirebaseFirestore.instance
        .collection('ev_stations')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        stations = snapshot.docs.map((DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic>
          if (data != null && data.containsKey('name') && data.containsKey('longitude') && data.containsKey('lattitude')) {
            double lattitude = double.tryParse(data['lattitude'].toString()) ?? 0.0;
            double longitude = double.tryParse(data['longitude'].toString()) ?? 0.0;
            String city = data['city'];
            double distanceInKm = _calculateDistance(
              _currentPosition.latitude,
              _currentPosition.longitude,
              lattitude,
              longitude,
            );

            if (distanceInKm <= range) {
              return Station(
                name: data['name'].toString(),
                longitude: longitude,
                lattitude: lattitude,
                city: data['city'].toString(),
              );
            }
          }
          return null;
        }).where((station) => station != null).toList().cast<Station>();
      });
    }).catchError((error) {
      print('Failed to fetch stations: $error');
    });
  }
  double _calculateDistance(
      double startLattitude,
      double startLongitude,
      double endLattitude,
      double endLongitude,
      ) {
    const double earthRadius = 6371; // in kilometers

    double lat1 = startLattitude * (math.pi / 180.0);
    double lon1 = startLongitude * (math.pi / 180.0);
    double lat2 = endLattitude * (math.pi / 180.0);
    double lon2 = endLongitude * (math.pi / 180.0);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    double distanceInKm = earthRadius * c;
    return distanceInKm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Station'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_sharp),
            onPressed: () {
              // TODO: Implement filter functionality
              // Perform actions when filter icon is pressed
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
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
                title: Text(
                  'Name: ${stations[index].name}',
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City: ${stations[index].city}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Distance: ${stations[index].city}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => booknow(stationName: stations[index].name!),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
