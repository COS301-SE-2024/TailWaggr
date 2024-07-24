import 'dart:ffi';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:cos301_capstone/services/general/general_service.dart';

class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
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
      await _db.collection('users').doc(userId).update(updatedData);
    } catch (e) {
      print("Error updating profile: $e");
    }
  }
  Future<String?> updateProfileImage(String userId, PlatformFile platformFile) async {
    try {
      // Generate a unique file name for the photo
      String photoFileName = 'profile_images/${userId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(platformFile.name)}';
      // Convert PlatformFile to Uint8List (byte data)
      Uint8List? fileBytes = platformFile.bytes;
      if (fileBytes == null) {
        throw Exception("File data is null");
      }
      // Set metadata to force the MIME type to be image/jpeg
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      // Upload the photo to Firebase Storage
      TaskSnapshot uploadTask = await _storage.ref(photoFileName).putData(fileBytes, metadata);
      // Retrieve the photo URL
      String imgUrl = await uploadTask.ref.getDownloadURL();

      // Delete the old profile image
      String? oldImageUrl = await getUserDetails(userId).then((value) => value?['profilePictureUrl']);
      if (oldImageUrl != null) {
        await _storage.refFromURL(oldImageUrl).delete();
      }

      await updateProfile(userId, {'profilePictureUrl': imgUrl});
    } catch (e) {
      print("Error updating profile image: $e");
      return null;
    }
  }
  Future<String?> updatePetProfileImage(String ownerId, String petId, PlatformFile platformFile) async {
    try {
      // Generate a unique file name for the photo
      String photoFileName = 'pet_images/${ownerId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(platformFile.name)}';
      // Convert PlatformFile to Uint8List (byte data)
      Uint8List? fileBytes = platformFile.bytes;
      if (fileBytes == null) {
        throw Exception("File data is null");
      }
      // Set metadata to force the MIME type to be image/jpeg
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      // Upload the photo to Firebase Storage
      TaskSnapshot uploadTask = await _storage.ref(photoFileName).putData(fileBytes, metadata);
      // Retrieve the photo URL
      String imgUrl = await uploadTask.ref.getDownloadURL();

      // Delete the old pet profile image
      String? oldImageUrl = await getPetProfile(petId).then((value) => value?['pictureUrl']);
      if (oldImageUrl != null) {
        await _storage.refFromURL(oldImageUrl).delete();
      }

      await updatePet(ownerId, petId, {'pictureUrl': imgUrl});
    } catch (e) {
      print("Error updating pet profile image: $e");
      return null;
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
      await _db.collection('users').doc(ownerId).collection('pets').add(petData);
      print("Pet added successfully.");
    } catch (e) {
      print("Error adding pet: $e");
    }
  }
  Future<void> updatePet(String userID, String petId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('users').doc(userID).collection('pets').doc(petId).update(updatedData);
    } catch (e) {
      print("Error updating pet: $e");
    }
  }
  Future<void> followUser(String userId, String followingId) async {
    try {
      // Add to follow collection
      DocumentReference followRef =  await _db.collection('follows').add({
        'followerId': _db.doc('users/$userId'),
        'followingId': _db.doc('users/$followingId'),
        'createdAt': Timestamp.now(),
      });

      // Add to notifications collection
      await _db.collection('notifications').add({
        'UserId': _db.doc('users/$followingId'),
        'NotificationTypeId': 4,
        'Read': false,
        'ReferenceId': _db.doc('notifications/$followRef'),
        'CreatedAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error following user: $e");
    }
  }
  Future<void> updatePreferences(String userId, bool darkMode, Color sideBarColor, PlatformFile platformFile) async {
    try {
      // Update the user's preferences
      await _db.collection('users').doc(userId).update({
        'DarkMode': darkMode,
        'SideBarColor': sideBarColor.value,
      });

      Reference ref = _storage.ref().child('sidebar_images/$userId');
      UploadTask uploadTask = ref.putData(platformFile.bytes!);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _db.collection('users').doc(userId).update({'sidebarImage': downloadUrl});
    }
    catch (e) {
      print("Error updating preferences: $e");
    }
  }
}