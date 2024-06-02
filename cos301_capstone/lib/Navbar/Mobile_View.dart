// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Navbar.dart';
import 'package:cos301_capstone/Search_Users/Mobile_View.dart';
import 'package:cos301_capstone/User_Profile/Desktop_View.dart';
import 'package:cos301_capstone/User_Profile/Mobile_View.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MobileNavbar extends StatefulWidget {
  const MobileNavbar({super.key});

  @override
  State<MobileNavbar> createState() => _MobileNavbarState();
}

class _MobileNavbarState extends State<MobileNavbar> {

  List<Widget> pages = [
    ProfileMobile(),
    SearchUsersMobile(),
  ];

  bool isSearchVisible = false;

  Color containerColor = Colors.transparent;
  Color searchColor = Colors.transparent;
  List<String> users = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(),
      appBar: AppBar(
        backgroundColor: ThemeSettings.Primary_Colour,
        title: Text(
          "TailWaggr",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: navbarIndexObserver,
        builder: (BuildContext context, Widget? child) {
          return Container(
            // width: MediaQuery.of(context).size.width - (isSearchVisible ? 550 : 250),
            color: ThemeSettings.Background_Colour,
            padding: EdgeInsets.all(20),
            child: pages[navbarIndexObserver.index],
          );
        },
      ),
    );
  }
}

class NavbarDrawer extends StatefulWidget {
  const NavbarDrawer({super.key});

  @override
  State<NavbarDrawer> createState() => _NavbarDrawerState();
}

class _NavbarDrawerState extends State<NavbarDrawer> {
  Color containerColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ThemeSettings.Primary_Colour,
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
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
                Navbar_Icon(icon: Icons.search, text: "Search", index: 1),
                Navbar_Icon(icon: Icons.notifications, text: "Notifications", index: 0),
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  themeSettings.ToggleTheme();
                });
              },
              child: Text("Switch"),
            ),
          ],
        ),
      ),
    );
  }
}
