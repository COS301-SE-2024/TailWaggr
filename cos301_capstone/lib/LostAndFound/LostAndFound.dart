// ignore_for_file: file_names

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/LostAndFound/LostAndFoundDesktop.dart';
import 'package:cos301_capstone/LostAndFound/LostAndFoundMobile.dart';
import 'package:cos301_capstone/LostAndFound/LostAndFoundTablet.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:flutter/material.dart';

class LostAndFound extends StatefulWidget {
  const LostAndFound({super.key});

  @override
  State<LostAndFound> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFound> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeSettings,
      builder: (BuildContext context, Widget? child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1100) {
              return LostAndFoundDesktop();
            } else if (constraints.maxWidth > 800) {
              return Scaffold(
                body: LostAndFoundTablet(),
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
                body: LostAndFoundMobile(),
              );
            }
          },
        );
      },
    );
  }
}
