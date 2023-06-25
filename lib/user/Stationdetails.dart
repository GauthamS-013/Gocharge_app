import 'package:ev_charging/user/booknow.dart';
import 'package:flutter/material.dart';

class Station {
  final String? name;
  final double? longitude;
  final double? lattitude;
  final String? city;

  Station({this.name, this.longitude, this.lattitude,this.city});
}
class Stationsdetail extends StatefulWidget {
  const Stationsdetail({Key? key}) : super(key: key);

  @override
  State<Stationsdetail> createState() => _StationsdetailState();
}

class _StationsdetailState extends State<Stationsdetail> {
  get stations => null;

  get index => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EV Station")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/ev-1.png'),
            SizedBox(height: 10),
            Container(
                height: 80,
                color: Colors.grey,
                child: ListTile(
                  title: Text(
                    'Address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                )),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Hours",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Row(
              children: [
                Text("Open 24/7", style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Cost",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Row(
              children: [
                Text("₹21/kwh", style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Amenities",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Row(
              children: [
                Text("Restroom,EV Parking", style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 10),
            Container(
                height: 80,
                color: Colors.grey,
                child: ListTile(
                  title: Text(
                    'Plugs',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    "CCS/SAE   (2 Stations)",
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            Row(
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => booknow(stationName: stations[index].name!)));
                }, child: Text("Book Now")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
