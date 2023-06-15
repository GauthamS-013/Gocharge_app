import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Viewbooking extends StatefulWidget {
  const Viewbooking({Key? key}) : super(key: key);

  @override
  State<Viewbooking> createState() => _ViewbookingState();
}

class _ViewbookingState extends State<Viewbooking> {
  TextEditingController _bookdate = TextEditingController();
  GlobalKey<FormState> key3 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Booking"),
      ),
      body: Form(
        key: key3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                  controller: _bookdate,
                  readOnly: true,
                  style: TextStyle(),
                  onTap: () async {
                    DateTime? bookingdate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025));
                    setState(() {
                      _bookdate.text = DateFormat.yMd().format(bookingdate!);
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Booking Date',
                  ),
                  validator: (d) {
                    if (d!.isEmpty) {
                      return "Please choose a date";
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
