// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/Navbar/Tablet_View.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  Color containerColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1150) {
          return Scaffold(
            body: ListenableBuilder(
              listenable: themeSettings,
              builder: (BuildContext context, Widget? child) {
                return DesktopNavbar();
              },
            ),
          );
        } else if (constraints.maxWidth > 800) {
          return Scaffold(
            body: ListenableBuilder(
              listenable: themeSettings,
              builder: (BuildContext context, Widget? child) {
                return TabletNavbar();
              },
            ),
          );
        } else {
          return Scaffold(
            body: ListenableBuilder(
              listenable: themeSettings,
              builder: (BuildContext context, Widget? child) {
                return MobileNavbar();
              },
            ),
          );
        }
      },
    );
  }
}

class Navbar_Icon extends StatefulWidget {
  const Navbar_Icon({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  State<Navbar_Icon> createState() => _Navbar_IconState();
}

class _Navbar_IconState extends State<Navbar_Icon> {
  Color containerColor = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          setState(() {
            containerColor = Colors.black.withOpacity(0.1);
          });
        },
        onExit: (event) {
          setState(() {
            // Change the color to transparent
            containerColor = Colors.transparent;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(widget.icon, color: Colors.white),
              SizedBox(width: 10),
              Text(widget.text, style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
