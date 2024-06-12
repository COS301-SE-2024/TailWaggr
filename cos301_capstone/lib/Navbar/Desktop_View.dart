// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Events/Events.dart';
import 'package:cos301_capstone/Forums/Forums.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/Location/Desktop_View.dart';
import 'package:cos301_capstone/Navbar/Navbar.dart';
import 'package:cos301_capstone/Notifications/Notifications.dart';
import 'package:cos301_capstone/User_Profile/Desktop_View.dart';
import 'package:cos301_capstone/User_Profile/User_Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DesktopNavbar extends StatefulWidget {
  const DesktopNavbar({super.key});

  @override
  State<DesktopNavbar> createState() => _DesktopNavbarState();
}

class _DesktopNavbarState extends State<DesktopNavbar> {
  List<Widget> pages = [
    ProfileDesktop(),
  ];

  Color containerColor = Colors.transparent;
  Color themeColor = Colors.transparent;
  Color searchColor = Colors.transparent;
  List<String> users = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 250,
          padding: EdgeInsets.all(30),
          color: ThemeSettings.primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    // backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileDetails.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Navbar_Icon(icon: Icons.home, text: "Home", page: Homepage()),
                  Navbar_Icon(icon: Icons.notifications, text: "Notifications", page: Notifications()),
                  GestureDetector(
                    onTap: () {
                      themeSettings.toggleSearchVisible();
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) {
                        setState(() {
                          searchColor = Colors.black.withOpacity(0.1);
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          searchColor = Colors.transparent;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: searchColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Search", style: TextStyle(color: Colors.white, fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Navbar_Icon(icon: Icons.event, text: "Events", page: Events()),
                  Navbar_Icon(icon: Icons.map_sharp, text: "Locate", page: LocationDesktop()),
                  Navbar_Icon(icon: Icons.forum_outlined, text: "Forums", page: Forums()),
                  Navbar_Icon(icon: Icons.person_outline, text: "Profile", page: User_Profile()),
                ],
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (event) {
                    setState(() {
                      containerColor = Colors.black.withOpacity(0.1);
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      containerColor = Colors.transparent;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Logout", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    themeSettings.toggleTheme();
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (event) {
                    setState(() {
                      themeColor = Colors.black.withOpacity(0.1);
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      themeColor = Colors.transparent;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.dark_mode, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Toggle theme", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (themeSettings.searchVisible)
          Container(
            width: 300,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        themeSettings.toggleSearchVisible();
                      },
                    ),
                  ],
                ),
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
                            Text(user),
                            Text(
                              "$user's bio",
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
          ).animate(),
      ],
    );
  }
}
