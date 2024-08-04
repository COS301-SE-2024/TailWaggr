// import 'dart:ffi';
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

  /// The following fields can be updated in the user profile:
  ///
  /// - address: (string) The user's address.
  /// - authId: (string) The authentication ID of the user.
  /// - bio: (string) A short biography of the user.
  /// - email: (string) The user's email address.
  /// - location: (geopoint) The user's geographical location.
  /// - name: (string) The user's first name.
  /// - preferences: (map) A map containing user preferences.
  ///   - sidebarImage: (PlatformFile) The new sidebar image file.
  ///   - usingImage: (bool) Whether the user is using an image.
  ///   - color: (map) A map containing the user's preferred color scheme.
  ///     - primary: (Int) The primary color.
  ///     - secondary: (Int) The secondary color.
  ///     - tertiary: (Int) The tertiary color.
  ///     - background: (Int) The background color.
  ///     - text: (Int) The text color.
  ///     - cardColor: (Int) The card color.
  ///     - sidebarColor: (Int) The sidebar color.
  ///   - sidebarImage: (string) The URL of the sidebar image.
  ///   - themeMode: (string) whether light, dark or custom.
  /// - profilePictureUrl: (string) The URL of the user's profile picture.
  /// - profileImage: (PlatformFile) The new profile image file.
  /// - surname: (string) The user's surname.
  /// - userName: (string) The user's username.
  /// - userType: (string) The type of user (e.g., "pet_keeper").
  Future<void> updateProfile(String userId, Map<String, dynamic> updatedData, PlatformFile? profileImage, PlatformFile? sidebarImage) async {
    try {
      // Update profile data
      await _db.collection('users').doc(userId).update(updatedData);

      // Update profile image
      if (profileImage != null) {
        String profilePhotoFileName = 'profile_images/${userId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(profileImage.name)}';
        Uint8List? profileFileBytes = profileImage.bytes;
        if (profileFileBytes == null) {
          throw Exception("Profile image data is null");
        }
        SettableMetadata profileMetadata = SettableMetadata(contentType: 'image/jpeg');
        TaskSnapshot profileUploadTask = await _storage.ref(profilePhotoFileName).putData(profileFileBytes, profileMetadata);
        String profileImgUrl = await profileUploadTask.ref.getDownloadURL();

        // Delete the old profile image
        String? oldProfileImageUrl = await getUserDetails(userId).then((value) => value?['profilePictureUrl']);
        if (oldProfileImageUrl != null) {
          await _storage.refFromURL(oldProfileImageUrl).delete();
        }

        await _updateProfileData(userId, {'profilePictureUrl': profileImgUrl});
      }

      // Update sidebar image
      if (sidebarImage != null) {
        String sidebarPhotoFileName = 'sidebar_images/${userId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(sidebarImage.name)}';
        Uint8List? sidebarFileBytes = sidebarImage.bytes;
        if (sidebarFileBytes == null) {
          throw Exception("Sidebar image data is null");
        }
        SettableMetadata sidebarMetadata = SettableMetadata(contentType: 'image/jpeg');
        TaskSnapshot sidebarUploadTask = await _storage.ref(sidebarPhotoFileName).putData(sidebarFileBytes, sidebarMetadata);
        String sidebarImgUrl = await sidebarUploadTask.ref.getDownloadURL();

        // Delete the old sidebar image
        String? oldSidebarImageUrl = await getUserDetails(userId).then((value) => value?['sidebarImage']);
        if (oldSidebarImageUrl != null) {
          await _storage.refFromURL(oldSidebarImageUrl).delete();
        }

        await _updateProfileData(userId, {'sidebarImage': sidebarImgUrl});
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> _updateProfileData(String userId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('users').doc(userId).update(updatedData);
      print("Profile updated successfully.");
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<List<DocumentReference>> getUserPosts(String userId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('posts').where('UserId', isEqualTo: _db.collection('users').doc(userId)).get();
      return snapshot.docs.map((doc) => doc.reference).toList();
    } catch (e) {
      print("Error fetching user posts: $e");
      return [];
    }
  }

  Future<void> addPet(String ownerId, Map<String, dynamic> petData, PlatformFile? profileImage) async {
    try {
      DocumentReference docRef = await _db.collection('users').doc(ownerId).collection('pets').add(petData);

      // Add pet profile image
      if (profileImage != null) {
        String photoFileName = 'pet_images/${ownerId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(profileImage.name)}';
        Uint8List? fileBytes = profileImage.bytes;
        if (fileBytes == null) {
          throw Exception("File data is null");
        }
        SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
        TaskSnapshot uploadTask = await _storage.ref(photoFileName).putData(fileBytes, metadata);
        String imgUrl = await uploadTask.ref.getDownloadURL();

        await _updatePetData(ownerId, docRef.id, {'pictureUrl': imgUrl});
      }
    } catch (e) {
      print("Error adding pet: $e");
    }
  }
  Future<void> deletePet(String ownerId, String petId) async {
    try {
      // Delete the pet profile image
      String? petImageUrl = await getPetProfile(ownerId, petId).then((value) => value?['pictureUrl']);
      if (petImageUrl != null) {
        await _storage.refFromURL(petImageUrl).delete();
      }
      // Delete the pet document
      await _db.collection('users').doc(ownerId).collection('pets').doc(petId).delete();
      print("Pet deleted successfully.");
    } catch (e) {
      print("Error deleting pet: $e");
    }
  }

  Future<void> _updatePetData(String ownerId, String petId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('users').doc(ownerId).collection('pets').doc(petId).update(updatedData);
      print("Pet updated successfully.");
    } catch (e) {
      print("Error updating pet: $e");
    }
  }

  Future<void> updatePet(String userID, String petId, Map<String, dynamic> updatedData, PlatformFile? profileImage) async {
    try {
      await _db.collection('users').doc(userID).collection('pets').doc(petId).update(updatedData);

      // Update pet profile image
      if (profileImage != null) {
        String photoFileName = 'pet_images/${userID}_${DateTime.now().millisecondsSinceEpoch}${path.extension(profileImage.name)}';
        Uint8List? fileBytes = profileImage.bytes;
        if (fileBytes == null) {
          throw Exception("File data is null");
        }
        SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
        TaskSnapshot uploadTask = await _storage.ref(photoFileName).putData(fileBytes, metadata);
        String imgUrl = await uploadTask.ref.getDownloadURL();

        // Delete the old pet profile image
        String? oldImageUrl = await getPetProfile(userID, petId).then((value) => value?['pictureUrl']);
        if (oldImageUrl != null) {
          await _storage.refFromURL(oldImageUrl).delete();
        }

        await _updatePetData(userID, petId, {'pictureUrl': imgUrl});
      }
    } catch (e) {
      print("Error updating pet: $e");
    }
  }
}
