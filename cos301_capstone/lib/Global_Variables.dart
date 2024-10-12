// ignore_for_file: file_names

import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var titleTextSize = 56.0;
var subtitleTextSize = 40.0;
var subHeadingTextSize = 30.0;
var bodyTextSize = 20.0;
var subBodyTextSize = 16.0;
var textSize = 14.0;

class ThemeSettings {
  static Color _primaryColor = Color(0XFFbc6c25);
  static Color _secondaryColor = Color(0xFF606c38);
  static Color _tertiaryColor = Color(0xFF99CCED);
  static Color _backgroundColor = Color(0xFFEFF3FC);
  static Color _textColor = Colors.black;
  static Color _cardColor = Colors.white;
  static Color _navbarTextColour = Colors.white;

  static var _themeMode = "Light";

  static Color get primaryColor => _primaryColor;
  static Color get secondaryColor => _secondaryColor;
  static Color get tertiaryColor => _tertiaryColor;
  static Color get backgroundColor => _backgroundColor;
  static Color get textColor => _textColor;
  static Color get cardColor => _cardColor;
  static String get themeMode => _themeMode;
  static Color get navbarTextColour => _navbarTextColour;

  static Future<void> toggleTheme(String themeMode) async {
    if (themeMode == "Dark") {
      _themeMode = "Dark";
      _primaryColor = Color(0XFFbc6c25);
      _secondaryColor = Color(0xFF606c38);
      _tertiaryColor = Color(0xFF99CCED);
      _backgroundColor = Colors.black;
      _textColor = Colors.white;
      _cardColor = Color(0XFF141414);
    } else if (themeMode == "Light") {
      _themeMode = "Light";
      _primaryColor = Color(0XFFbc6c25);
      _secondaryColor = Color(0xFF606c38);
      _tertiaryColor = Color(0xFF99CCED);
      _backgroundColor = Color(0xFFEFF3FC);
      _textColor = Colors.black;
      _cardColor = Colors.white;
    } else if (themeMode == "Custom") {
      _themeMode = "Custom";
    }

    if (profileDetails.customColours['PrimaryColour'] != null) {
      try {
        await ProfileService().updateProfile(
            profileDetails.userID,
            {
              "preferences": {
                "themeMode": _themeMode,
                "Colours": {
                  "PrimaryColour": profileDetails.customColours['PrimaryColour'],
                  "SecondaryColour": profileDetails.customColours['SecondaryColour'],
                  "BackgroundColour": profileDetails.customColours['BackgroundColour'],
                  "TextColour": profileDetails.customColours['TextColour'],
                  "CardColour": profileDetails.customColours['CardColour'],
                  "NavbarTextColour": profileDetails.customColours['NavbarTextColour'],
                },
                "usingDefaultImage": profileDetails.usingDefaultImage,
                "usingImage": profileDetails.usingImage,
              },
            },
            null,
            null);
      } catch (e) {
        print(e);
      }
    }
  }

  static bool _searchVisible = false;
  static bool get searchVisible => _searchVisible;
  static void toggleSearchVisible() {
    _searchVisible = !_searchVisible;
  }

  static void setPrimaryColor(Color color) {
    _primaryColor = color;
  }

  static void setSecondaryColor(Color color) {
    _secondaryColor = color;
  }

  static void setTertiaryColor(Color color) {
    _tertiaryColor = color;
  }

  static void setBackgroundColor(Color color) {
    _backgroundColor = color;
  }

  static void setTextColor(Color color) {
    _textColor = color;
  }

  static void setCardColor(Color color) {
    _cardColor = color;
  }

  static void setNavbarTextColour(Color color) {
    _navbarTextColour = color;
  }
}

class ThemeSettingsObserver extends ChangeNotifier {
  Color get primaryColor => ThemeSettings.primaryColor;
  Color get secondaryColor => ThemeSettings.secondaryColor;
  Color get tertiaryColor => ThemeSettings.tertiaryColor;
  Color get backgroundColor => ThemeSettings.backgroundColor;
  Color get textColor => ThemeSettings.textColor;
  Color get cardColor => ThemeSettings.cardColor;
  String get themeMode => ThemeSettings.themeMode;
  Color get navbarTextColour => ThemeSettings.navbarTextColour;

  void toggleTheme(String themeMode) {
    ThemeSettings.toggleTheme(themeMode);
    notifyListeners();
  }

  bool get searchVisible => ThemeSettings.searchVisible;
  void toggleSearchVisible() {
    ThemeSettings.toggleSearchVisible();
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    ThemeSettings.setPrimaryColor(color);
    notifyListeners();
  }

  void setSecondaryColor(Color color) {
    ThemeSettings.setSecondaryColor(color);
    notifyListeners();
  }

  void setTertiaryColor(Color color) {
    ThemeSettings.setTertiaryColor(color);
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    ThemeSettings.setBackgroundColor(color);
    notifyListeners();
  }

  void setTextColor(Color color) {
    ThemeSettings.setTextColor(color);
    notifyListeners();
  }

  void setCardColor(Color color) {
    ThemeSettings.setCardColor(color);
    notifyListeners();
  }

  void setNavbarTextColour(Color color) {
    ThemeSettings.setNavbarTextColour(color);
    notifyListeners();
  }
}

ThemeSettingsObserver themeSettings = ThemeSettingsObserver();

class ProfileDetails {
  String name = "";
  String surname = "";
  String userID = FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.uid : "";  
  String bio = "";
  String email = "";
  String phone = "";
  String dialCode = "";
  String isoCode = "";
  String location = "1234 Street Name, City, Country";
  String birthdate = "";
  String profilePicture = "https://st3.depositphotos.com/4060975/17707/v/450/depositphotos_177073010-stock-illustration-male-vector-icon.jpg";
  String userType = "";
  String themeMode = "Light";
  String sidebarImage = "";
  bool isPublic = false;
  bool usingImage = false;
  bool usingDefaultImage = true;
  ValueNotifier<int> isEditing = ValueNotifier(0);
  List pets = [];
  List notifications = [];
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> myPosts = [];
  Map<String, dynamic> customColours = {};

  void setCustomColours(Map<String, dynamic> colours) {
    customColours = colours;

    print("Theme Mode: ${themeSettings.themeMode}");

    if (themeSettings.themeMode == "Custom") {
      print("Setting custom colours");
      ThemeSettings.setPrimaryColor(Color(colours['PrimaryColour']));
      ThemeSettings.setSecondaryColor(Color(colours['SecondaryColour']));
      ThemeSettings.setBackgroundColor(Color(colours['BackgroundColour']));
      ThemeSettings.setTextColor(Color(colours['TextColour']));
      ThemeSettings.setCardColor(Color(colours['CardColour']));
      ThemeSettings.setNavbarTextColour(Color(colours['NavbarTextColour']));
    }
  }

  @override
  String toString() {
    return 'Name: $name, Surname: $surname, UserID: $userID';
  }
}

class Notification {
  DateTime date;
  String type;
  String fromUser;
  String profilePictureUrl;

  Notification(this.date, this.type, this.fromUser, this.profilePictureUrl);

  String getFormattedDate() {
    String day = date.day.toString().padLeft(2, '0');
    String month = getMonthAbbreviation(date.month);
    String year = date.year.toString();
    return '$day $month $year';
  }
}

ProfileDetails profileDetails = ProfileDetails();

String getMonthAbbreviation(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}
