// ignore_for_file: prefer_const_constructors
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/material.dart';

class MobileNotifications extends StatefulWidget {
  const MobileNotifications({super.key});

  @override
  State<MobileNotifications> createState() => _MobileNotificationsState();
}

class _MobileNotificationsState extends State<MobileNotifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: themeSettings.backgroundColor,
      // padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "Notifications",
                style: TextStyle(fontSize: subtitleTextSize, color: themeSettings.primaryColor),
              ),
            ),
            for (int i = 0; i < profileDetails.notifications.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      profileDetails.notifications[i].getFormattedDate(),
                      style: TextStyle(fontSize: textSize, color: themeSettings.textColor.withOpacity(0.5)),
                    ),
                  ),
                  Container(
                    // height: 100,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 2),
                    decoration: BoxDecoration(
                      color: themeSettings.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: themeSettings.textColor.withOpacity(0.2),
                      //     blurRadius: 10,
                      //   ),
                      // ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // CircleAvatar(
                            //   radius: 30,
                            // ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileDetails.notifications[i].fromUser,
                                  style: TextStyle(fontSize: subBodyTextSize, color: themeSettings.textColor),
                                ),
                                if (profileDetails.notifications[i].type == "Friend Request")
                                  if (profileDetails.notifications[i].type == "Friend Request")
                                    Text(
                                      "Requested to follow you",
                                      style: TextStyle(
                                        fontSize: textSize,
                                        color: themeSettings.textColor.withOpacity(0.5),
                                      ),
                                    ),
                                if (profileDetails.notifications[i].type == "Like")
                                  Text(
                                    "Liked your post",
                                    style: TextStyle(
                                      fontSize: textSize,
                                      color: themeSettings.textColor.withOpacity(0.5),
                                    ),
                                  ),
                                if (profileDetails.notifications[i].type == "Comment")
                                  Text(
                                    "Commented on your post",
                                    style: TextStyle(
                                      fontSize: textSize,
                                      color: themeSettings.textColor.withOpacity(0.5),
                                    ),
                                  ),
                                if (profileDetails.notifications[i].type == "Following")
                                  Text(
                                    "Started following you",
                                    style: TextStyle(
                                      fontSize: textSize,
                                      color: themeSettings.textColor.withOpacity(0.5),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
      
                        SizedBox(height: 10),
    
                        if (profileDetails.notifications[i].type == "Friend Request") ...[
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    profileDetails.notifications[i].type = "Following";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                                ),
                                child: Text(
                                  "Accept",
                                  style: TextStyle(fontSize: textSize, color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    profileDetails.notifications.removeAt(i);
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(ThemeSettings.cardColor),
                                  side: WidgetStateProperty.all(BorderSide(color: themeSettings.primaryColor, width: 1)),
                                ),
                                child: Text(
                                  "Decline",
                                  style: TextStyle(fontSize: textSize, color: ThemeSettings.textColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (profileDetails.notifications[i].type == "Like" || profileDetails.notifications[i].type == "Comment") ...[
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                            ),
                            child: Text(
                              "View Post",
                              style: TextStyle(fontSize: textSize, color: Colors.white),
                            ),
                          ),
                        ],
                        if (profileDetails.notifications[i].type == "Following") ...[
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                            ),
                            child: Text(
                              "Follow Back",
                              style: TextStyle(fontSize: textSize, color: Colors.white),
                            ),
                          ),
                        ],
                        // Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
