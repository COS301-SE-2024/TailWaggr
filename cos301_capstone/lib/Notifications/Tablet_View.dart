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
            color: themeSettings.Background_Colour,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(fontSize: Subtitle_Text_Size, color: themeSettings.Primary_Colour),
                  ),
                  for (int i = 0; i < profileDetails.Notifications.length; i++)
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
                                color: i == 0 ? Colors.transparent : Colors.black.withOpacity(0.5),
                              ),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 190, 189, 189),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ThemeSettings.Primary_Colour,
                                    width: 2,
                                  ),
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 62.5,
                                color: i == profileDetails.Notifications.length - 1 ? Colors.transparent : Colors.black.withOpacity(0.5),
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
                                  profileDetails.Notifications[i].getFormattedDate(),
                                  style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Text_Colour.withOpacity(0.5)),
                                ),
                              ),
                              Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width - (280 + 20 + 25 + 20),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: themeSettings.Card_Colour,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeSettings.Text_Colour.withOpacity(0.2),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profileDetails.Notifications[i].From_User,
                                          style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Text_Colour),
                                        ),
                                        if (profileDetails.Notifications[i].Type == "Friend Request")
                                          Text(
                                            " has requested to follow you",
                                            style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Text_Colour.withOpacity(0.5)),
                                          ),
                                        if (profileDetails.Notifications[i].Type == "Like")
                                          Text(
                                            " has liked your post",
                                            style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Text_Colour.withOpacity(0.5)),
                                          ),
                                        if (profileDetails.Notifications[i].Type == "Comment")
                                          Text(
                                            " has commented on your post",
                                            style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Text_Colour.withOpacity(0.5)),
                                          ),
                                        if (profileDetails.Notifications[i].Type == "Following")
                                          Text(
                                            " started following you",
                                            style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Text_Colour.withOpacity(0.5)),
                                          ),
                                      ],
                                    ),
                                    Spacer(),
                                    if (profileDetails.Notifications[i].Type == "Friend Request") ...[
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            profileDetails.Notifications[i].Type = "Following";
                                          });
                                        },
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(fontSize: Body_Text_Size, color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(themeSettings.Primary_Colour),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            profileDetails.Notifications.removeAt(i);
                                          });
                                        },
                                        child: Text(
                                          "Decline",
                                          style: TextStyle(fontSize: Body_Text_Size, color: ThemeSettings.Text_Colour),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(ThemeSettings.Card_Colour),
                                          side: WidgetStateProperty.all(BorderSide(color: Colors.purple)),
                                        ),
                                      ),
                                    ],
                                    if (profileDetails.Notifications[i].Type == "Like" || profileDetails.Notifications[i].Type == "Comment") ...[
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "View Post",
                                          style: TextStyle(fontSize: Body_Text_Size, color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(themeSettings.Primary_Colour),
                                        ),
                                      ),
                                    ],
                                    if (profileDetails.Notifications[i].Type == "Following") ...[
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Follow Back",
                                          style: TextStyle(fontSize: Body_Text_Size, color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(themeSettings.Primary_Colour),
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
