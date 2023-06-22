import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MaterialApp(
    home: MapScreen(),
  ));
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LocationData? currentLocation;
  Location location = Location();
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    try {
      currentLocation = await location.getLocation();
      LatLng? latLng = LatLng(
        currentLocation?.latitude ?? 0.0,
        currentLocation?.longitude ?? 0.0,
      );
      if (latLng != null) {
        mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 12.0));
        setState(() {
          markers.add(
            Marker(
              markerId: MarkerId("currentLocation"),
              position: latLng,
              infoWindow: InfoWindow(title: "Current Location"),
            ),
          );
        });
      }
    } catch (e) {
      // Handle location errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roadmap'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 12.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: markers,
        myLocationEnabled: true,
      ),
    );
  }
}
