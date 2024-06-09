// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class MobileNotifications extends StatefulWidget {
  const MobileNotifications({super.key});

  @override
  State<MobileNotifications> createState() => _MobileNotificationsState();
}

class _MobileNotificationsState extends State<MobileNotifications> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Mobile Notifications"),
    );
  }
}