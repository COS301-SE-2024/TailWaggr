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

        // Add user profile data to the 'profile' collection
        await _db.collection('profile').doc(user.uid).set({
          'Bio': '',
          'DarkMode': false,
          'ProfileImg': '', 
          'UserId': _db.collection('users').doc(user.uid) // Reference to the user document
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

  Future<String?> getCurrentUserId() async {
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

Future<String?> getUserByAuthId(String authId) async {
  try {
    // Query the collection to find a document where the 'authId' field matches the provided authId
    QuerySnapshot snapshot = await _db.collection('users').where('authId', isEqualTo: authId).get();
    
    if (snapshot.docs.isNotEmpty) {
 // Return the document ID of the first document found
      return snapshot.docs.first.id;
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
