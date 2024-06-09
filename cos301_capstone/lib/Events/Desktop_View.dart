// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';

class DesktopEvents extends StatefulWidget {
  const DesktopEvents({super.key});

  @override
  State<DesktopEvents> createState() => _DesktopEventsState();
}

class _DesktopEventsState extends State<DesktopEvents> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DesktopNavbar(),
        Center(
          child: Text("Desktop Events"),
        ),
      ],
    );
  }
}