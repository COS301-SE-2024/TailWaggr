import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:cos301_capstone/services/Notifications/notifications.dart';

class DesktopNotifications extends StatefulWidget {
  const DesktopNotifications({super.key});

  @override
  State<DesktopNotifications> createState() => _DesktopNotificationsState();
}

class _DesktopNotificationsState extends State<DesktopNotifications> {
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
                          style: TextStyle(fontSize: subtitleTextSize - 2, color: themeSettings.primaryColor),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Notifications",
                              style: TextStyle(fontSize: subtitleTextSize - 2, color: themeSettings.primaryColor),
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
          return userData['profilePictureUrl'];
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
            content: Text('An error occurred while fetching forum details.'),
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
    bool isRead = notification['Read'] ?? false;
    String avatarUserId = notification['AvatarUrlId'] ?? '';

    return InkWell(
      onTap: () {
        if (!isRead) {
          onMarkAsRead(notification['id']);
        }
        _showForumDialog(context);
      },
      child: SizedBox(
        height: 125,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 115,
              child: Text(
                notification['CreatedAt'] != null ? formatDate(notification['CreatedAt']) : '',
                style: TextStyle(fontSize: bodyTextSize - 2, color: themeSettings.textColor.withOpacity(0.5)),
              ),
            ),
            SizedBox(width: 20),
            Column(
              children: [
                Container(
                  width: 2,
                  height: 50,
                  color: Color.fromARGB(255, 190, 189, 189),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: isRead ? Color.fromARGB(255, 190, 189, 189) : themeSettings.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: themeSettings.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 50,
                  color: Color.fromARGB(255, 190, 189, 189),
                ),
              ],
            ),
            SizedBox(width: 20),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width - (415 + 20 + 25 + 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeSettings.cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  FutureBuilder<String>(
                    future: _fetchProfilePicture(avatarUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(profileDetails.profilePicture), // Default image while loading
                          radius: 30,
                        );
                      } else if (snapshot.hasError) {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(profileDetails.profilePicture), // Default image on error
                          radius: 30,
                        );
                      } else {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data ?? profileDetails.profilePicture),
                          radius: 30,
                        );
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  Text(
                    notification['Content'] ?? '',
                    style: TextStyle(fontSize: bodyTextSize - 2, color: themeSettings.textColor),
                  ),
                  Spacer(),
                  if (notification['NotificationTypeId'] == 1 || notification['NotificationTypeId'] == 3) ...[
                    ElevatedButton(
                      onPressed: () {
                        _showForumDialog(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                      ),
                      child: Text(
                        "View Post",
                        style: TextStyle(fontSize: subBodyTextSize - 2, color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
