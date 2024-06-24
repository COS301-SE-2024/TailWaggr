// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class DesktopForums extends StatefulWidget {
  const DesktopForums({super.key});

  @override
  State<DesktopForums> createState() => _DesktopForumsState();
}

class _DesktopForumsState extends State<DesktopForums> {
  TextEditingController forumSearchController = TextEditingController();
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
                // mainAxisAlignment: MainAxisAlignment.start,
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
                  for (int i = 0; i < profileDetails.notifications.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          print("AAAAA");
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
                              width: MediaQuery.of(context).size.width * 0.525,
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
                                    profileDetails.notifications[i].fromUser,
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
                        "Title",
                        style: TextStyle(
                            fontSize: subtitleTextSize,
                            color: themeSettings.primaryColor),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Lorum IpsumodeeznutsLorum IpsumodeeznutsLorum IpsumodeeznutsLorum IpsumodeeznutsLorum IpsumodeeznutsLorum Ipsumodeeznuts',
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
                              for (int i = 0; i < 7; i++)
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
                                    child: Text(
                                      'This is an message.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAaaaaaaaaaaa',
                                      style: TextStyle(
                                          fontSize: subBodyTextSize,
                                          color: themeSettings.textColor),
                                    )),
                            ]),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
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
