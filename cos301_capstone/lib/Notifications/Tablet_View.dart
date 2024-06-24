// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class TabletNotifications extends StatefulWidget {
  const TabletNotifications({super.key});

  @override
  State<TabletNotifications> createState() => _TabletNotificationsState();
}

class _TabletNotificationsState extends State<TabletNotifications> {
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
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(fontSize: subtitleTextSize, color: themeSettings.primaryColor),
                  ),
                  for (int i = 0; i < profileDetails.notifications.length; i++)
                    SizedBox(
                      height: 150,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 2,
                                height: 62.5,
                                color: i == 0 ? Colors.transparent : Color.fromARGB(255, 190, 189, 189),
                              ),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 190, 189, 189),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ThemeSettings.primaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 62.5,
                                color: i == profileDetails.notifications.length - 1 ? Colors.transparent : Color.fromARGB(255, 190, 189, 189),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                                child: Text(
                                  profileDetails.notifications[i].getFormattedDate(),
                                  style: TextStyle(fontSize: bodyTextSize, color: themeSettings.textColor.withOpacity(0.5)),
                                ),
                              ),
                              Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width - (280 + 20 + 25 + 20),
                                padding: EdgeInsets.all(20),
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
                                child: Row(
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
                                          style: TextStyle(fontSize: bodyTextSize, color: themeSettings.textColor),
                                        ),
                                        if (profileDetails.notifications[i].type == "Friend Request")
                                          Text(
                                            "Requested to follow you",
                                            style: TextStyle(fontSize: bodyTextSize, color: themeSettings.textColor.withOpacity(0.5)),
                                          ),
                                        if (profileDetails.notifications[i].type == "Like")
                                          Text(
                                            "Liked your post",
                                            style: TextStyle(fontSize: bodyTextSize, color: themeSettings.textColor.withOpacity(0.5)),
                                          ),
                                        if (profileDetails.notifications[i].type == "Comment")
                                          Text(
                                            "Commented on your post",
                                            style: TextStyle(fontSize: bodyTextSize, color: themeSettings.textColor.withOpacity(0.5)),
                                          ),
                                        if (profileDetails.notifications[i].type == "Following")
                                          Text(
                                            "Started following you",
                                            style: TextStyle(fontSize: bodyTextSize, color: themeSettings.textColor.withOpacity(0.5)),
                                          ),
                                      ],
                                    ),
                                    Spacer(),
                                    if (profileDetails.notifications[i].type == "Friend Request") ...[
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            profileDetails.notifications[i].type = "Following";
                                          });
                                        },
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(fontSize: subBodyTextSize, color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            profileDetails.notifications.removeAt(i);
                                          });
                                        },
                                        child: Text(
                                          "Decline",
                                          style: TextStyle(fontSize: subBodyTextSize, color: ThemeSettings.textColor),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(ThemeSettings.cardColor),
                                          side: WidgetStateProperty.all(BorderSide(color: themeSettings.primaryColor, width: 1)),
                                        ),
                                      ),
                                    ],
                                    if (profileDetails.notifications[i].type == "Like" || profileDetails.notifications[i].type == "Comment") ...[
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "View Post",
                                          style: TextStyle(fontSize: subBodyTextSize, color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                                        ),
                                      ),
                                    ],
                                    if (profileDetails.notifications[i].type == "Following") ...[
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Follow Back",
                                          style: TextStyle(fontSize: subBodyTextSize, color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
