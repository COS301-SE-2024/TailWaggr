// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Navbar.dart';
import 'package:cos301_capstone/User_Profile/Desktop_View.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch_dark_light/flutter_switch_dark_light.dart';

class DesktopNavbar extends StatefulWidget {
  const DesktopNavbar({super.key});

  @override
  State<DesktopNavbar> createState() => _DesktopNavbarState();
}

class _DesktopNavbarState extends State<DesktopNavbar> {
  Color containerColor = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 250,
          padding: EdgeInsets.all(30),
          color: themeSettings.Primary_Colour,
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
                  Navbar_Icon(icon: Icons.home, text: "Home"),
                  Navbar_Icon(icon: Icons.search, text: "Search"),
                  Navbar_Icon(icon: Icons.notifications, text: "Notifications"),
                  Navbar_Icon(icon: Icons.calendar_month, text: "Events"),
                  Navbar_Icon(icon: Icons.map_sharp, text: "Locate"),
                  Navbar_Icon(icon: Icons.settings, text: "Forums"),
                  Navbar_Icon(icon: Icons.person_outline, text: "Profile"),
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
                    themeSettings.ToggleTheme();
                  });
                },
                child: Text("Toggle theme"),
              ),
              
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: themeSettings.Background_Colour,
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileDesktop(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
