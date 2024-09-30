import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class VetService {
  late final FirebaseFirestore _db;
  final String firebaseFunctionUrl;

  VetService({required this.firebaseFunctionUrl, FirebaseFirestore? db}) {
    _db = db ?? FirebaseFirestore.instance;
  }

  Future<void> fetchAndStoreVets(String location, int radius) async {
    final url = Uri.parse('$firebaseFunctionUrl/getVets?location=$location&radius=$radius&type=veterinary_care');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        for (var result in results) {
          // Ensure result contains required fields
          if (result['name'] != null && result['vicinity'] != null && result['geometry'] != null && result['place_id'] != null) {
            final placeId = result['place_id'];
            final querySnapshot = await _db.collection('vets').where('place_id', isEqualTo: placeId).get();

            if (querySnapshot.docs.isEmpty) {
              await _db.collection('vets').add({
                'name': result['name'],
                'address': result['vicinity'],
                'location': result['geometry']['location'],
                'place_id': result['place_id'],
              });
              print('Vet data successfully stored in Firestore: ' + result['name']);
            } else {
              print('Vet data already exists in Firestore: ' + result['name']);
            }
          }
        }

        print('Vets data successfully processed.');
      } else {
        print('Failed to fetch data from Firebase function: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data from Firebase function: $e');
    }
  }
}