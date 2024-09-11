// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Help/Desktop_View.dart';
import 'package:cos301_capstone/Help/Mobile_View.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return const Scaffold(
            body: DesktopHelp(),
          );
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
            body: MobileHelp(),
          );
        }
      },
    );
  }
}
