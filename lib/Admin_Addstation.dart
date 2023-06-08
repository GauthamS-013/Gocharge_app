import 'package:ev_charging/Admin_managestation.dart';
import 'package:flutter/material.dart';

class addstation extends StatefulWidget {
  const addstation({Key? key}) : super(key: key);

  @override
  State<addstation> createState() => _addstationState();
}

class _addstationState extends State<addstation> {
  GlobalKey<FormState> key4 = GlobalKey<FormState>();
  TextEditingController _stationname = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _latilongi = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  }),
              SizedBox(
                height: 18,
              ),
              TextFormField(
                controller: _location,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location',
                ),
                // validator: (n) {
                //   if (n!.isEmpty) {
                //     return "Please enter a location";
                //   }
                // }
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
                // validator: (n) {
                //   if (n!.isEmpty) {
                //     return "Please enter a city";
                //   }
                // }
              ),
              SizedBox(
                height: 18,
              ),
              TextFormField(
                controller: _latilongi,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Latitude, Longitude',
                ),
                // validator: (n) {
                //   if (n!.isEmpty) {
                //     return "Please enter latitude, longitude";
                //   }
                // }
              ),
              SizedBox(
                height: 23,
              ),
              ElevatedButton(
                onPressed: () {
                  bool validate = key4.currentState!.validate();
                  print(validate);
                  if (validate == true) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => admin_managestation()));
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
}
