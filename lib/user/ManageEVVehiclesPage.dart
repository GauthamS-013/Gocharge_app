import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage EV Vehicles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ManageEVVehiclesPage(),
    );
  }
}

class ManageEVVehiclesPage extends StatefulWidget {
  @override
  _ManageEVVehiclesPageState createState() => _ManageEVVehiclesPageState();
}

class _ManageEVVehiclesPageState extends State<ManageEVVehiclesPage> {
  List<Vehicle> vehicles = [];

  TextEditingController _manufacturerController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _registrationController = TextEditingController();

  @override
  void dispose() {
    _manufacturerController.dispose();
    _modelController.dispose();
    _registrationController.dispose();
    super.dispose();
  }

  void _addVehicle() async {
    String manufacturer = _manufacturerController.text;
    String model = _modelController.text;
    String registration = _registrationController.text;

    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? '';

    Vehicle newVehicle = Vehicle(
      manufacturer: manufacturer,
      model: model,
      registration: registration,
      userEmail: userEmail,
    );

    CollectionReference vehiclesRef = FirebaseFirestore.instance.collection('vehicles');
    await vehiclesRef.add({
      'manufacturer': newVehicle.manufacturer,
      'model': newVehicle.model,
      'registration': newVehicle.registration,
      'userEmail': newVehicle.userEmail,
    });

    setState(() {
      vehicles.add(newVehicle);
    });

    _manufacturerController.clear();
    _modelController.clear();
    _registrationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage EV Vehicles'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Manufacturer',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _modelController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Car Model',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _registrationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Registration Number',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addVehicle,
              child: Text('Add Vehicle'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Vehicles:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('vehicles').where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Vehicle vehicle = Vehicle(
                          manufacturer: documents[index].get('manufacturer'),
                          model: documents[index].get('model'),
                          registration: documents[index].get('registration'),
                          userEmail: documents[index].get('userEmail'),
                        );
                        return ListTile(
                          title: Text('Car Manufacturer: ${vehicle.manufacturer}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Model: ${vehicle.model}'),
                              Text('Registration: ${vehicle.registration}'),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Vehicle {
  final String manufacturer;
  final String model;
  final String registration;
  final String userEmail;

  Vehicle({
    required this.manufacturer,
    required this.model,
    required this.registration,
    required this.userEmail,
  });
}
