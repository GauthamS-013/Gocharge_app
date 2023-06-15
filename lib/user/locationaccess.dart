import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class locationaccess extends StatefulWidget {
  const locationaccess({Key? key}) : super(key: key);

  @override
  State<locationaccess> createState() => _locationaccessState();
}

class _locationaccessState extends State<locationaccess> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Current Location of the User", textAlign: TextAlign.center),
            SizedBox(height: 18,),
            ElevatedButton(onPressed: (){

            }, child: Text("Get Current Location"))
            
          ],
        ),
      ),

    );
  }
}
