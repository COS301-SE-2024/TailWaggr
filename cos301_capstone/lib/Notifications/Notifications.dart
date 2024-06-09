// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/Notifications/Desktop_View.dart';
import 'package:cos301_capstone/Notifications/Mobile_View.dart';
import 'package:cos301_capstone/Notifications/Tablet_View.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: themeSettings,
        builder: (BuildContext context, Widget? child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1100) {
                return DesktopNotifications();
              } else if (constraints.maxWidth > 800) {
                return TabletNotifications();
              } else {
                return Scaffold(
                  drawer: NavbarDrawer(),
                  appBar: AppBar(
                    backgroundColor: themeSettings.Primary_Colour,
                    title: Text(
                      "TailWaggr",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  body: MobileNotifications(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
