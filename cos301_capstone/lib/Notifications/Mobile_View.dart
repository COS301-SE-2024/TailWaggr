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
      color: themeSettings.Background_Colour,
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
                style: TextStyle(fontSize: Subtitle_Text_Size, color: themeSettings.Primary_Colour),
              ),
            ),
            for (int i = 0; i < profileDetails.Notifications.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 25,
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      profileDetails.Notifications[i].getFormattedDate(),
                      style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Text_Colour.withOpacity(0.5)),
                    ),
                  ),
                  Container(
                    // height: 100,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                  if (profileDetails.Notifications[i].Type == "Friend Request")
                                    Text(
                                      "Requested to follow you",
                                      style: TextStyle(
                                        fontSize: Body_Text_Size,
                                        color: themeSettings.Text_Colour.withOpacity(0.5),
                                      ),
                                    ),
                                if (profileDetails.Notifications[i].Type == "Like")
                                  Text(
                                    "Liked your post",
                                    style: TextStyle(
                                      fontSize: Body_Text_Size,
                                      color: themeSettings.Text_Colour.withOpacity(0.5),
                                    ),
                                  ),
                                if (profileDetails.Notifications[i].Type == "Comment")
                                  Text(
                                    "Commented on your post",
                                    style: TextStyle(
                                      fontSize: Body_Text_Size,
                                      color: themeSettings.Text_Colour.withOpacity(0.5),
                                    ),
                                  ),
                                if (profileDetails.Notifications[i].Type == "Following")
                                  Text(
                                    "Started following you",
                                    style: TextStyle(
                                      fontSize: Body_Text_Size,
                                      color: themeSettings.Text_Colour.withOpacity(0.5),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
      
                        SizedBox(height: 10),
    
                        if (profileDetails.Notifications[i].Type == "Friend Request") ...[
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    profileDetails.Notifications[i].Type = "Following";
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(themeSettings.Primary_Colour),
                                ),
                                child: Text(
                                  "Accept",
                                  style: TextStyle(fontSize: Body_Text_Size, color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    profileDetails.Notifications.removeAt(i);
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(ThemeSettings.Card_Colour),
                                  side: WidgetStateProperty.all(BorderSide(color: themeSettings.Primary_Colour, width: 1)),
                                ),
                                child: Text(
                                  "Decline",
                                  style: TextStyle(fontSize: Body_Text_Size, color: ThemeSettings.Text_Colour),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (profileDetails.Notifications[i].Type == "Like" || profileDetails.Notifications[i].Type == "Comment") ...[
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(themeSettings.Primary_Colour),
                            ),
                            child: Text(
                              "View Post",
                              style: TextStyle(fontSize: Body_Text_Size, color: Colors.white),
                            ),
                          ),
                        ],
                        if (profileDetails.Notifications[i].Type == "Following") ...[
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(themeSettings.Primary_Colour),
                            ),
                            child: Text(
                              "Follow Back",
                              style: TextStyle(fontSize: Body_Text_Size, color: Colors.white),
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
