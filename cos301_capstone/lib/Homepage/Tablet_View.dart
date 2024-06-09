// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class TabletHomepage extends StatefulWidget {
  const TabletHomepage({super.key});

  @override
  State<TabletHomepage> createState() => _TabletHomepageState();
}

class _TabletHomepageState extends State<TabletHomepage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DesktopNavbar(),
        Center(
          child: Text("Tablet Homepage"),
        ),
      ],
    );
  }
}