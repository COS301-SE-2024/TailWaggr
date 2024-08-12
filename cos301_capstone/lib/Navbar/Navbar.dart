// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, must_be_immutable

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

NavbarIndexObserver navbarIndexObserver = NavbarIndexObserver();

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

class ThemeSelect extends StatefulWidget {
  const ThemeSelect({
    super.key,
    required this.initialSelection,
  });

  final String initialSelection;

  @override
  State<ThemeSelect> createState() => ThemeSelectState();
}

class ThemeSelectState extends State<ThemeSelect> {
  Map<Icon, String>? selectedTheme;
  Map<Icon, String> themes = {
    Icon(Icons.light_mode, color: themeSettings.navbarTextColour): 'Light',
    Icon(Icons.dark_mode, color: themeSettings.navbarTextColour): 'Dark',
    Icon(Icons.color_lens, color: themeSettings.navbarTextColour): 'Custom',
  };

  @override
  void initState() {
    super.initState();
    Map<Icon, String> initialEntry = {Icon(Icons.light_mode, color: themeSettings.navbarTextColour): widget.initialSelection};
    selectedTheme = initialEntry;

    profileDetails.isEditing.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          'Select Client',
          style: TextStyle(
            fontSize: 14,
            color: themeSettings.navbarTextColour,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: themes.entries
            .map((MapEntry<Icon, String> entry) => DropdownMenuItem<String>(
                  value: entry.value,
                  child: Row(
                    children: [
                      entry.key,
                      SizedBox(width: 10),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 20,
                          color: themeSettings.navbarTextColour,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ))
            .toList(),
        value: selectedTheme?.values.first, // Ensure this is the selected value
        onChanged: (value) async {
          setState(() {
            final selectedEntry = themes.entries.firstWhere((element) => element.value == value);
            selectedTheme = {selectedEntry.key: selectedEntry.value}; // Create a new map
          });

          if (value == 'Light') {
            themeSettings.toggleTheme('Light');
          } else if (value == 'Dark') {
            themeSettings.toggleTheme('Dark');
          } else if (value == 'Custom') {
            themeSettings.toggleTheme('Custom');
            profileDetails.setCustomColours(profileDetails.customColours);
          }
        },
        buttonStyleData: ButtonStyleData(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.transparent,
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.transparent,
          ),
          iconSize: 14,
          iconEnabledColor: themeSettings.navbarTextColour,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: themeSettings.primaryColor,
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all<double>(5),
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 10, right: 10),
        ),
      ),
    );
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
  final Widget? badgeContent;

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
