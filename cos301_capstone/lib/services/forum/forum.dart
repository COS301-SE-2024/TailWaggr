import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/services/Notifications/notifications.dart';

class ForumServices {
  late final FirebaseFirestore _db;
  ForumServices({FirebaseFirestore? db}) {
    _db = db ?? FirebaseFirestore.instance;
  }
  NotificationsServices notif = NotificationsServices();

  /// Creates a new forum in the database.
  Future<DocumentReference<Object?>> createForum(
    String name, // forum name
    String userId, // userId of forum owner
    String des // forum description
  ) async {
    try {
      // Get imgUrl
      DocumentSnapshot postDoc = await _db.collection('users').doc(userId).get();
      if (!postDoc.exists) throw Exception("user not found");
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      String imgUrl = postData['ImgUrl'] ?? '';

      // Get Time
      DateTime now = DateTime.now();
      DocumentReference ref = await _db.collection('forum').add({
        'CreatedAt': now,
        'ImgUrl': imgUrl,
        'Name': name,
        'Description': des,
        'UserId': userId,
        'mute': false
      });
      print('Forum created successfully.');
      return ref;
    } catch (e) {
      print('Error creating forum: $e');
      throw Exception('Failed to create forum.');
    }
  }

  /// Deletes a forum from the database.
  Future<void> deleteForum(String forumId) async {
    try {
      await _db.collection('forum').doc(forumId).delete();
    } catch (e) {
      print('Error deleting forum: $e');
      throw Exception('Failed to delete forum.');
    }
  }
  /// Retrieves all forums from the database.
  Future<List<Map<String, dynamic>>?> getForums() async {
    try {
      QuerySnapshot forumsSnapshot = await _db.collection('forum').get();

      List<Map<String, dynamic>> forums = [];
      for (DocumentSnapshot doc in forumsSnapshot.docs) {
        Map<String, dynamic>? forumData = doc.data() as Map<String, dynamic>?;
        if (forumData != null) {
          QuerySnapshot messagesSnapshot = await _db
          .collection('forum')
          .doc(doc.id)
          .collection('messages')
          .get();

          //get recent message Timestamp
          DateTime recentMessage = getRecentMessage(messagesSnapshot.docs);
          forums.add({
            'forumId': doc.id,
            ...forumData,
            'messagesCount': messagesSnapshot.docs.length,
            'lastUpdated': recentMessage,
          });
        }
      }
      //print(forums);
      return forums.isNotEmpty ? forums : null;
    } catch (e) {
      print('Error fetching forums: $e');
      return null;
    }
  }
  //delete message
  Future<void> deleteMessage(String forumId, String messageId) async {
    try {
      await _db.collection('forum').doc(forumId).collection('messages').doc(messageId).delete();
    } catch (e) {
      print('Error deleting message: $e');
      throw Exception('Failed to delete message.');
    }
  }
  /// Retrieves messages associated with a forum including likes and replies.
  Future<List<Map<String, dynamic>>?> getMessages(String forumId) async {
    try {
      QuerySnapshot messagesSnapshot = await _db
          .collection('forum')
          .doc(forumId)
          .collection('messages')
          .get();

      List<Map<String, dynamic>> messages = [];
      for (DocumentSnapshot messageDoc in messagesSnapshot.docs) {
        Map<String, dynamic>? messageData = messageDoc.data() as Map<String, dynamic>?;

        if (messageData != null) {
          // Fetch likes for the message
          QuerySnapshot likesSnapshot = await messageDoc.reference.collection('likes').get();
          List<Map<String, dynamic>> likes = [];
          for (DocumentSnapshot likeDoc in likesSnapshot.docs) {
            Map<String, dynamic>? likeData = likeDoc.data() as Map<String, dynamic>?;
            if (likeData != null) {
              likes.add({
                'likeId': likeDoc.id,
                ...likeData,
              });
            }
          }

          // Fetch replies for the message
          QuerySnapshot repliesSnapshot = await messageDoc.reference.collection('replies').get();
          List<Map<String, dynamic>> replies = [];
          for (DocumentSnapshot replyDoc in repliesSnapshot.docs) {
            Map<String, dynamic>? replyData = replyDoc.data() as Map<String, dynamic>?;
            if (replyData != null) {
              replies.add({
                'replyId': replyDoc.id,
                ...replyData,
              });
            }
          }

          messages.add({
            'messageId': messageDoc.id, // Corrected here to add messageId
            'message': messageData,
            'likesCount': likes.length,
            'repliesCount': replies.length,
            'replies':replies,
          });
        }
      }
      //print(messages);
      return messages.isNotEmpty ? messages : null;
    } catch (e) {
      print('Error fetching messages: $e');
      return null;
    }
  }
  /// Creates a new message in Firestore.
  Future<DocumentReference?> createMessage(String forumId, String userId, String content) async {
    try {
      // Create a new message document
      DocumentReference messageRef = await _db.collection('forum').doc(forumId).collection('messages').add({
        'UserId': userId,
        'Content': content,
        'CreatedAt': Timestamp.now(),
        'mute': false,
      });

      notif.createMessageNotification(forumId,messageRef.id, userId);
      return messageRef;
    } catch (e) {
      print('Error creating message: $e');
      return null;
    }
  }

