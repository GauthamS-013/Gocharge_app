import 'package:ev_charging/user/Stationdetails.dart';
import 'package:flutter/material.dart';

class Station {
  final String? name;
  final String? location;

  Station({this.name, this.location});
}

class FindStationPage extends StatefulWidget {
  @override
  _FindStationPageState createState() => _FindStationPageState();
}

class _FindStationPageState extends State<FindStationPage> {
  var station=[
    {
      'Name': 'Ather Hub',
      'Location': 'Ramanattukara',
      'Image': "https://media.istockphoto.com/id/901999846/vector/icon-charging-stations-of-electric-cars.jpg?s=612x612&w=0&k=20&c=mmCSrOptMqHGPugfm-iaHUoJqykLV5vJ24grr9YkcvI="
    },{
      'Name': 'Ather Station',
      'Location': 'Kozhikode',
      'Image': "https://media.istockphoto.com/id/901999846/vector/icon-charging-stations-of-electric-cars.jpg?s=612x612&w=0&k=20&c=mmCSrOptMqHGPugfm-iaHUoJqykLV5vJ24grr9YkcvI="
    },{
      'Name': 'KSEB evStation',
      'Location': 'Meenchanda',
      'Image': "https://media.istockphoto.com/id/901999846/vector/icon-charging-stations-of-electric-cars.jpg?s=612x612&w=0&k=20&c=mmCSrOptMqHGPugfm-iaHUoJqykLV5vJ24grr9YkcvI="
    },{
      'Name': 'Ather hub',
      'Location': 'Kozhikode',
      'Image': "https://media.istockphoto.com/id/901999846/vector/icon-charging-stations-of-electric-cars.jpg?s=612x612&w=0&k=20&c=mmCSrOptMqHGPugfm-iaHUoJqykLV5vJ24grr9YkcvI="
    },{
      'Name': 'Ather Station',
      'Location': 'Kozhikode',
      'Image': "https://media.istockphoto.com/id/901999846/vector/icon-charging-stations-of-electric-cars.jpg?s=612x612&w=0&k=20&c=mmCSrOptMqHGPugfm-iaHUoJqykLV5vJ24grr9YkcvI="
    },
  ];

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
        itemCount: station.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              width: 90,
              color: Colors.grey,
              child: ListTile(
                title: Text('Name: ${station[index]["Name"]}',style: TextStyle(fontSize: 18),),
                subtitle: Text('Location: ${station[index]["Location"]}',style: TextStyle(fontSize: 18),),
                leading: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage('https://media.istockphoto.com/id/901999846/vector/icon-charging-stations-of-electric-cars.jpg?s=612x612&w=0&k=20&c=mmCSrOptMqHGPugfm-iaHUoJqykLV5vJ24grr9YkcvI='),),

              shape: BoxShape.rectangle,
              color: Colors.white
              ),),
                onTap: () {
                  // TODO: Implement station selection functionality
                  // Perform actions when a station is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Stationsdetail()),
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