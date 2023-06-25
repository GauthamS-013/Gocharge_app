import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'DashboardPage.dart';

class booknow extends StatefulWidget {
  final String stationName;
  const booknow({Key? key, required this.stationName}) : super(key: key);

  @override
  State<booknow> createState() => _booknowState();
}

class _booknowState extends State<booknow> {
  TextEditingController _bookdate = TextEditingController();
  TextEditingController _booktime = TextEditingController();
  GlobalKey<FormState> key1 = GlobalKey<FormState>();
  String? selecteddur;
  List<String> dur = ['1', '1.5', '2', '2.5', '3', '3.5', '4', '4.5', '5', '5.5', '6'];

  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference bookingsCollection =
  FirebaseFirestore.instance.collection('bookings');

  void _book() {
    String stationName = widget.stationName;
    String userEmail = user?.email ?? '';

    // Prepare the booking data
    Map<String, dynamic> bookingData = {
      'date': _bookdate.text,
      'time': _booktime.text,
      'duration': selecteddur,
      'stationName': stationName,
      'userEmail': userEmail,
    };

    // Add the booking data to Firestore
    bookingsCollection
        .add(bookingData)
        .then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Booked'),
            content: Text('Slot booked successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => DashboardPage()));
                },
                child: Text('Go Back'),
              ),
            ],
          );
        },
      );
    })
        .catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to book the slot. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Slot"),
      ),
      body: Form(
        key: key1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 18),
              TextFormField(
                controller: _bookdate,
                readOnly: true,
                onTap: () async {
                  DateTime? bookingdate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  );

                  if (bookingdate != null) {
                    setState(() {
                      _bookdate.text = DateFormat.yMd().format(bookingdate);
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Tap to open Date picker',
                ),
                validator: (d) {
                  if (d!.isEmpty) {
                    return "Please choose a date";
                  }
                },
              ),
              SizedBox(height: 18),
              TextFormField(
                controller: _booktime,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? bookingtime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (bookingtime != null) {
                    setState(() {
                      _booktime.text = "${bookingtime.format(context)}";
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Tap to open Time picker',
                ),
                validator: (t) {
                  if (t!.isEmpty) {
                    return "Please choose a time";
                  }
                },
              ),
              SizedBox(height: 18),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Duration",
                ),
                validator: (du) {
                  if (du!.isEmpty) {
                    return "Please choose a duration";
                  }
                },
                value: selecteddur,
                onChanged: (String? newValue) {
                  setState(() {
                    selecteddur = newValue;
                  });
                },
                items: dur.map((dynamic option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  bool validate = key1.currentState!.validate();
                  print(validate);
                  if (validate == true) {
                    _book();
                  }
                },
                child: Text(
                  "Book now",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