  /// Likes a message in Firestore.
  Future<DocumentReference?> likeMessage(String forumId, String messageId, String userId) async {
    try {
      // Add a new like document under the message
      DocumentReference likeRef = await _db.collection('forum').doc(forumId).collection('messages').doc(messageId).collection('likes').add({
        'UserId': userId,
        'CreatedAt': Timestamp.now(),
      });

      // Create Like notification
      notif.createLikeNotification(forumId,messageId, userId);

      return likeRef;
    } catch (e) {
      print('Error liking message: $e');
      return null;
    }
  }

  /// Replies to a message in Firestore.
  Future<DocumentReference?> replyToMessage(String forumId, String messageId, String userId, String content) async {
    try {
      // Add a new reply document under the message
      DocumentReference replyRef = await _db.collection('forum').doc(forumId).collection('messages').doc(messageId).collection('replies').add({
        'UserId': userId,
        'Content': content,
        'CreatedAt': Timestamp.now(),
      });

      // Create reply notification
      notif.createReplyNotification(forumId,messageId,replyRef.id, userId);

      return replyRef;
    } catch (e) {
      print('Error replying to message: $e');
      return null;
    }
  }
 // Toggles like on a message
  Future<void> toggleLikeOnMessage(String forumId, String messageId, String userId) async {
    DocumentReference messageRef = _db.collection('forum').doc(forumId).collection('messages').doc(messageId);
    DocumentReference likeRef = messageRef.collection('likes').doc(userId);

    DocumentSnapshot likeSnapshot = await likeRef.get();

    if (likeSnapshot.exists) {
      await likeRef.delete();
    } else {
      await likeRef.set({
        'userId': userId,
        'CreatedAt': FieldValue.serverTimestamp(),
      });
      // Create Like notification
      notif.createLikeNotification(forumId,messageId, userId);
    }
  }

  // Get likes count for a message
  Future<int> getLikesCount(String forumId, String messageId) async {
    QuerySnapshot likesSnapshot = await _db.collection('forum').doc(forumId).collection('messages').doc(messageId).collection('likes').get();
    return likesSnapshot.docs.length;
  }

  // Get replies count for a message
  Future<int> getRepliesCount(String forumId, String messageId) async {
    QuerySnapshot repliesSnapshot = await _db.collection('forum').doc(forumId).collection('messages').doc(messageId).collection('replies').get();
    return repliesSnapshot.docs.length;
  }
   Future<List<Map<String, dynamic>>?> getReplies(String forumId, String messageId) async {
    try {
      QuerySnapshot repliesSnapshot = await _db
          .collection('forum')
          .doc(forumId)
          .collection('messages')
          .doc(messageId)
          .collection('replies')
          .get();

      List<Map<String, dynamic>> replies = [];
      for (DocumentSnapshot replyDoc in repliesSnapshot.docs) {
        Map<String, dynamic>? replyData = replyDoc.data() as Map<String, dynamic>?;

        if (replyData != null) {
          replies.add({
            'replyId': replyDoc.id,
            ...replyData,
          });
        }
      }
      //print(replies);
      return replies.isNotEmpty ? replies : null;
    } catch (e) {
      print('Error fetching replies: $e');
      return null;
    }
}

  DateTime getRecentMessage(List<QueryDocumentSnapshot<Object?>> docs) {
    DateTime recentMessage = DateTime(2021);
    for (var doc in docs) {
      Map<String, dynamic> messageData = doc.data() as Map<String, dynamic>;
      DateTime messageTime = messageData['CreatedAt'].toDate();
      if (messageTime.isAfter(recentMessage)) {
        recentMessage = messageTime;
      }
    }
    return recentMessage;
  }
  Future<void> deleteReply(String forumId, String messageId, String replyId) async {
    try {
      await _db.collection('forum').doc(forumId).collection('messages').doc(messageId).collection('replies').doc(replyId).delete();
      print('Reply deleted successfully.');
    } catch (e) {
      print('Error deleting reply: $e');
      throw Exception('Failed to delete reply.');
    }
  }
Future<void> togglemuteForum(String forumId, String userId) async {
  try {
    // Reference to the forum document
    DocumentReference<Map<String, dynamic>> forumDoc = _db.collection('forum').doc(forumId);

    // Fetch the current mute status
    DocumentSnapshot forumSnapshot = await forumDoc.get();
    if (!forumSnapshot.exists) {
      throw Exception("Forum not found");
    }

    Map<String, dynamic> forumData = forumSnapshot.data() as Map<String, dynamic>;
    bool isMuted = forumData['mute'] ?? false;  // Default to false if 'mute' is not present

    // Toggle the mute status
    await forumDoc.update({
      'mute': !isMuted,
    });

    print("Forum mute toggled to: ${!isMuted}");
  } catch (e) {
    print("Error toggling forum mute: $e");
  }
}


  Future<void> togglemuteMessage(String messageId, String forumId, String userId) async {
  try {
    // Reference to the message document
    DocumentReference<Map<String, dynamic>> messageDoc = _db.collection('forum').doc(forumId).collection('messages').doc(messageId);

    // Fetch the current mute status
    DocumentSnapshot messageSnapshot = await messageDoc.get();
    if (!messageSnapshot.exists) {
      throw Exception("Message not found");
    }

    Map<String, dynamic> messageData = messageSnapshot.data() as Map<String, dynamic>;
    bool isMuted = messageData['mute'] ?? false;  // Default to false if 'mute' is not present

    // Toggle the mute status
    await messageDoc.update({
      'mute': !isMuted,
    });

    print("Message mute toggled to: ${!isMuted}");
  } catch (e) {
    print("Error toggling message mute: $e");
  }
}


}