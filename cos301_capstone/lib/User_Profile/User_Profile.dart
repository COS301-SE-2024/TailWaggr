// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/User_Profile/Desktop_View.dart';
import 'package:cos301_capstone/User_Profile/Mobile_View.dart';
import 'package:cos301_capstone/User_Profile/Tablet_View.dart';
import 'package:flutter/material.dart';

class User_Profile extends StatefulWidget {
  const User_Profile({super.key});

  @override
  State<User_Profile> createState() => _User_ProfileState();
}

class _User_ProfileState extends State<User_Profile> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeSettings,
      builder: (BuildContext context, Widget? child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1100) {
              return ProfileDesktop();
            } else if (constraints.maxWidth > 800) {
              return ProfileTablet();
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
                body: ProfileMobile(),
              );
              // return ProfileMobile();
            }
          },
        );
      },
    );
  }
}
