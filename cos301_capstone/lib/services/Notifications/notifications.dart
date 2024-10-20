import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsServices {
  late final FirebaseFirestore _db;
  NotificationsServices({FirebaseFirestore? db}) {
    _db = db ?? FirebaseFirestore.instance;
  }
  // Notification types
  // 1 = like, 2 = event, 3 = reply, 4 = follow

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

  Future<List<Map<String, dynamic>>?> getEventsNotifications(String userId) async {
    try {
      DateTime now = DateTime.now();
      DateTime twoDaysFromNow = now.add(Duration(days: 2));

      QuerySnapshot eventsSnapshot = await _db
          .collection('events')
          .where('UserId', isEqualTo: userId)
          .where('startTime', isGreaterThanOrEqualTo: now)
          .where('startTime', isLessThanOrEqualTo: twoDaysFromNow)
          .get();

      List<Map<String, dynamic>> notifications = [];
      for (DocumentSnapshot eventDoc in eventsSnapshot.docs) {
        Map<String, dynamic>? eventData = eventDoc.data() as Map<String, dynamic>?;

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

  Future<List<Map<String, dynamic>>?> getLikesNotifications(String userId) async {
  try {
    QuerySnapshot likesSnapshot = await _db
        .collection('notifications')
        .where('UserId', isEqualTo: userId)
        .where('NotificationTypeId', isEqualTo: 1)
        .get();

    List<Map<String, dynamic>> notifications = [];
    for (DocumentSnapshot likeDoc in likesSnapshot.docs) {
      Map<String, dynamic>? likeData = likeDoc.data() as Map<String, dynamic>?;

      // Extract forumId and messageId from the ReferenceId field
      String referenceId = likeData?['ReferenceId'] ?? '';
      List<String> referenceParts = referenceId.split('/');
      if (referenceParts.length != 2) continue;
      String forumId = referenceParts[0];
      String messageId = referenceParts[1];

      // Fetch the message details from the forum
      DocumentSnapshot messageSnapshot = await _db
          .collection('forum')
          .doc(forumId)
          .collection('messages')
          .doc(messageId)
          .get();
      Map<String, dynamic>? messageDetails = messageSnapshot.data() as Map<String, dynamic>?;

      if (messageDetails != null) {
        notifications.add({
          'message': messageDetails,
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

Future<List<Map<String, dynamic>>?> getReplyNotifications(String userId) async {
  try {
    QuerySnapshot repliesSnapshot = await _db
        .collection('notifications')
        .where('UserId', isEqualTo: userId)
        .where('NotificationTypeId', isEqualTo: 3)
        .get();

    List<Map<String, dynamic>> notifications = [];
    for (DocumentSnapshot replyDoc in repliesSnapshot.docs) {
      Map<String, dynamic>? replyData = replyDoc.data() as Map<String, dynamic>?;

      // Extract forumId and messageId from the ReferenceId field
      String referenceId = replyData?['ReferenceId'] ?? '';
      List<String> referenceParts = referenceId.split('/');
      if (referenceParts.length != 2) continue;
      String forumId = referenceParts[0];
      String messageId = referenceParts[1];

      // Fetch the message details from the forum
      DocumentSnapshot messageSnapshot = await _db
          .collection('forum')
          .doc(forumId)
          .collection('messages')
          .doc(messageId)
          .get();
      Map<String, dynamic>? messageDetails = messageSnapshot.data() as Map<String, dynamic>?;

      if (messageDetails != null) {
        notifications.add({
          'message': messageDetails,
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
Future<List<Map<String, dynamic>>?> getLikePostNotifications(String userId) async {
  try {
    QuerySnapshot likePostSnapshot = await _db
        .collection('notifications')
        .where('UserId', isEqualTo: userId)
        .where('NotificationTypeId', isEqualTo: 5)
        .get();

    List<Map<String, dynamic>> notifications = [];
    for (DocumentSnapshot likePostDoc in likePostSnapshot.docs) {
      Map<String, dynamic>? likePostData = likePostDoc.data() as Map<String, dynamic>?;

      if (likePostData != null) {
        // Fetch the post details
        String postId = likePostData['ReferenceId'];
        DocumentSnapshot postSnapshot = await _db.collection('posts').doc(postId).get();
        Map<String, dynamic>? postDetails = postSnapshot.data() as Map<String, dynamic>?;

        if (postDetails != null) {
          notifications.add({
             'post': postDetails,
            ...likePostData,
          });
        }
      }
    }

    return notifications.isNotEmpty ? notifications : null;
  } catch (e) {
    print("Error fetching like post notifications: $e");
    return null;
  }
}
  Future<List<Map<String, dynamic>>?> getCommentPostNotifications(String userId) async {
    try {
      QuerySnapshot commentPostSnapshot = await _db
          .collection('notifications')
          .where('UserId', isEqualTo: userId)
          .where('NotificationTypeId', isEqualTo: 6)
          .get();

      List<Map<String, dynamic>> notifications = [];
      for (DocumentSnapshot commentPostDoc in commentPostSnapshot.docs) {
        Map<String, dynamic>? commentPostData = commentPostDoc.data() as Map<String, dynamic>?;

        if (commentPostData != null) {
          // Extract postId and commentId from the ReferenceId field
          String referenceId = commentPostData['ReferenceId'] ?? '';
          List<String> referenceParts = referenceId.split('/');
          if (referenceParts.length != 2) continue;
          String postId = referenceParts[0];
          String commentId = referenceParts[1];

          DocumentSnapshot postSnapshot = await _db.collection('posts').doc(postId).get();
          Map<String, dynamic>? postDetails = postSnapshot.data() as Map<String, dynamic>?;

          DocumentSnapshot commentsSnapshot = await _db.collection('posts').doc(postId).collection('comments').doc(commentId).get();
          Map<String, dynamic>? commentDetails = commentsSnapshot.data() as Map<String, dynamic>?;


          if (postDetails != null) {
            notifications.add({
              'comment': commentDetails,
              'post': postDetails,
              ...commentPostData,
            });
          }
        }
      }

      return notifications.isNotEmpty ? notifications : null;
    } catch (e) {
      print("Error fetching comment post notifications: $e");
      return null;
    }
  }
  Future<void> createFollowNotification(String followingId, String followedId) async {
    try {
      //return if sending notification to self
      if (followingId == followedId) {
        return;
      }
      
      DocumentSnapshot followingDoc = await _db.collection('users').doc(followingId).get();
      Map<String, dynamic> followingData = followingDoc.data() as Map<String, dynamic>;
      String username = followingData['name'] ?? '';

      String content = "$username followed you";

      QuerySnapshot existingNotifs = await _db.collection('notifications')
          .where('UserId', isEqualTo: followedId)
          .where('NotificationTypeId', isEqualTo: 4)
          .where('Content', isEqualTo: content)
          .get();

      if (existingNotifs.docs.isNotEmpty) {
        return;
      }

      await _db.collection('notifications').add({
        'UserId': followedId,
        'NotificationTypeId': 4,
        'Content': content,
        'Read': false,
        'AvatarUrlId': followingId,
        'CreatedAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error creating follow notification: $e");
    }
  }

  Future<void> createLikeNotification(String forumId,String messageId, String userId) async {
    try {
      DocumentSnapshot postDoc = await _db.collection('forum').doc(forumId).collection('messages').doc(messageId).get();

      if (!postDoc.exists) throw Exception("Message not found");
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      String postOwnerId = postData['UserId'] ?? '';

      //return if sending notification to self
      if (postOwnerId == userId) {
        return;
      }

      DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception("User not found");
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String username = userData['name'] ?? '';

      String content = "$username has liked your message";

      QuerySnapshot existingNotifs = await _db
          .collection('notifications')
          .where('UserId', isEqualTo: postOwnerId)
          .where('NotificationTypeId', isEqualTo: 1)
          .where('Content', isEqualTo: content)
          .get();

      if (existingNotifs.docs.isNotEmpty) {
        return;
      } else {
        await _db.collection('notifications').add({
          'UserId': postOwnerId,
          'NotificationTypeId': 1,
          'Content': content,
          'Read': false,
          'ReferenceId': '$forumId/$messageId',
          'AvatarUrlId': userId,
          'CreatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      print("Error creating like notification: $e");
    }
  }

  Future<void> createReplyNotification(String forumId,String messageId,String commentId, String userId) async {
    try {
      DocumentSnapshot postDoc = await _db.collection('forum').doc(forumId).collection('messages').doc(messageId).get();
      if (!postDoc.exists) throw Exception("Message not found");
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      String postOwnerId = postData['UserId'] ?? '';

      //return if message is muted for notifications
      if(postData['mute'] ==true){
        print("Message is muted for notifications");
        return;
      }
      //return if sending notification to self
      if (postOwnerId == userId) {
        return;
      }
      
      DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception("User not found");
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String username = userData['name'] ?? '';

      String content = "$username has commented on your message";

      await _db.collection('notifications').add({
        'UserId': postOwnerId,
        'NotificationTypeId': 3,
        'Content': content,
        'Read': false,
        'ReferenceId': '$forumId/$messageId/$commentId',
        'AvatarUrlId': userId,
        'CreatedAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error creating comment notification: $e");
    }
  }
  Future<void> markAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({
      'Read': true,
    });
  }
  Future<int> countNewUnreadNotifs(String userId) async {
  try {
    // Fetch unread notifications
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection('notifications')
        .where('UserId', isEqualTo: userId)
        .where('Read', isEqualTo: false)
        .get();

    // Fetch the user's friend requests map
    DocumentSnapshot<Map<String, dynamic>> userDoc = await _db
        .collection('users')
        .doc(userId)
        .get();

    // Count unread notifications
    int unreadNotifsCount = snapshot.docs.length;

    // Check and count the friend requests
    int friendRequestsCount = 0;
    if (userDoc.exists && userDoc.data()!['friendRequests'] != null) {
      Map<String, dynamic> friendRequests = userDoc.data()!['friendRequests'];
      friendRequestsCount = friendRequests.length;
    }

    // Return total count
    return unreadNotifsCount + friendRequestsCount;
  } catch (e) {
    print("Error counting unread notifications: $e");
    return 0;
  }
}

  Future<void> createLikePostNotification(String postId, String userId) async {
    try {
      DocumentSnapshot postDoc = await _db.collection('posts').doc(postId).get();

      if (!postDoc.exists) throw Exception("Post not found");
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      String postOwnerId = postData['UserId'] ?? '';

      //return if sending notification to self
      if (postOwnerId == userId) {
        return;
      }
      
      DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception("User not found");
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String username = userData['name'] ?? '';

      String content = "$username has liked your post";

      QuerySnapshot existingNotifs = await _db
          .collection('notifications')
          .where('UserId', isEqualTo: postOwnerId)
          .where('NotificationTypeId', isEqualTo: 5)
          .where('Content', isEqualTo: content)
          .get();

      if (existingNotifs.docs.isNotEmpty) {
        return;
      } else {
        await _db.collection('notifications').add({
          'UserId': postOwnerId,
          'NotificationTypeId': 5,
          'Content': content,
          'Read': false,
          'ReferenceId': postId,
          'AvatarUrlId': userId,
          'CreatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      print("Error creating like post notification: $e");
    }
  }
  Future<void> createCommentPostNotification(String postId, String userId,String commentId) async {
    try {
      DocumentSnapshot postDoc = await _db.collection('posts').doc(postId).get();

      if (!postDoc.exists) throw Exception("Post not found");
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      String postOwnerId = postData['UserId'] ?? '';

      //return if sending notification to self
      if (postOwnerId == userId) {
        return;
      }
      
      DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception("User not found");
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String username = userData['name'] ?? '';

      String content = "$username has commented on your post";

      await _db.collection('notifications').add({
        'UserId': postOwnerId,
        'NotificationTypeId': 6,
        'Content': content,
        'Read': false,
        'ReferenceId': '$postId/$commentId',
        'AvatarUrlId': userId,
        'CreatedAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error creating comment post notification: $e");
    }
  }
  // Create a new notification for a new message added to a forum
 Future<void> createMessageNotification(String forumId, String messageId, String userId) async {
  try {
    // Fetch the forum document to get the forum owner's UserId
    DocumentReference<Map<String, dynamic>> forumDoc = _db.collection('forum').doc(forumId);
    DocumentSnapshot forumSnapshot = await forumDoc.get();
    
    if (!forumSnapshot.exists) {
      throw Exception("Forum not found");
    }

    // Extract postOwnerId (the forum owner's UserId) from the forum document
    Map<String, dynamic> forumData = forumSnapshot.data() as Map<String, dynamic>;
    String postOwnerId = forumData['UserId']; // Forum owner's UserId
    String forumName = forumData['Name'];     // Forum name
    
    print("mute: ${forumData['mute']}");
    //return if forum is muted for notifications
    if(forumData['mute'] ==true){
      print("Forum is muted for notifications");
      return;
    }
    // Return if sending notification to self
    if (postOwnerId == userId) {
      return;
    }

    // Fetch user details of the message sender (userId)
    DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception("User not found");
    }

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    String name = userData['name'] ?? '';

    // Set the notification content
    String content = "$name added a message to your forum: $forumName";

    await _db.collection('notifications').add({
      'UserId': postOwnerId,                    // Forum owner's UserId
      'NotificationTypeId': 7,                  // Notification type for new message
      'Content': content,                       // Notification content
      'Read': false,                            // Initially unread
      'ReferenceId': '$forumId/$messageId',     // Reference to the forum and message
      'AvatarUrlId': userId,                    // AvatarUrlId of the message sender
      'CreatedAt': Timestamp.now(),             // Creation time of the notification
    });

    print("Notification created successfully");
  } catch (e) {
    print("Error creating message notification: $e");
  }
}
}