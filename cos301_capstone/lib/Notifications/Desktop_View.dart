// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class DesktopNotifications extends StatefulWidget {
  const DesktopNotifications({super.key});

  @override
  State<DesktopNotifications> createState() => _DesktopNotificationsState();
}

class _DesktopNotificationsState extends State<DesktopNotifications> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DesktopNavbar(),
        Center(
          child: Text("Desktop Notifications"),
        ),
      ],
    );
  }
}