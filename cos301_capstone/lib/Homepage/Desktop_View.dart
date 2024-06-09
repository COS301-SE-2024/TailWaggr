// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class DesktopHomepage extends StatefulWidget {
  const DesktopHomepage({super.key});

  @override
  State<DesktopHomepage> createState() => _DesktopHomepageState();
}

class _DesktopHomepageState extends State<DesktopHomepage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DesktopNavbar(),
        Center(
          child: Text("Desktop Homepage"),
        ),
      ],
    );
  }
}