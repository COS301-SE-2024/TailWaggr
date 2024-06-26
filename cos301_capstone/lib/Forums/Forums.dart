// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:cos301_capstone/Forums/Desktop_View.dart';
import 'package:cos301_capstone/Forums/Mobile_View.dart';
import 'package:cos301_capstone/Forums/Tablet_View.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:flutter/material.dart';

class Forums extends StatefulWidget {
  const Forums({super.key});

  @override
  State<Forums> createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: themeSettings,
        builder: (BuildContext context, Widget? child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1100) {
                return DesktopForums();
              } else if (constraints.maxWidth > 800) {
                return DesktopForums();
              } else {
                return Scaffold(
                  drawer: NavbarDrawer(),
                  appBar: AppBar(
                    backgroundColor: themeSettings.primaryColor,
                    title: Text(
                      "TailWaggr",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  body: DesktopForums(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
