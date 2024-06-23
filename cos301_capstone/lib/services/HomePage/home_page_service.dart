import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> addPost(
    String userId,
    File photo, // Assuming photo is a File object
    String content,
    DateTime createdAt,
    String forumId,
    String parentId,
    List<String> petIds,
  ) async {
    try {
      // Generate a unique file name for the photo
      String photoFileName = 'posts/${userId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(photo.path)}';

      // Upload the photo to Firebase Storage
      TaskSnapshot uploadTask = await _storage.ref(photoFileName).putFile(photo);

      // Retrieve the photo URL
      String imgUrl = await uploadTask.ref.getDownloadURL();

      // Create a map for the post data, including the imgUrl
      final postData = {
        'UserId': userId,
        'Content': content,
        'CreatedAt': createdAt,
        'ImgUrl': imgUrl, // Use the uploaded photo URL
        'PetIds': petIds,
      };

      // Add the post to the "posts" collection
      await _db.collection('posts').add(postData);
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
      // Delete the post from the "posts" collection
      await _db.collection('posts').doc(postId).delete();
      print("Post deleted successfully.");
      return true; // Return true if the post is deleted successfully
    } catch (e) {
      print("Error deleting post: $e");
      return false; // Return false if an error occurs
    }
  }
  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      // Fetch the posts from the "posts" collection
      final querySnapshot = await _db.collection('posts').get();

      // Convert each document to a map and add it to a list
      final posts = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      print("Posts fetched successfully.");
      return posts; // Return the list of posts
    } catch (e) {
      print("Error fetching posts: $e");
      return []; // Return an empty list if an error occurs
    }
  }
}