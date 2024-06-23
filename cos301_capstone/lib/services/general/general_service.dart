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
  Future<Map<String, dynamic>?> getPetById(String userId, String petId) async {
    try {
      // Access the specific pet document
      final docSnapshot = await _db.collection('users').doc(userId).collection('pets').doc(petId).get();

      if (docSnapshot.exists) {
        print("Pet fetched successfully.");
        return docSnapshot.data() as Map<String, dynamic>; // Return the pet's data
      } else {
        print("Pet not found.");
        return null; // Return null if the pet does not exist
      }
    } catch (e) {
      print("Error fetching pet: $e");
      return null; // Return null if an error occurs
    }
  }
}