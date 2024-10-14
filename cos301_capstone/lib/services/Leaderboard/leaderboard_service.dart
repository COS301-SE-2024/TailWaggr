import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  // Method to set a user's score in the leaderboard
  Future<void> setScore(String userId, int score) async {
    try {
      await _firestore.collection(_collectionPath).doc(userId).set({
        'score': score,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error setting score: $e');
    }
  }

  // Method to get the top scores from the leaderboard
  Future<List<Map<String, dynamic>>> getTopScores(int limit) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionPath)
          .orderBy('score', descending: true)
          .limit(limit)
          .get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting top scores: $e');
      return [];
    }
  }
}