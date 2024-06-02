// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Navbar.dart';
import 'package:cos301_capstone/User_Profile/Mobile_View.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TabletNavbar extends StatefulWidget {
  const TabletNavbar({super.key});

  @override
  State<TabletNavbar> createState() => _TabletNavbarState();
}

class _TabletNavbarState extends State<TabletNavbar> {
  List<Widget> pages = [
    ProfileMobile(),
  ];

  bool isSearchVisible = false;

  Color containerColor = Colors.transparent;
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
          color: ThemeSettings.Primary_Colour,
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
                        profileDetails.Name,
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
                  Navbar_Icon(icon: Icons.home, text: "Home", index: 0),
                  // Navbar_Icon(icon: Icons.search, text: "Search", index: 1),
                  Navbar_Icon(icon: Icons.notifications, text: "Notifications", index: 0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearchVisible = !isSearchVisible;
                      });
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
                  Navbar_Icon(icon: Icons.calendar_month, text: "Events", index: 0),
                  Navbar_Icon(icon: Icons.map_sharp, text: "Locate", index: 0),
                  Navbar_Icon(icon: Icons.settings, text: "Forums", index: 0),
                  Navbar_Icon(icon: Icons.person_outline, text: "Profile", index: 0),
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
                    ThemeSettings.toggleTheme();
                  });
                },
                child: Text("Toggle theme"),
              ),
            ],
          ),
        ),
        if (isSearchVisible)
          Container(
            width: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.Card_Colour,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: themeSettings.Text_Colour.withOpacity(0.2),
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
                        setState(() {
                          isSearchVisible = false;
                        });
                      },
                    ),
                  ],
                ),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search for a user or pet",
                    prefixIcon: Icon(Icons.search),
                  ),
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
                    backgroundColor: themeSettings.Primary_Colour,
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
        ListenableBuilder(
          listenable: navbarIndexObserver,
          builder: (BuildContext context, Widget? child) {
            return Container(
              width: MediaQuery.of(context).size.width - (isSearchVisible ? 550 : 250),
              color: ThemeSettings.Background_Colour,
              padding: EdgeInsets.all(20),
              child: pages[navbarIndexObserver.index],
            );
          },
        ),
      ],
    );
  }
}
