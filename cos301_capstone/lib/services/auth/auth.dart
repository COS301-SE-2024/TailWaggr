import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signUp(String email, String password, String name, String surname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'authId': user.uid,
          'name': name,
          'surname': surname,
          'email': email,
          'typeUser': 'pet_owner'
        });
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final User? loggedUser = _auth.currentUser;

    if (loggedUser != null) {
      // User is signed in
      final String uid = loggedUser.uid;
      return await getUserByAuthId(uid);
    } else {
      // User is signed out
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByAuthId(String authId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(authId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print("No user found for the given authId.");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}