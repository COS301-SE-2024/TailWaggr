// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class TabletForums extends StatefulWidget {
  const TabletForums({super.key});

  @override
  State<TabletForums> createState() => _TabletForumsState();
}

class _TabletForumsState extends State<TabletForums> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DesktopNavbar(),
        Center(
          child: Text("Tablet Forums"),
        ),
      ],
    );
  }
}