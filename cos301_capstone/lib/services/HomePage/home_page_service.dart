import 'dart:io';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:cos301_capstone/services/general/general_service.dart';

import 'package:cos301_capstone/services/Notifications/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  NotificationsServices notif = NotificationsServices();


  Future<bool> addPost(
    String userId,
    PlatformFile platformFile,
    String content,
    List<Map<String, dynamic>> petIds,
  ) async {
    try {

      // Generate a unique file name for the photo
      String photoFileName = 'posts/${userId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(platformFile.name)}';


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

      String profilePhoto = profileDetails.profilePicture.replaceAll('"', '');


      // Create a map for the post data, including the imgUrl
      final postData = {
        'UserId': userId,
        'Content': content,
        'CreatedAt': DateTime.now(),
        'ImgUrl': imgUrl, // Use the uploaded photo URL
        'PetIds': petIds,
        'pictureUrl' : profilePhoto,
        'name' : profileDetails.name
      };
      DocumentReference postRef = await _db.collection('posts').add(postData);


      // Update postData to include postId
      postData['PostId'] = postRef.id;

      // Update the document with the new postData including the postId
      await postRef.set(postData);

      print("Likes and comments subcollections initialized");
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
      DocumentSnapshot postSnapshot = await _db.collection('posts').doc(postId).get();
      String filePath = (postSnapshot.data() as Map<String, dynamic>)['imagePath'];
  
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

  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      // Fetch the posts from the "posts" collection
      final querySnapshot = await _db.collection('posts').get();

      // Convert each document to a map and add it to a list
      final posts = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      // Sort the posts from newest to oldest based on the 'CreatedAt' field
      posts.sort((a, b) => b['CreatedAt'].compareTo(a['CreatedAt']));

      print("Posts fetched successfully.");
      return posts; // Return the list of posts
    } catch (e) {
      print("Error fetching posts: $e");
      return []; // Return an empty list if an error occurs
    }
  }
  Future<void> toggleLikeOnPost(String postId, String userId) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    DocumentSnapshot likeSnapshot = await postRef.collection('likes').doc(userId).get();

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
  Future<void> addCommentToPost(String postId, String userId, String comment) async {
    DocumentReference postRef = _db.collection('posts').doc(postId);
    DocumentReference<Map<String, dynamic>> commentRef = await postRef.collection('comments').add({
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
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
