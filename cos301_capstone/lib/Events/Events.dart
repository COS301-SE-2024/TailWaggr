// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:cos301_capstone/Events/Desktop_View.dart';
import 'package:cos301_capstone/Events/Mobile_View.dart';
import 'package:cos301_capstone/Events/Tablet_View.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: themeSettings,
        builder: (BuildContext context, Widget? child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1100) {
                return DesktopEvents();
              } else if (constraints.maxWidth > 800) {
                return TabletEvents();
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
                  body: MobileEvents(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
