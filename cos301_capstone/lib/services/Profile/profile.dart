import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('profile').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        print("No profile found for the given userId.");
        return null;
      }
    } catch (e) {
      print("Error fetching profile data: $e");
      return null;
    }
  }
  Future<Map<String, dynamic>?> getPetProfile(String petId) async {
      try {
        DocumentSnapshot doc = await _db.collection('petProfile').doc(petId).get();
        if (doc.exists) {
          return doc.data() as Map<String, dynamic>?;
        } else {
          print("No pet profile found for the given petId.");
          return null;
        }
      } catch (e) {
        print("Error fetching pet profile data: $e");
        return null;
      }
    }
  Future<void> updateProfile(String userId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('profile').doc(userId).update(updatedData);
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<String?> updateProfileImage(String userId, File file) async {
    try {
      Reference ref = _storage.ref().child('profile_images/$userId');
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await updateProfile(userId, {'ProfileImg': downloadUrl});

      return downloadUrl;
    } catch (e) {
      print("Error updating profile image: $e");
      return null;
    }
  }
    Future<String?> updatePetProfileImage(String ownerId, File file) async {
    try {
      Reference ref = _storage.ref().child('profile_images/$ownerId');
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await updatePet(ownerId, {'profileImg': downloadUrl});

      return downloadUrl;
    } catch (e) {
      print("Error updating profile image: $e");
      return null;
    }
  }
  Future<List<DocumentReference>> getUserLikes(String userId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('likes')
          .where('UserId', isEqualTo: _db.collection('users').doc(userId))
          .get();
      return snapshot.docs.map((doc) => doc.reference).toList();
    } catch (e) {
      print("Error fetching user likes: $e");
      return [];
    }
  }

  Future<List<DocumentReference>> getUserSaves(String userId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('saves')
          .where('UserId', isEqualTo: _db.collection('users').doc(userId))
          .get();
      return snapshot.docs.map((doc) => doc.reference).toList();
    } catch (e) {
      print("Error fetching user saves: $e");
      return [];
    }
  }

  Future<List<DocumentReference>> getUserEvents(String userId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('events')
          .where('userId', isEqualTo: _db.collection('users').doc(userId))
          .get();
      return snapshot.docs.map((doc) => doc.reference).toList();
    } catch (e) {
      print("Error fetching user events: $e");
      return [];
    }
  }

  Future<List<DocumentReference>> getUserPosts(String userId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('posts')
          .where('UserId', isEqualTo: _db.collection('users').doc(userId))
          .get();
      return snapshot.docs.map((doc) => doc.reference).toList();
    } catch (e) {
      print("Error fetching user posts: $e");
      return [];
    }
  }

  Future<void> addPet(String ownerId, Map<String, dynamic> petData) async {
    try {
      DocumentReference petRef = await _db.collection('petProfile').add(petData);
      await updateProfile(ownerId, {'petIds': FieldValue.arrayUnion([petRef])});
    } catch (e) {
      print("Error adding pet: $e");
    }
  }

  Future<void> updatePet(String petId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('petProfile').doc(petId).update(updatedData);
    } catch (e) {
      print("Error updating pet details: $e");
    }
  }
  Future<void> addEvent(String userId, Map<String, dynamic> eventData) async {
    try {
      // Add a new document with a generated ID
      await _db.collection('events').add({
        ...eventData,
        'userId': '/users/$userId', 
      });
      print("Event added successfully.");
    } catch (e) {
      print("Error adding event: $e");
      throw Exception("Failed to add event.");
    }
  }
  Future<void> updateEvent(String eventId, Map<String, dynamic> updatedEventData) async {
    try {
      // Update an existing document
      await _db.collection('events').doc(eventId).update(updatedEventData);
      print("Event updated successfully.");
    } catch (e) {
      print("Error updating event: $e");
      throw Exception("Failed to update event.");
    }
  }
}