import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:cos301_capstone/services/Notifications/notifications.dart';
import 'package:flutter/material.dart';

class MobileNotifications extends StatefulWidget {
  const MobileNotifications({super.key});

  @override
  State<MobileNotifications> createState() => _MobileNotificationsState();
}

class _MobileNotificationsState extends State<MobileNotifications> {
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
        List<Map<String, dynamic>> likes = await _notificationsServices.getLikesNotifications(userId) ?? [];
        List<Map<String, dynamic>> replies = await _notificationsServices.getReplyNotifications(userId) ?? [];
        //List<Map<String, dynamic>> events = await _notificationsServices.getEventsNotifications(userId) ?? [];
        Map<String, dynamic>? follow = await _notificationsServices.getFollowNotifications(userId);
        List<Map<String, dynamic>> events = [];
        List<Map<String, dynamic>> allNotifications = [...likes, ...replies, ...events];
        if (follow != null) {
          allNotifications.add(follow);
        }

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
    return Container(
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
                      for (var notification in notifications)
                        NotificationCard(
                          notification: notification,
                          formatDate: formatDate,
                          onMarkAsRead: _markAsRead,
                        ),
                    ],
                  ),
                ),
    );
  }
}

class NotificationCard extends StatelessWidget{
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
   /* try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('profilePictureUrl')) {
          return userData['profilePictureUrl'] ?? '';
        }
      }
    } catch (e) {
      print("Error fetching profile picture: $e");
    }*/
    return profileDetails.profilePicture;
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
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
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
                child: Text('Close'),
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
              title: Text(
                event['Name'] ?? 'Unknown Event',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event['Description'] ?? 'No description available',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Event Date: ${formatDate(event['Date'])}',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Location: ${event['Location'] ?? 'No location specified'}',
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
    int notificationType = notification['NotificationTypeId'];
    String content = notification['Content'] ?? '';
    String referenceId = notification['ReferenceId'] ?? '';
    Timestamp createdAt = notification['CreatedAt'];
    String formattedDate = formatDate(createdAt);
    String userId = notification['UserId'] ?? '';
    bool read = notification['Read'] ?? false;

    return FutureBuilder<String>(
      future: _fetchProfilePicture(userId),
      builder: (context, snapshot) {
        String profilePictureUrl = snapshot.data ?? profileDetails.profilePicture;

        return Card(
          color: read ? Colors.grey.shade200 : themeSettings.secondaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profilePictureUrl),
              radius: 20,
            ),
            title: Text(
              content,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: themeSettings.primaryColor),
            ),
            subtitle: Text(formattedDate),
            trailing: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                onMarkAsRead(notification['id']);
              },
            ),
            onTap: () {
              if (notificationType == 1 || notificationType == 3) {
                _showForumDialog(context);
              } else if (notificationType == 4) {
                _showEventDialog(context);
              } else {
                // Handle other notification types
              }
            },
          ),
        );
      },
    );
  }
}
