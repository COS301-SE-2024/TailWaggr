import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<Map<String, dynamic>?> getFollowNotifications(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('notifications').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        print("No follow notifications found for the given userId.");
        return null;
      }
    } catch (e) {
      print("Error fetching follow notifications data: $e");
      return null;
    }
  }
}