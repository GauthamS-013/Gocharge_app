import 'package:flutter/material.dart';

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

  void _addVehicle() {
    String manufacturer = _manufacturerController.text;
    String model = _modelController.text;
    String registration = _registrationController.text;

    Vehicle newVehicle = Vehicle(manufacturer: manufacturer, model: model, registration: registration);

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
              child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Car Manufacturer: ${vehicles[index].manufacturer}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Model: ${vehicles[index].model}'),
                        Text('Registration: ${vehicles[index].registration}'),
                      ],
                    ),
                  );
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

  Vehicle({required this.manufacturer, required this.model, required this.registration});
}