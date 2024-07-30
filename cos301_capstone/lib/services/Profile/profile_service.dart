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
  Future<Map<String, dynamic>?> getPetProfile(String userId, String petId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).collection('pets').doc(petId).get();
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
  Future<List<Map<String, dynamic>>> getUserPets(String userId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('users').doc(userId).collection('pets').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching user pets: $e");
      return [];
    }
  }

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
      String? oldImageUrl = await getPetProfile(ownerId, petId).then((value) => value?['pictureUrl']);
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