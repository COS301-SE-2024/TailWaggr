import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final String Function(DateTime) formatDate;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.formatDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRead = notification['Read'] ?? false;

    return InkWell(
      onTap: () {
        // Add any navigation logic here if needed, or leave it empty.
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
                style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                Container(
                  width: 2,
                  height: 50,
                  color: const Color.fromARGB(255, 190, 189, 189),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: isRead ? const Color.fromARGB(255, 190, 189, 189) : Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 50,
                  color: const Color.fromARGB(255, 190, 189, 189),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width - (415 + 20 + 25 + 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(notification['AvatarUrl'] ?? 'default_image_url'),
                    radius: 30,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      notification['Content'] ?? '',
                     style: TextStyle(fontSize: bodyTextSize - 2, color: themeSettings.textColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  const Spacer(),
                  if (notification['NotificationTypeId'] == 1 || notification['NotificationTypeId'] == 3) ...[
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("View Message"),
                    ),
                  ] else if (notification['NotificationTypeId'] == 5) ...[
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("View Post"),
                    ),
                  ] else if (notification['NotificationTypeId'] == 6) ...[
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("View Comment"),
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
