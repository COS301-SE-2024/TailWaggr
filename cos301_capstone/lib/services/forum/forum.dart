import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/services/Notifications/notifications.dart';

class ForumServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  NotificationsServices notif = NotificationsServices();

  /// Creates a new forum in the database.
  Future<DocumentReference<Object?>> createForum({
    String? name,//forum name
    String? userId//userId of forum owner
  }) async {
    try {

      // Get imgUrl
      DocumentSnapshot postDoc = await _db.collection('profile').doc(userId).get();
      if (!postDoc.exists) throw Exception("Post not found");
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      String imgUrl = postData['ImgUrl']??'';

      //get Time
      DateTime now = DateTime.now();
      DocumentReference Ref = await _db.collection('forum').add({
        'CreatedAt': now,
        'ImgUrl': imgUrl,
        'Name': name,
        'UserId': _db.doc("users/$userId")
      });
      print('Forum created successfully.');
      return Ref;
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
        print(forumsSnapshot);
        Map<String, dynamic>? forumData = doc.data() as Map<String, dynamic>?;
        print(forumData);
        if (forumData != null) {
          forums.add({
            'forumId': doc.id,
            ...forumData,
          });
        }
      }

      return forums.isNotEmpty ? forums : null;
    } catch (e) {
      print('Error fetching forums: $e');
      return null;
    }
  }

  /// Retrieves posts associated with a forum including likes and replies.
  Future<List<Map<String, dynamic>>?> getPosts(String forumId) async {
  try {
    DocumentReference forumRef = _db.doc('forum/$forumId');
    QuerySnapshot postsSnapshot = await _db
        .collection('posts')
        .where('ForumId', isEqualTo: forumRef)
        .get();

    List<Map<String, dynamic>> posts = [];
    for (DocumentSnapshot postDoc in postsSnapshot.docs) {
      Map<String, dynamic>? postData = postDoc.data() as Map<String, dynamic>?;

      if (postData != null) {
        // Fetch user profile details for the post creator
        DocumentReference userRef = postData['UserId'] as DocumentReference;
        DocumentSnapshot userProfileSnapshot = await userRef.get();
        Map<String, dynamic>? userProfile = userProfileSnapshot.data() as Map<String, dynamic>?;

        // Fetch likes for the post
        QuerySnapshot likesSnapshot = await postDoc.reference.collection('likes').get();
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

        // Fetch replies for the post
        QuerySnapshot repliesSnapshot = await postDoc.reference.collection('replies').get();
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

        posts.add({
          'post': postData,
          'creator': userProfile,
          'likes': likes,
          'replies': replies,
        });
      }
    }

    return posts.isNotEmpty ? posts : null;
  } catch (e) {
    print('Error fetching posts: $e');
    return null;
  }
}

  /// Creates a new post in Firestore.
  Future<DocumentReference?> createPost(String forumId, String userId, String content) async {
    try {
      // Create a new post document
      DocumentReference postRef = await _db.collection('posts').add({
        'ForumId': _db.doc('forum/$forumId'),
        'UserId': _db.doc('users/$userId'),
        'Content': content,
        'CreatedAt': Timestamp.now(),
      });

      return postRef;
    } catch (e) {
      print('Error creating post: $e');
      return null;
    }
  }
  /// Likes a post in Firestore.
Future<DocumentReference?> likePost(String postId, String userId) async {
  try {
    // Add a new like document under the post
    DocumentReference likeRef = await _db.collection('posts').doc(postId).collection('likes').add({
      'UserId': _db.doc('users/$userId'),
      'CreatedAt': Timestamp.now(),
    });
    //create Like notification
    notif.createLikeNotification(postId,userId);

    return likeRef;
  } catch (e) {
    print('Error liking post: $e');
    return null;
  }
}
/// Replies to a post in Firestore.
Future<DocumentReference?> replyToPost(String postId, String userId, String content) async {
  try {
    // Add a new reply document under the post
    DocumentReference replyRef = await _db.collection('posts').doc(postId).collection('replies').add({
      'UserId': _db.doc('users/$userId'),
      'Content': content,
      'CreatedAt': Timestamp.now(),
    });
    //create reply notification
    notif.createReplyNotification(postId, userId);

    return replyRef;
  } catch (e) {
    print('Error replying to post: $e');
    return null;
  }
}

}


