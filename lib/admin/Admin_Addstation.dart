import 'package:ev_charging/admin/Admin_managestation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class addstation extends StatefulWidget {
  const addstation({Key? key}) : super(key: key);

  @override
  State<addstation> createState() => _addstationState();
}

class _addstationState extends State<addstation> {
  GlobalKey<FormState> key4 = GlobalKey<FormState>();
  TextEditingController _stationname = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _state = TextEditingController();
  LatLng? _selectedLocation;

  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference stationsCollection =
  FirebaseFirestore.instance.collection('ev_stations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Station"),
      ),
      body: Form(
        key: key4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 18,
              ),
              TextFormField(
                controller: _stationname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Station name',
                ),
                validator: (n) {
                  if (n!.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 18,
              ),
              TextFormField(
                controller: _address,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
              SizedBox(
                height: 18,
              ),
              TextFormField(
                controller: _city,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City',
                ),
              ),
              SizedBox(
                height: 18,
              ),
              TextFormField(
                controller: _state,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'State',
                ),
              ),
              SizedBox(
                height: 18,
              ),
              _selectedLocation != null
                  ? Text(
                'Selected Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
              )
                  : ElevatedButton(
                onPressed: _selectLocationOnMap,
                child: Text('Select Location on Map'),
              ),
              SizedBox(
                height: 23,
              ),
              ElevatedButton(
                onPressed: () {
                  bool validate = key4.currentState!.validate();
                  if (validate) {
                    addStationToFirestore();
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _selectLocationOnMap() async {
    LatLng? location = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPicker(),
      ),
    );

    if (location != null) {
      setState(() {
        _selectedLocation = location;
      });
    }
  }

  void addStationToFirestore() async {
    try {
      if (user != null) {
        String ownerEmail = user!.email!;
        await stationsCollection.add({
          'name': _stationname.text,
          'address': _address.text,
          'city': _city.text,
          'state': _state.text,
          'lattitude': _selectedLocation?.latitude,
          'longitude': _selectedLocation?.longitude,
          'type': "49",
          'ownerEmail': ownerEmail,
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => admin_managestation()),
        );
      }
    } catch (e) {
      print('Error adding station to Firestore: $e');
      // Handle the error as per your requirement
    }
  }
}

class MapPicker extends StatefulWidget {
  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location on Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        onTap: _selectLocation,
        initialCameraPosition: CameraPosition(
          target: LatLng(10.202116,76.383187), // Default initial location
          zoom: 12,
        ),
        markers: _selectedLocation != null
            ? Set<Marker>.from([
          Marker(
            markerId: MarkerId('selectedLocation'),
            position: _selectedLocation!,
          ),
        ])
            : {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedLocation != null) {
            Navigator.pop(context, _selectedLocation);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }
}