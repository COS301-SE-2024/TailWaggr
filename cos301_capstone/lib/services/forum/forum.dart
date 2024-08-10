import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/services/Notifications/notifications.dart';

class ForumServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  NotificationsServices notif = NotificationsServices();

  /// Creates a new forum in the database.
  Future<DocumentReference<Object?>> createForum({
    String? name, // forum name
    String? userId // userId of forum owner
  }) async {
    try {
      // Get imgUrl
      DocumentSnapshot postDoc = await _db.collection('profile').doc(userId).get();
      if (!postDoc.exists) throw Exception("Post not found");
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      String imgUrl = postData['ImgUrl'] ?? '';

      // Get Time
      DateTime now = DateTime.now();
      DocumentReference ref = await _db.collection('forum').add({
        'CreatedAt': now,
        'ImgUrl': imgUrl,
        'Name': name,
        'UserId': userId
      });
      print('Forum created successfully.');
      return ref;
    } catch (e) {
      print('Error creating forum: $e');
      throw Exception('Failed to create forum.');
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
          forums.add({
            'forumId': doc.id,
            ...forumData,
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
      });

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
}