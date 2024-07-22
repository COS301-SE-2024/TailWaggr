import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:cos301_capstone/services/Notifications/notifications.dart';
import 'package:flutter/material.dart';

class TabletNotifications extends StatefulWidget {
  const TabletNotifications({super.key});

  @override
  State<TabletNotifications> createState() => _TabletNotificationsState();
}

class _TabletNotificationsState extends State<TabletNotifications> {
  List<Map<String, dynamic>> notifications = [];
  bool hasNewNotifications = false;
  bool _isLoading = true;
  final AuthService _authService = AuthService();
  final NotificationsServices _notificationsServices = NotificationsServices();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() async {
    try {
      String? userId = await _authService.getCurrentUserId();

      if (userId != null) {
        // Fetch notifications
        List<Map<String, dynamic>> likes = await _notificationsServices.getLikesNotifications(userId) ?? [];
        List<Map<String, dynamic>> replies = await _notificationsServices.getReplyNotifications(userId) ?? [];
        List<Map<String, dynamic>> events = await _notificationsServices.getEventsNotifications(userId) ?? [];
        Map<String, dynamic>? follow = await _notificationsServices.getFollowNotifications(userId);

        List<Map<String, dynamic>> allNotifications = [...likes, ...replies, ...events];
        if (follow != null) {
          allNotifications.add(follow);
        }

        // Sort notifications by 'CreatedAt' timestamp in descending order
        allNotifications.sort((a, b) {
          Timestamp aTimestamp = a['CreatedAt'];
          Timestamp bTimestamp = b['CreatedAt'];
          return bTimestamp.compareTo(aTimestamp);
        });

        setState(() {
          notifications = allNotifications;
          hasNewNotifications = notifications.any((notification) => !notification['Read']);
          _isLoading = false;
        });

        // Set up onSnapshot to listen for real-time updates
        FirebaseFirestore.instance
            .collection('notifications')
            .where('UserId', isEqualTo: userId)
            .snapshots()
            .listen((snapshot) {
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
        });
      }
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
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Notifications",
                              style: TextStyle(fontSize: subtitleTextSize, color: themeSettings.primaryColor),
                            ),
                            for (var notification in notifications)
                              NotificationCard(
                                notification: notification,
                                formatDate: formatDate,
                                onMarkAsRead: _markAsRead,
                              ),
                          ],
                        ),
                      ),
          ),
        ),
      ],
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

    try {
      DocumentSnapshot forumSnapshot = await FirebaseFirestore.instance.collection('forum').doc(forumId).get();
      DocumentSnapshot messageSnapshot = await FirebaseFirestore.instance
          .collection('forum')
          .doc(forumId)
          .collection('messages')
          .doc(messageId)
          .get();
      DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance.collection('users').doc(messageSnapshot['UserId']).get();

      if (forumSnapshot.exists && messageSnapshot.exists && userProfileSnapshot.exists) {
        Map<String, dynamic> forum = forumSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> message = messageSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> userProfile = userProfileSnapshot.data() as Map<String, dynamic>;

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                forum['Name'] ?? 'Unknown Forum',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Message from: ${userProfile['userName'] ?? 'Unknown User'}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.2), // Highlight color
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.yellow),
                    ),
                    child: Text(message['Content'] ?? 'No content'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Posted on: ${formatDate(message['CreatedAt'])}',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
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
              title: Text('Error'),
              content: Text('Unable to fetch forum details.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
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
            title: Text('Error'),
            content: Text('Unable to fetch forum details.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),)
              ],
          );
          }
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
              title: Text(
                event['Title'] ?? 'Unknown Event',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(event['Description'] ?? 'No description'),
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
                  child: Text('Close'),
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
              title: Text('Error'),
              content: Text('Unable to fetch event details.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
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
            title: Text('Error'),
            content: Text('Unable to fetch event details.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),)
              ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String type = notification['NotificationTypeId'] ?? '';
    String userId = notification['AvatarUrlId'] ?? '';

    return FutureBuilder<String>(
      future: _fetchProfilePicture(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        String profilePictureUrl = snapshot.data ?? profileDetails.profilePicture;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profilePictureUrl),
            ),
            title: Text(notification['Content'] ?? 'No content'),
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
              if (type == 'forum') {
                _showForumDialog(context);
              } else if (type == 'event') {
                _showEventDialog(context);
              }
            },
          ),
        );
      },
    );
  }
}
