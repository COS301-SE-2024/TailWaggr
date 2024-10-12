import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/Search/DesktopSearch.dart';
import 'package:cos301_capstone/Search/MobileSearch.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeSettings,
      builder: (BuildContext context, Widget? child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return const Scaffold(
                body: DesktopSearch(),
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
                body: MobileSearch(),
              );
            }
          },
        );
      },
    );
  }
}
