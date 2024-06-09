// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Desktop_View.dart';
import 'package:cos301_capstone/Homepage/Mobile_View.dart';
import 'package:cos301_capstone/Homepage/Tablet_View.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: themeSettings,
        builder: (BuildContext context, Widget? child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1100) {
                return DesktopHomepage();
              } else if (constraints.maxWidth > 800) {
                return TabletHomepage();
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
                  body: MobileHomepage(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
