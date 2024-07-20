// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';

NavbarIndexObserver navbarIndexObserver = NavbarIndexObserver();

class NavbarFunctions {
  static List<String> namesAndSurnames = [
    'Alice Smith',
    'Bob Johnson',
    'Charlie Williams',
    'Daisy Jones',
    'Edward Brown',
    'Fiona Davis',
    'George Miller',
    'Hannah Wilson',
    'Ivy Moore',
    'Jack Taylor',
    'Kevin Anderson',
    'Luna Thomas',
    'Mason Jackson',
    'Nora White',
    'Olivia Harris',
    'Paul Martin',
    'Quincy Thompson',
    'Rachel Garcia',
    'Sophia Martinez',
    'Thomas Robinson',
    'Ursula Clark',
    'Victor Rodriguez',
    'Wendy Lewis',
    'Xander Lee',
    'Yara Walker',
    'Zach Hall'
  ];

  static List<String> searchUsers(String searchQuery) {
    return namesAndSurnames.where((name) => name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }
}

class Navbar {
  static int _index = 0;
  static int get index => _index;
  static void setIndex(int indexIn) {
    _index = indexIn;
  }

  static bool _searchVisible = false;
  static bool get searchVisible => _searchVisible;
  static void toggleSearchVisible() {
    _searchVisible = !_searchVisible;
  }
}

class NavbarIndexObserver extends ChangeNotifier {
  int get index => Navbar.index;
  void updateIndex(int index) {
    Navbar.setIndex(index);
    notifyListeners();
  }

  
}

class Navbar_Icon extends StatefulWidget {
  const Navbar_Icon({
    super.key,
    required this.icon,
    required this.text,
    required this.page,
    this.badgeContent,
  });

  final IconData icon;
  final String text;
  final Widget page;
  final Widget? badgeContent; // Add this line

  @override
  State<Navbar_Icon> createState() => _Navbar_IconState();
}

class _Navbar_IconState extends State<Navbar_Icon> {
  Color containerColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.page),
        );
      },
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
        child: Stack(
          children: [
            AnimatedContainer(
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
            if (widget.badgeContent != null)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 12, // Minimum size for a circular badge
                  minHeight: 12, // Minimum size for a circular badge
                ),
                child: Center(
                  child: widget.badgeContent, // Dynamically display the unread notifications count
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
