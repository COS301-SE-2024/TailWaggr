import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUserPets(String userId) async {
    try {
      // Access the user's "pets" subcollection
      final querySnapshot = await _db.collection('users').doc(userId).collection('pets').get();

      // Convert each document to a map and add it to a list
      final pets = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      print("Pets fetched successfully.");
      return pets; // Return the list of pets
    } catch (e) {
      print("Error fetching pets: $e");
      return []; // Return an empty list if an error occurs
    }
  }

}