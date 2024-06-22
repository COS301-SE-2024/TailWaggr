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
  /// Updates the user's profile with the provided data.
  ///
  /// Takes the user's ID and a map of updated data as input.
  ///
  /// - Parameters:
  ///   - [userId]: The ID of the user whose profile is to be updated.
  ///   - [updatedData]: A map containing the updated profile data.
  ///
  /// - Example:
  /// ```dart
  /// await updateProfile("userId123", {"Bio": "New bio", "DarkMode": true});
  /// ```
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
  /// Adds a pet to the user's profile.
  ///
  /// Takes the owner's ID and a map of pet data as input.
  ///
  /// - Parameters:
  ///   - [ownerId]: The ID of the user who owns the pet.
  ///   - [petData]: A map containing the pet's data.
  ///   - [petData]: {"name":"","species":"","breed":"","age":"","bio":""}
  ///
  /// - Example:
  /// ```dart
  /// await addPet("ownerId123", {
  ///   "name": "Fluffy",
  ///   "species": "cat",
  ///   "breed": "Siamese",
  ///   "age": 2,
  ///   "bio": "Fluffy is a cute and curious cat."
  /// });
  /// ```
  Future<void> addPet(String ownerId, Map<String, dynamic> petData) async {
    try {
      DocumentReference petRef = await _db.collection('petProfile').add(petData);
      await updateProfile(ownerId, {'petIds': FieldValue.arrayUnion([petRef])});
    } catch (e) {
      print("Error adding pet: $e");
    }
  }
  /// Updates a pet's profile with the provided data.
  ///
  /// Takes the pet's ID and a map of updated data as input.
  ///
  /// - Parameters:
  ///   - [petId]: The ID of the pet whose profile is to be updated.
  ///   - [updatedData]: A map containing the updated pet profile data.
  ///   - [updatedpetData]: {"name":"","species":"","breed":"","age":"","bio":""}
  ///
  /// - Example:
  /// ```dart
  /// await updatePet("petId123", {"name": "Dragon"});
  /// ```
  Future<void> updatePet(String petId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('petProfile').doc(petId).update(updatedData);
    } catch (e) {
      print("Error updating pet details: $e");
    }
  }
  /// Adds an event to the user's profile.
  ///
  /// Takes the user's ID and a map of event data as input.
  ///
  /// - Parameters:
  ///   - [userId]: The ID of the user who owns the event.
  ///   - [eventData]: A map containing the event's data.
  ///   - [eventdata]:{"content":"","startTime":"","endTime":"","eventTypeId":""}
  ///   - eventTypeId: (1 for vets, 2 for petkeeper and 3 for any)
  /// - Example:
  /// ```dart
  /// await addEvent("userId123", {
  ///   "content": "my pet's birthday",
  ///   "startTime": Timestamp.fromDate(DateTime(2024, 6, 30, 9, 17, 3)),
  ///   "endTime": Timestamp.fromDate(DateTime(2024, 6, 30, 11, 17, 38)),
  ///   "eventTypeId": "3",
  /// });
  /// ```
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
  /// Updates an event with the provided data.
  ///
  /// Takes the event's ID and a map of updated data as input.
  ///
  /// - Parameters:
  ///   - [eventId]: The ID of the event to be updated.
  ///   - [updatedEventData]: A map containing the updated event data.
  ///   - [eventdata]:{"content":"","startTime":"","endTime":"","eventTypeId":""}
  ///   - eventTypeId: (1 for vets, 2 for petkeeper and 3 for any)
  ///
  /// - Example:
  /// ```dart
  /// await updateEvent("eventId123", {"content": "Updated event content"});
  /// ```
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
