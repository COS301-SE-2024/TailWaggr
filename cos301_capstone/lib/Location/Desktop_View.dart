
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class LocationDesktop extends StatefulWidget {
  const LocationDesktop({super.key});

  @override
  State<LocationDesktop> createState() => _LocationDesktopState();
}

class _LocationDesktopState extends State<LocationDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DesktopNavbar(),
          Text("Desktop location"),
          
        ],
      ),
    );
  }
}