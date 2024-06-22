import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
    //notificationType : 1 = like,2 = event , 3 = reply ,4 = follow
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
  /// Fetches notifications for events that are about to happen within the next two days.
  Future<List<Map<String, dynamic>>?> getEventsNotifications(String userId) async {
  try {
    DateTime now = DateTime.now();
    DateTime twoDaysFromNow = now.add(Duration(days: 2));

    QuerySnapshot eventsSnapshot = await _db
        .collection('events')
        .where('UserId', isEqualTo: _db.doc('users/$userId'))
        .where('startTime', isGreaterThanOrEqualTo: now)
        .where('startTime', isLessThanOrEqualTo: twoDaysFromNow)
        .get();

    List<Map<String, dynamic>> notifications = [];
    for (DocumentSnapshot eventDoc in eventsSnapshot.docs) {
      Map<String, dynamic>? eventData = eventDoc.data() as Map<String, dynamic>?;

      // Fetch the event details using eventId from eventData
      DocumentSnapshot eventDetailsSnapshot = await _db.doc(eventData?['eventId']).get();
      Map<String, dynamic>? eventDetails = eventDetailsSnapshot.data() as Map<String, dynamic>?;

      if (eventDetails != null) {
        notifications.add({
          'event': eventDetails,
          ...?eventData,
        });
      }
    }

    return notifications.isNotEmpty ? notifications : null;
  } catch (e) {
    print("Error fetching events notifications: $e");
    return null;
  }
}

/// Fetches notifications for likes on posts.
Future<List<Map<String, dynamic>>?> getLikesNotifications(String userId) async {
  try {
    QuerySnapshot likesSnapshot = await _db
        .collection('notifications')
        .where('UserId', isEqualTo: _db.doc('users/$userId'))
        .where('NotificationTypeId', isEqualTo: 1) // Assuming NotificationTypeId 1 is for likes
        .get();

    List<Map<String, dynamic>> notifications = [];
    for (DocumentSnapshot likeDoc in likesSnapshot.docs) {
      Map<String, dynamic>? likeData = likeDoc.data() as Map<String, dynamic>?;

      // Fetch the post details using postId from likeData
      DocumentSnapshot postSnapshot = await _db.doc(likeData?['PostId']).get();
      Map<String, dynamic>? postDetails = postSnapshot.data() as Map<String, dynamic>?;

      if (postDetails != null) {
        notifications.add({
          'post': postDetails,
          ...?likeData,
        });
      }
    }

    return notifications.isNotEmpty ? notifications : null;
  } catch (e) {
    print("Error fetching likes notifications: $e");
    return null;
  }
}

  /// Fetches notifications for replies or comments on posts.
Future<List<Map<String, dynamic>>?> getReplyNotifications(String userId) async {
  try {
    QuerySnapshot repliesSnapshot = await _db
        .collection('notifications')
        .where('UserId', isEqualTo: _db.doc('users/$userId'))
        .where('NotificationTypeId', isEqualTo: 3) // Assuming NotificationTypeId 3 is for replies/comments
        .get();

    List<Map<String, dynamic>> notifications = [];
    for (DocumentSnapshot replyDoc in repliesSnapshot.docs) {
      Map<String, dynamic>? replyData = replyDoc.data() as Map<String, dynamic>?;

      // Fetch the post details using ForumId from replyData
      DocumentSnapshot postSnapshot = await _db.doc(replyData?['ForumId']).get();
      Map<String, dynamic>? postDetails = postSnapshot.data() as Map<String, dynamic>?;

      if (postDetails != null) {
        notifications.add({
          'post': postDetails,
          ...?replyData,
        });
      }
    }

    return notifications.isNotEmpty ? notifications : null;
  } catch (e) {
    print("Error fetching reply notifications: $e");
    return null;
  }
}


  /// Creates a follow notification
  Future<void> createFollowNotification(String followingId, String followedId) async {
    try {
      // Get the username of the follower
      DocumentSnapshot followingDoc = await _db.collection('users').doc(followingId).get();
      Map<String, dynamic> followingData = followingDoc.data() as Map<String, dynamic>;
      String username = followingData['userName'] ?? '';

      String content = "$username followed you";

      // Check if the notification already exists
      QuerySnapshot existingNotifs = await _db.collection('notifications')
          .where('UserId', isEqualTo: _db.doc('users/$followedId'))
          .where('NotificationTypeId', isEqualTo: 4)
          .where('Content', isEqualTo: content)
          .get();

      if (existingNotifs.docs.isNotEmpty) {
        // Notification already exists
        return;
      }

      // Create a new notification
      await _db.collection('notifications').add({
        'UserId': _db.doc('users/$followedId'),
        'NotificationTypeId': 4,
        'Content': content,
        'Read': false,
        'Avatar_Url_Id': followingId,
        'CreatedAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error creating follow notification: $e");
    }
  }
  /// Creates a like notification.
///
/// Takes the post ID and the user ID who liked the post.
Future<void> createLikeNotification(String postId, String userId) async {
  try {
    // Get the owner of the post
    DocumentSnapshot postDoc = await _db.collection('posts').doc(postId).get();
    if (!postDoc.exists) throw Exception("Post not found");
    Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
    String postOwnerId = postData['UserId']??'';

    // Get the username of the user who liked the post
    DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
    if (!userDoc.exists) throw Exception("User not found");
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    String username = userData['userName'] ?? '';

    String content = "$username has liked your post";

    // Check if the notification already exists
    QuerySnapshot existingNotifs = await _db
        .collection('notifications')
        .where('UserId', isEqualTo: _db.doc('users/$postOwnerId'))
        .where('NotificationTypeId', isEqualTo: 1)
        .where('Content', isEqualTo: content)
        .get();

    if (existingNotifs.docs.isNotEmpty) {
      // Notification already exists, return it
      return;
    } else {
      // Notification doesn't exist, insert a new one
      await _db.collection('notifications').add({
        'UserId': _db.doc('users/$postOwnerId'),
        'NotificationTypeId': 1,
        'Content': content,
        'Read': false,
        'ReferenceId': _db.doc('posts/$postId'),
        'AvatarUrlId': _db.doc('users/$userId'),
        'CreatedAt': Timestamp.now(),
      });
    }
  } catch (e) {
    print("Error creating like notification: $e");
  }
}

  
  /// Creates a comment notification.
///
/// Takes the post ID and the user ID who commented on the post.
Future<void> createReplyNotification(String postId, String userId) async {
  try {
    // Get the owner of the post
    DocumentSnapshot postDoc = await _db.collection('posts').doc(postId).get();
    if (!postDoc.exists) throw Exception("Post not found");
    Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
    String postOwnerId = postData['UserId']??'';

    // Get the username of the user who liked the post
    DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
    if (!userDoc.exists) throw Exception("User not found");
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    String username = userData['userName'] ?? '';

    String content = "$username has commented on your post";

    // Insert a new notification
    await _db.collection('notifications').add({
      'UserId': _db.doc('users/$postOwnerId'),
      'NotificationTypeId': 3,
      'Content': content,
      'Read': false,
      'ReferenceId': _db.doc('posts/$postId'),
      'AvatarUrlId': _db.doc('users/$userId'),
      'CreatedAt': Timestamp.now(),
    });
  } catch (e) {
    print("Error creating comment notification: $e");
  }
}

}