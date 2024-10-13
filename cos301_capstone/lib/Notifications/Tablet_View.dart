import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Tablet_View.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/services/Location/location_service.dart';
// import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:cos301_capstone/services/Notifications/notifications.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:cos301_capstone/services/forum/forum.dart';
import 'package:flutter/material.dart';

class TabletNotifications extends StatefulWidget {
  const TabletNotifications({super.key});

  @override
  State<TabletNotifications> createState() => _TabletNotificationsState();
}

class _TabletNotificationsState extends State<TabletNotifications> {
  List<Map<String, dynamic>> notifications = [];
  final ProfileService profileService = ProfileService();
  bool hasNewNotifications = false;
  bool _isLoading = true;
  // final AuthService _authService = AuthService();
  final NotificationsServices _notificationsServices = NotificationsServices();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() async {
    try {
      // String? userId = await _authService.getCurrentUserId();
      String? userId = profileDetails.userID;

      // Fetch notifications
      // List<Map<String, dynamic>> likes = await _notificationsServices.getLikesNotifications(userId) ?? [];
      // List<Map<String, dynamic>> replies = await _notificationsServices.getReplyNotifications(userId) ?? [];
      // //List<Map<String, dynamic>> events = await _notificationsServices.getEventsNotifications(userId) ?? [];
      // List<Map<String, dynamic>> likePosts = await _notificationsServices.getLikePostNotifications(userId) ?? [];
      // List<Map<String, dynamic>> comments = await _notificationsServices.getCommentPostNotifications(userId) ?? [];
      // Map<String, dynamic>? follow = await _notificationsServices.getFollowNotifications(userId);

      final db = FirebaseFirestore.instance;

      final likes = await db
          .collection('notifications')
          .where('UserId', isEqualTo: userId)
          // .orderBy('CreatedAt', descending: true)
          .get();

      for (var like in likes.docs) {
        notifications.add(like.data());
        // print(like.data());
      }

      notifications.sort((a, b) {
        Timestamp aTimestamp = a['CreatedAt'];
        Timestamp bTimestamp = b['CreatedAt'];
        return bTimestamp.compareTo(aTimestamp);
      });

      setState(() {
        _isLoading = false;
      });

      // List<Map<String, dynamic>> events = [];
      // List<Map<String, dynamic>> allNotifications = [...likes, ...replies, ...likePosts, ...comments, ...events];
      // if (follow != null) {
      //   allNotifications.add(follow);
      // }
      //print(allNotifications);

      // Sort notifications by 'CreatedAt' timestamp in descending order
      // allNotifications.sort((a, b) {
      //   Timestamp aTimestamp = a['CreatedAt'];
      //   Timestamp bTimestamp = b['CreatedAt'];
      //   return bTimestamp.compareTo(aTimestamp);
      // });

      // setState(() {
      //   // notifications = allNotifications;
      //   hasNewNotifications = notifications.any((notification) => !notification['Read']);
      //   _isLoading = false;
      // });

      // Set up onSnapshot to listen for real-time updates
      FirebaseFirestore.instance.collection('notifications').where('UserId', isEqualTo: userId).snapshots().listen(
        (snapshot) {
          List<Map<String, dynamic>> newNotifications = snapshot.docs.map((doc) {
            return {
              'id': doc.id,
              ...doc.data(),
            };
          }).toList();

          // Sort new notifications by 'CreatedAt' timestamp in descending order
          newNotifications.sort((a, b) {
            Timestamp aTimestamp = a['CreatedAt'];
            Timestamp bTimestamp = b['CreatedAt'];
            return bTimestamp.compareTo(aTimestamp);
          });

          setState(() {
            notifications = newNotifications;
            hasNewNotifications = notifications.any((notification) => !notification['Read']);
          });
        },
      );
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  String getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  String formatDate(Timestamp timeStamp) {
    DateTime date = timeStamp.toDate();
    String month = getMonthAbbreviation(date.month);
    return "${date.day.toString()} $month ${date.year.toString()}";
  }

  void _markAsRead(String notificationId) {
    _notificationsServices.markAsRead(notificationId);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DesktopNavbar(),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: themeSettings.backgroundColor,
            padding: EdgeInsets.all(20),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : notifications.isEmpty
                    ? Center(
                        child: Text(
                          "No notifications",
                          style: TextStyle(fontSize: subtitleTextSize, color: themeSettings.primaryColor),
                        ),
                      )
                    : Column(
                        // Constrained by parent height
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notifications",
                            style: TextStyle(fontSize: subtitleTextSize - 2, color: themeSettings.primaryColor),
                          ),
                          Expanded(
                            // Ensure TabBarView gets a constrained height
                            child: DefaultTabController(
                              initialIndex: 0,
                              length: 2,
                              child: Column(
                                children: [
                                  TabBar(
                                    labelColor: themeSettings.secondaryColor,
                                    indicatorColor: themeSettings.secondaryColor,
                                    dividerColor: Colors.transparent,
                                    tabs: [
                                      Tab(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.notifications),
                                            SizedBox(width: 10),
                                            Text("Notifications"),
                                          ],
                                        ),
                                      ),
                                      Tab(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.add),
                                            SizedBox(width: 10),
                                            Text("Requests"),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  Expanded(
                                    // Constrain the TabBarView's height
                                    child: TabBarView(
                                      children: [
                                        // Wrap notifications list in a scrollable view
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              for (var notification in notifications)
                                                NotificationCard(
                                                  notification: notification,
                                                  formatDate: formatDate,
                                                  onMarkAsRead: _markAsRead,
                                                ),
                                            ],
                                          ),
                                        ),
                                        // Second tab content
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [

                                              if (profileDetails.requests.isEmpty)
                                                Center(
                                                  child: Text(
                                                    "No friend requests",
                                                    style: TextStyle(fontSize: subtitleTextSize - 2, color: themeSettings.primaryColor),
                                                  ),
                                                ),

                                              for (var request in profileDetails.requests.entries)
                                                RequestCard(
                                                  request: request,
                                                  profileService: profileService,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}

class RequestCard extends StatefulWidget {
  const RequestCard({super.key, required this.request, required this.profileService});

  final MapEntry<String, dynamic> request;
  final ProfileService profileService;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool loaded = false;

  late User user;

  @override
  void initState() {
    super.initState();

    // print('Request: ${widget.request.key}');
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    try {
      print('Request: ${widget.request.key}');

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.request.key).get();
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          user = User(
            id: widget.request.key,
            name: userData['name'],
            email: userData['email'],
            profileUrl: userData['profilePictureUrl'],
            userType: userData['userType'],
            location: userData['address'],
          );

          setState(() {
            loaded = true;
          });
        }
      }
    } catch (e) {
      print("Error fetching profile picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeSettings.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: !loaded
          ? CircularProgressIndicator()
          : Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.profileUrl),
                  radius: 30,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(fontSize: bodyTextSize - 2, color: themeSettings.textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Has requested to be your friend",
                      style: TextStyle(fontSize: bodyTextSize - 4, color: themeSettings.textColor),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        bool success = await widget.profileService.acceptFriendRequest(profileDetails.userID, user.id);

                        if (success) {
                          setState(() {
                            profileDetails.requests.remove(user.id);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Friend request accepted'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('An error occurred while accepting the friend request'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                      ),
                      child: Text(
                        "Accept",
                        style: TextStyle(fontSize: subBodyTextSize - 2, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        bool success = await widget.profileService.declineFriendRequest(profileDetails.userID, user.id);

                        if (success) {
                          setState(() {
                            profileDetails.requests.remove(user.id);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Friend request declined'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('An error occurred while declining the friend request'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                      ),
                      child: Text(
                        "Decline",
                        style: TextStyle(fontSize: subBodyTextSize - 2, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}


class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final String Function(Timestamp) formatDate;
  final void Function(String) onMarkAsRead;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.formatDate,
    required this.onMarkAsRead,
  }) : super(key: key);

  Future<String> _fetchUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('name')) {
          return userData['name'];
        }
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }
    return 'Unknown User';
  }

  Future<int> getLikes(String forumId, String messageId) async {
    return ForumServices().getLikesCount(forumId, messageId);
  }

  Future<int> getReplies(String forumId, String messageId) async {
    return ForumServices().getRepliesCount(forumId, messageId);
  }

  Future<String> _fetchProfilePicture(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('profilePictureUrl')) {
          return userData['profilePictureUrl'] ?? '';
        }
      }
    } catch (e) {
      print("Error fetching profile picture: $e");
    }
    return profileDetails.profilePicture; // Return default profile picture if user profile picture is not found
  }

  void _showForumDialog(BuildContext context) async {
    String referenceId = notification['ReferenceId'];
    List<String> ids = referenceId.split('/');
    String forumId = ids[0];
    String messageId = ids.length > 1 ? ids[1] : '';
    Map<String, dynamic> comment = {};
    String commentId = '';

    try {
      DocumentSnapshot forumSnapshot = await FirebaseFirestore.instance.collection('forum').doc(forumId).get();
      DocumentSnapshot messageSnapshot = await FirebaseFirestore.instance.collection('forum').doc(forumId).collection('messages').doc(messageId).get();
      DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance.collection('users').doc(messageSnapshot['UserId']).get();

      if (notification['NotificationTypeId'] == 3) {
        commentId = ids.length > 2 ? ids[2] : '';
        if (commentId.isNotEmpty) {
          DocumentSnapshot commentSnapshot = await FirebaseFirestore.instance.collection('forum').doc(forumId).collection('messages').doc(messageId).collection('replies').doc(commentId).get();
          comment = commentSnapshot.data() as Map<String, dynamic>? ?? {};
        }
      }

      if (forumSnapshot.exists && messageSnapshot.exists && userProfileSnapshot.exists) {
        Map<String, dynamic> forum = forumSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> message = messageSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> userProfile = userProfileSnapshot.data() as Map<String, dynamic>;
        final String profilePicture = await _fetchProfilePicture(notification['AvatarUrlId']);
        final int likes = await getLikes(forumId, messageId);
        final int comments = await getReplies(forumId, messageId);
        final String name = await _fetchUserName(notification['AvatarUrlId']);

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: themeSettings.cardColor,
              title: Text(
                'Message from Forum: ${forum['Name'] ?? 'Unknown Forum'}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: themeSettings.textColor),
              ),
              content: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7, // Constrain the height
                    maxWidth: MediaQuery.of(context).size.width * 0.9, // Constrain the width
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User Info Section
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(profilePicture),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProfile['name'] ?? 'Unknown User',
                                style: TextStyle(
                                  color: themeSettings.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Posted on: ${formatDate(message['CreatedAt'])}',
                                style: TextStyle(
                                  color: themeSettings.textColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Message Content Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: themeSettings.primaryColor,
                            width: 2, // Increased border thickness
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['Content'] ?? 'No content',
                              style: TextStyle(
                                color: themeSettings.textColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pets_outlined,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 4),
                                    Text('$likes', style: TextStyle(color: themeSettings.textColor)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.comment,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 4),
                                    Text('$comments', style: TextStyle(color: themeSettings.textColor)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (comment.isNotEmpty) ...[
                        SizedBox(height: 16),
                        Divider(),
                        Text(
                          'Comment:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: themeSettings.textColor),
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(profilePicture),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: themeSettings.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    comment['Content'] ?? 'No content',
                                    style: TextStyle(
                                      color: themeSettings.textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Commented on: ${formatDate(comment['CreatedAt'])}',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: TextStyle(color: themeSettings.primaryColor)),
                ),
              ],
            );
          },
        );
      } else {
        // Handle the case where any of the documents do not exist
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: themeSettings.cardColor,
              title: Text('Error', style: TextStyle(color: themeSettings.textColor)),
              content: Text('Unable to fetch forum details.', style: TextStyle(color: themeSettings.textColor)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: TextStyle(color: themeSettings.primaryColor)),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error fetching forum details: $e");
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: themeSettings.cardColor,
            title: Text('Error', style: TextStyle(color: themeSettings.textColor)),
            content: Text('An error occurred while fetching forum details.', style: TextStyle(color: themeSettings.textColor)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: TextStyle(color: themeSettings.primaryColor)),
              ),
            ],
          );
        },
      );
    }
  }

  void _showPostDialog(BuildContext context) async {
    try {
      // Fetch the notification type to distinguish between types
      int notificationType = notification['NotificationTypeId'];
      String referenceId = notification['ReferenceId'];

      // Initialize variables to hold post and user profile data
      Map<String, dynamic> post = {};
      Map<String, dynamic> comment = {};

      // Fetch post data
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance.collection('posts').doc(referenceId.split('/')[0]).get();
      if (postSnapshot.exists) {
        post = postSnapshot.data() as Map<String, dynamic>;

        // If the notification is of type 6, fetch the comment data
        if (notificationType == 6) {
          String postId = referenceId.split('/')[0];
          String commentId = referenceId.split('/')[1];
          DocumentSnapshot commentSnapshot = await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(commentId).get();
          if (commentSnapshot.exists) {
            comment = commentSnapshot.data() as Map<String, dynamic>;
          } else {
            throw Exception('Comment not found');
          }
        }
        //fetch user name and profile picture
        final String name = await _fetchUserName(notification['AvatarUrlId']);
        final String profilePicture = await _fetchProfilePicture(notification['AvatarUrlId']);

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: themeSettings.cardColor,
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Post(postDetails: post),
                    if (notificationType == 6 && comment.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Divider(),
                      Text(
                        'Comment:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: themeSettings.textColor),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(profilePicture),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            // Use Expanded here
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: themeSettings.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  comment['comment'] ?? 'No content',
                                  style: TextStyle(
                                    color: themeSettings.textColor.withOpacity(0.7),
                                  ),
                                  maxLines: null, // Allow text to wrap
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Commented on: ${formatDate(comment['commentedAt'])}',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: TextStyle(color: themeSettings.primaryColor)),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      print("Error fetching post details: $e");
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: themeSettings.cardColor,
            title: Text('Error', style: TextStyle(color: themeSettings.textColor)),
            content: Text('An error occurred while fetching post details.', style: TextStyle(color: themeSettings.textColor)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: TextStyle(color: themeSettings.primaryColor)),
              ),
            ],
          );
        },
      );
    }
  }

  void _showEventDialog(BuildContext context) async {
    String referenceId = notification['ReferenceId'];

    try {
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance.collection('events').doc(referenceId).get();

      if (eventSnapshot.exists) {
        Map<String, dynamic> event = eventSnapshot.data() as Map<String, dynamic>;

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: themeSettings.cardColor,
              title: Text(
                event['Title'] ?? 'Unknown Event',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: themeSettings.textColor),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: themeSettings.textColor),
                  ),
                  SizedBox(height: 8),
                  Text(event['Description'] ?? 'No description', style: TextStyle(color: themeSettings.textColor)),
                  SizedBox(height: 16),
                  Text(
                    'Date: ${formatDate(event['EventDate'])}',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: TextStyle(color: themeSettings.primaryColor)),
                ),
              ],
            );
          },
        );
      } else {
        // Handle the case where the event document does not exist
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: themeSettings.cardColor,
              title: Text('Error', style: TextStyle(color: themeSettings.textColor)),
              content: Text('Unable to fetch event details.', style: TextStyle(color: themeSettings.textColor)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: TextStyle(color: themeSettings.primaryColor)),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error fetching event details: $e");
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: themeSettings.cardColor,
            title: Text('Error', style: TextStyle(color: themeSettings.textColor)),
            content: Text('Unable to fetch event details.', style: TextStyle(color: themeSettings.textColor)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: TextStyle(color: themeSettings.primaryColor)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int type = notification['NotificationTypeId'] ?? '';
    String userId = notification['AvatarUrlId'] ?? '';

    return FutureBuilder<String>(
      future: _fetchProfilePicture(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        String profilePictureUrl = snapshot.data ?? profileDetails.profilePicture;

        return Card(
          color: themeSettings.cardColor,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profilePictureUrl),
            ),
            title: Text(notification['Content'] ?? 'No content', style: TextStyle(color: themeSettings.textColor)),
            subtitle: Text(formatDate(notification['CreatedAt'])),
            trailing: IconButton(
              icon: Icon(notification['Read'] ? Icons.check_circle : Icons.mark_email_unread),
              onPressed: () {
                if (!notification['Read']) {
                  onMarkAsRead(notification['id']);
                }
              },
            ),
            onTap: () {
              if (type == 1 || type == 3) {
                _showForumDialog(context);
              } else if (type == 6 || type == 5) {
                _showPostDialog(context);
              }
            },
          ),
        );
      },
    );
  }
}
