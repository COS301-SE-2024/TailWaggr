// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class TabletEvents extends StatefulWidget {
  const TabletEvents({super.key});

  @override
  State<TabletEvents> createState() => _TabletEventsState();
}

class _TabletEventsState extends State<TabletEvents> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DesktopNavbar(),
        Center(
          child: Text("Tablet Events"),
        ),
      ],
    );
  }
}