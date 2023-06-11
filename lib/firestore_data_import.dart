import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataImporter {
  Future<void> importDataFromJsonFile(String filePath) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Read the JSON file contents
    String jsonData = await File("X:\evdata\ev-charging-stations-india.json").readAsString();

    // Parse the JSON data
    List<Map<String, dynamic>> dataList = jsonDecode(jsonData);

    // Write data to Firestore
    for (var data in dataList) {
      // Write the data to Firestore
      await firestore.collection('your_collection').doc().set(data);
    }
  }
}