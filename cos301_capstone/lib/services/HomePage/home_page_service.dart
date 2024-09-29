import 'dart:io';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:cos301_capstone/services/general/general_service.dart';

import 'package:cos301_capstone/services/Notifications/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePageService {
  late final FirebaseFirestore _db;
  late final FirebaseStorage _storage;
  HomePageService({FirebaseFirestore? db, FirebaseStorage? storage}) {
    _db = db ?? FirebaseFirestore.instance;
    _storage = storage ?? FirebaseStorage.instance;
  }
  NotificationsServices notif = NotificationsServices();

  Future<bool> addPost(
    String userId,
    PlatformFile platformFile,
    String content,
    List<Map<String, dynamic>> petIds,
  ) async {
    try {
      // Create a map for the initial post data without the photo URL and postId
      final postData = {
        'UserId': userId,
        'Content': content,
        'CreatedAt': DateTime.now(),
        'ImgUrl': '', // Placeholder for the photo URL
        'PetIds': petIds,
        'pictureUrl': profileDetails.profilePicture.replaceAll('"', ''),
        'name': profileDetails.name
      };

      // Add the initial post data to Firestore to get the postId
      DocumentReference postRef = await _db.collection('posts').add(postData);
      String postId = postRef.id;

      // Generate a unique file name for the photo including the postId
      String photoFileName =
          'posts/${userId}_${postId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(platformFile.name)}';

      // Convert PlatformFile to Uint8List (byte data)
      Uint8List? fileBytes = platformFile.bytes;
      if (fileBytes == null) {
        throw Exception("File data is null");
      }

      // Set metadata to force the MIME type to be image/jpeg
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');

      // Upload the photo to Firebase Storage
      TaskSnapshot uploadTask =
          await _storage.ref(photoFileName).putData(fileBytes, metadata);

      // Retrieve the photo URL
      String imgUrl = await uploadTask.ref.getDownloadURL();

      // Update postData to include the photo URL and postId
      postData['ImgUrl'] = imgUrl;
      postData['PostId'] = postId;

      // Update the document with the new postData including the photo URL and postId
      await postRef.set(postData, SetOptions(merge: true));

      print("Post added successfully with photo.");
      return true; // Return true if the post is added successfully
    } catch (e) {
      print("Error adding post with photo: $e");
      return false; // Return false if an error occurs
    }
  }

  Future<bool> updatePost(
    String postId,
    String content,
    List<String> petIds,
  ) async {
    try {
      // Create a map for the updated post data
      final postData = {
        'Content': content,
        'PetIds': petIds,
      };

      // Update the post in the "posts" collection
      await _db.collection('posts').doc(postId).update(postData);
      print("Post updated successfully.");
      return true; // Return true if the post is updated successfully
    } catch (e) {
      print("Error updating post: $e");
      return false; // Return false if an error occurs
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      // Step 1: Retrieve the post document to get the image file path
      DocumentSnapshot postSnapshot =
          await _db.collection('posts').doc(postId).get();
      String filePath = (postSnapshot.data() as Map<String, dynamic>)['ImgUrl'];

      // Step 2: Call deleteImageFromStorage with the retrieved file path
      await GeneralService().deleteImageFromStorage(filePath);

      // Step 3: Delete the post document from Firestore
      await _db.collection('posts').doc(postId).delete();
      print("Post and associated image deleted successfully.");
      return true; // Return true if the post and image are deleted successfully
    } catch (e) {
      print("Error deleting post or image: $e");
      return false; // Return false if an error occurs
    }
  }
  DocumentSnapshot? _lastDocument;
  Future<List<Map<String, dynamic>>> getPosts({int limit = 10, bool isLoadMore = false}) async {
    try {
      Query query = _db.collection('posts').orderBy('CreatedAt', descending: true).limit(limit);

      if (isLoadMore && _lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last; // Update the last document
      }

      final posts = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      print("Posts fetched successfully.");
      return posts;
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPostsByLabels(String? words, {int limit = 10, bool isLoadMore = false}) async {
    try {
      Query query = _db.collection('posts').orderBy('CreatedAt', descending: true).limit(limit);

      if (isLoadMore && _lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last; // Update the last document
      }

      final posts = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (words == null || words.isEmpty) {
        return posts;
      }

      final wordList = words.toLowerCase().split(' ');

      final filteredPosts = posts.where((post) {
        final labels = post['labels'] as List<dynamic>?;
        if (labels == null) return false;

        final lowerCaseLabels = labels.map((label) => label.toString().toLowerCase()).toList();

        return wordList.any((word) => lowerCaseLabels.any((label) => label.contains(word)));
      }).toList();

      print("Posts fetched and filtered successfully.");
      return filteredPosts;
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }

  void resetPagination() {
    _lastDocument = null; // Reset the last document for pagination
  }

  Future<void> toggleLikeOnPost(String postId, String userId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    DocumentSnapshot likeSnapshot =
        await postRef.collection('likes').doc(userId).get();

    if (likeSnapshot.exists) {
      // Like exists, so delete it
      await postRef.collection('likes').doc(userId).delete();
    } else {
      // Like does not exist, so add it
      await postRef.collection('likes').doc(userId).set({
        'likedAt': DateTime.now(),
        // Additional like information can go here
      });
      //add like notification
      notif.createLikePostNotification(postId, userId);
    }
  }

  Future<bool> checkIfUserLikedPost(String postId, String userId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    DocumentSnapshot likeSnapshot =
        await postRef.collection('likes').doc(userId).get();
    return likeSnapshot.exists;
  }

  Future<void> addCommentToPost(
      String postId, String userId, String comment) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    DocumentReference<Map<String, dynamic>> commentRef =
        await postRef.collection('comments').add({
      'userId': userId, // Storing the userId of the commenter
      'comment': comment, // Storing the actual comment text
      'commentedAt': DateTime.now(), // Storing the timestamp of the comment
      // Additional comment information can go here
    });
    notif.createCommentPostNotification(postId, userId, commentRef.id);
  }

  Future<void> addViewToPost(String postId, String userId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    await postRef.collection('views').doc(userId).set({
      'viewedAt': DateTime.now(),
      // Additional view information can go here
    });
  }

  Future<void> deleteCommentFromPost(String postId, String commentId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    await postRef.collection('comments').doc(commentId).delete();
  }

  Future<int> getLikesCount(String postId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    final querySnapshot = await postRef.collection('likes').get();
    if (querySnapshot.docs.isEmpty) {
      return 0;
    }
    return querySnapshot.docs.length;
  }

  Future<int> getCommentsCount(String postId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    final querySnapshot = await postRef.collection('comments').get();
    if (querySnapshot.docs.isEmpty) {
      return 0;
    }
    return querySnapshot.docs.length;
  }

  Future<int> getViewsCount(String postId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    final querySnapshot = await postRef.collection('views').get();
    if (querySnapshot.docs.isEmpty) {
      return 0;
    }
    return querySnapshot.docs.length;
  }

  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    final querySnapshot = await postRef.collection('comments').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<String>> getPostLabels(String postId) async {
    try {
      // Fetch the document for the given postId from the "posts" collection
      DocumentSnapshot docSnapshot =
          await _db.collection('posts').doc(postId).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Extract the labels array from the document data
        List<dynamic> labels = docSnapshot.get('labels');

        // Convert the dynamic list to a list of strings
        List<String> labelsList = labels.cast<String>();

        print("Labels fetched successfully for post: $postId");
        return labelsList;
      } else {
        print("Post not found for postId: $postId");
        return [];
      }
    } catch (e) {
      print("Error fetching labels for post: $e");
      return [];
    }
  }

  Future<List<String>> getWikiLinks(List<String> labels) async {
    List<String> wikiLinks = [];

    for (String label in labels) {
      // Create a Wikipedia link directly for each label
      String formattedLabel =
          label.replaceAll(' ', '_'); // Replace spaces with underscores
      String link = 'https://en.wikipedia.org/wiki/$formattedLabel';

      wikiLinks.add(link);
    }

    return wikiLinks;
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      // Fetch the document for the given userId from the "users" collection
      DocumentSnapshot docSnapshot =
          await _db.collection('users').doc(userId).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Extract the user details from the document data
        Map<String, dynamic> userDetails =
            docSnapshot.data() as Map<String, dynamic>;

        print("User details fetched successfully for userId: $userId");
        return userDetails;
      } else {
        print("User not found for userId: $userId");
        return {};
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return {};
    }
  }

  Future<List<String>> getLikes(String postId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    final querySnapshot = await postRef.collection('likes').get();

    return querySnapshot.docs.map((doc) => doc.id).toList();
  }
}
