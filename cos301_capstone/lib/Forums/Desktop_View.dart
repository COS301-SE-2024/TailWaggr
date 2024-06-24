// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class DesktopForums extends StatefulWidget {
  const DesktopForums({super.key});

  @override
  State<DesktopForums> createState() => _DesktopForumsState();
}

class _DesktopForumsState extends State<DesktopForums> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeSettings.backgroundColor,
      child: Row(
        children: [
          DesktopNavbar(),
          Center(
            child: Text("Desktop Forums"),
          ),
        ],
      ),
    );
  }
}