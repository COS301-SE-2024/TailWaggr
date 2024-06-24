// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class DesktopForums extends StatefulWidget {
  const DesktopForums({super.key});

  @override
  State<DesktopForums> createState() => _DesktopForumsState();
}

Forum currentForum = forumList.forums[0];
List searchedForums = forumList.forums;
String searchTerm = "";

class _DesktopForumsState extends State<DesktopForums> {
  TextEditingController forumSearchController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeSettings.backgroundColor,
      child: Row(
        children: [
          DesktopNavbar(),
          Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.55,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Forums",
                    style: TextStyle(
                        fontSize: subtitleTextSize,
                        color: themeSettings.primaryColor),
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: forumSearchController,
                      onChanged: (value) {
                        setState(() {
                          searchTerm = value;
                          searchedForums = forumList.forums
                              .where(
                                  (forum) => forum.title.contains(searchTerm))
                              .toList();
                        });
                        // Execute any other code here
                        print('User typed: $value');
                      },
                      decoration: InputDecoration(
                        hintText: "Search for a forum",
                        hintStyle: TextStyle(
                            color: themeSettings.textColor.withOpacity(0.5)),
                        prefixIcon: Icon(Icons.search),
                      ),
                      style: TextStyle(
                          color: themeSettings.textColor), // Add this line
                    ),
                  ),
                  if (searchTerm != "")
                    for (int i = 0; i < searchedForums.length; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            print("A");
                          });
                        },
                        child: SizedBox(
                          height: 125,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width:
                                    MediaQuery.of(context).size.width * 0.525,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: themeSettings.cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: themeSettings
                                        .primaryColor, // Border color
                                    width: 2.0, // Border width
                                  ),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: themeSettings.textColor.withOpacity(0.2),
                                  //     blurRadius: 10,
                                  //   ),
                                  // ],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      searchedForums[i].title,
                                      style: TextStyle(
                                          fontSize: bodyTextSize,
                                          color: themeSettings.textColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  if (searchTerm == "")
                    for (int i = 0; i < forumList.forums.length; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            print("A");
                          });
                        },
                        child: SizedBox(
                          height: 125,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width:
                                    MediaQuery.of(context).size.width * 0.525,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: themeSettings.cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: themeSettings
                                        .primaryColor, // Border color
                                    width: 2.0, // Border width
                                  ),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: themeSettings.textColor.withOpacity(0.2),
                                  //     blurRadius: 10,
                                  //   ),
                                  // ],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      forumList.forums[i].title,
                                      style: TextStyle(
                                          fontSize: bodyTextSize,
                                          color: themeSettings.textColor),
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
          Container(
            width: MediaQuery.of(context).size.width * 0.0015,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.primaryColor,
            ),
          ),
          Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(),
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        currentForum.title,
                        style: TextStyle(
                            fontSize: subtitleTextSize,
                            color: themeSettings.primaryColor),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          currentForum.content,
                          style: TextStyle(
                              fontSize: bodyTextSize,
                              color: themeSettings.textColor),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.0015,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: themeSettings.primaryColor,
                        ),
                      ),
                      SizedBox(height: 40),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(children: [
                              for (var message in currentForum.messages)
                                Column(children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: themeSettings.cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: themeSettings
                                              .primaryColor, // Border color
                                          width: 2.0, // Border width
                                        ),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: themeSettings.textColor.withOpacity(0.2),
                                        //     blurRadius: 10,
                                        //   ),
                                        // ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message["sender"],
                                            style: TextStyle(
                                                fontSize: bodyTextSize,
                                                color: themeSettings.textColor),
                                          ),
                                          Text(
                                            message["content"],
                                            style: TextStyle(
                                                fontSize: subBodyTextSize,
                                                color: themeSettings.textColor),
                                          ),
                                        ],
                                      )),
                                  SizedBox(height: 15),
                                ]),
                            ]),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: messageController,
                        onSubmitted: (value) {
                          setState(() {
                                                      Map<String, String> newMessage = {
                            "sender": profileDetails.name,
                            "content": value,
                          };
                          messageController.clear();
                          currentForum.messages.add(newMessage);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Type a new message',
                          border: OutlineInputBorder(),
                        ),
                      )
                    ])),
          )
        ],
      ),
    );
  }
}
