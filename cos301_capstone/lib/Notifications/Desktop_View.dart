import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/services/Profile/profile.dart';
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
  Map<String, Map<String, dynamic>> userProfiles = {};
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    String? userId = await _authService.getCurrentUserId();
    List<Map<String, dynamic>> likesNotifications = await NotificationsServices().getLikesNotifications(userId!) ?? [];
    List<Map<String, dynamic>> replyNotifications = await NotificationsServices().getReplyNotifications(userId) ?? [];

    setState(() {
      notifications = [...likesNotifications, ...replyNotifications];
      hasNewNotifications = notifications.isNotEmpty;
    });
  }

  String getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }

  String formatDate(Timestamp timeStamp) {
    DateTime date = timeStamp.toDate();
    String month = getMonthAbbreviation(date.month);
    return "${date.day.toString()} $month ${date.year.toString()}";
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
            child: SingleChildScrollView(
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

  const NotificationCard({Key? key, required this.notification, required this.formatDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  color: const Color.fromARGB(255, 190, 189, 189),
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
                SizedBox(width: 20),
                Text(
                  notification['Content'] ?? '',
                  style: TextStyle(fontSize: bodyTextSize - 2, color: themeSettings.textColor),
                ),
                Spacer(),
                if (notification['NotificationTypeId'] == 1 || notification['NotificationTypeId'] == 3) ...[
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(themeSettings.primaryColor),
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
    );
  }
}
