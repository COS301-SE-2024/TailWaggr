// ignore_for_file: prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/Navbar/Navbar.dart';
import 'package:cos301_capstone/User_Profile/User_Profile.dart';
import 'package:flutter/material.dart';

class SearchUsersMobile extends StatefulWidget {
  const SearchUsersMobile({super.key});

  @override
  State<SearchUsersMobile> createState() => _SearchUsersMobileState();
}

class _SearchUsersMobileState extends State<SearchUsersMobile> {
  Color containerColor = Colors.transparent;
  Color searchColor = Colors.transparent;
  List<String> users = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => User_Profile()),
            );
          });
        }

        return Scaffold(
          drawer: NavbarDrawer(),
          appBar: AppBar(
            backgroundColor: themeSettings.primaryColor,
            title: Text(
              "TailWaggr",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: ListenableBuilder(
            listenable: themeSettings,
            builder: (BuildContext context, Widget? child) {
              return Container(
                // width: 300,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: themeSettings.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: themeSettings.textColor.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search for a user or pet",
                        hintStyle: TextStyle(color: themeSettings.textColor.withOpacity(0.5)),
                        prefixIcon: Icon(Icons.search),
                      ),
                      style: TextStyle(color: themeSettings.textColor), // Add this line
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          users = NavbarFunctions.searchUsers(searchController.text);
                          if (users.isEmpty) {
                            users = ["No users found"];
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeSettings.primaryColor,
                        minimumSize: Size(double.infinity, 0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Search", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 20),
                    for (String user in users)
                      if (user != "No users found")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              // backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                            ),
                            SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user,
                                  style: TextStyle(color: themeSettings.textColor),
                                ),
                                Text(
                                  "$user's bio",
                                  style: TextStyle(color: themeSettings.textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          ],
                        ),
                    if (users.contains("No users found"))
                      Text(
                        "No users found",
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
