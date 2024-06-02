// ignore_for_file: prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Location/Desktop_View.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:flutter/material.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeSettings,
      builder: (BuildContext context, Widget? child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1100) {
              return LocationDesktop();
            } else if (constraints.maxWidth > 800) {
              return Text("Tablet location");
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
                body: Text("Mobile location"),
              );
              // return ProfileMobile();
            }
          },
        );
      },
    );
  }
}
