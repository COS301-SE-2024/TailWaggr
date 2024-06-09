// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
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
        Center(
          child: Text("Tablet Notifications"),
        ),
      ],
    );
  }
}