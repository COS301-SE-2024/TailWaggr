// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const titleTextSize = 56.0;
const subtitleTextSize = 40.0;
const subHeadingTextSize = 30.0;
const bodyTextSize = 20.0;
const subBodyTextSize = 16.0;
const textSize = 14.0;

class ThemeSettings {
  // static Color _primaryColor = Color(0xFF7228A0);
  // static Color _secondaryColor = Color(0xFF9C89FF);
  // static Color _tertiaryColor = Color(0xFF99CCED);
  // static Color _backgroundColor = Colors.white10;
  // static Color _textColor = Colors.black;
  // static Color _cardColor = Colors.white;

  static Color _primaryColor = Color(0xFF6D2480);
  static Color _secondaryColor = Color(0xFF9C89FF);
  static Color _tertiaryColor = Color(0xFF99CCED);
  static Color _backgroundColor = Color.fromARGB(255, 246, 247, 251);
  static Color _textColor = Colors.black;
  static Color _cardColor = Colors.white;

  static var _themeMode = "Light";

  static Color get primaryColor => _primaryColor;
  static Color get secondaryColor => _secondaryColor;
  static Color get tertiaryColor => _tertiaryColor;
  static Color get backgroundColor => _backgroundColor;
  static Color get textColor => _textColor;
  static Color get cardColor => _cardColor;
  static String get themeMode => _themeMode;

  static void toggleTheme() {
    if (_themeMode == "Light") {
      // _primaryColor = Color(0xFF7228A0);
      // _secondaryColor = Color.fromARGB(255, 0, 0, 0);
      // _tertiaryColor = Color.fromARGB(255, 0, 0, 0);
      // _backgroundColor = Color.fromARGB(255, 21, 21, 21);
      // _textColor = Colors.white;
      // _cardColor = Color.fromARGB(255, 21, 21, 21);

      _primaryColor = Color.fromARGB(255, 56, 0, 76);
      _secondaryColor = Color(0xFF9C89FF);
      _tertiaryColor = Color(0xFF99CCED);
      _backgroundColor = Colors.black;
      _textColor = Colors.white;
      _cardColor = Color(0XFF141414);

      _themeMode = "Dark";
    } else if (_themeMode == "Dark") {
      // _primaryColor = Color(0xFF7228A0);
      // _secondaryColor = Color(0xFF9C89FF);
      // _tertiaryColor = Color(0xFF99CCED);
      // _backgroundColor = Colors.white;
      // _textColor = Colors.black;
      // _cardColor = Colors.white;

      _primaryColor = Color(0xFF6D2480);
      _secondaryColor = Color(0xFF9C89FF);
      _tertiaryColor = Color(0xFF99CCED);
      _backgroundColor = Color(0xFFEFF3FC);
      _textColor = Colors.black;
      _cardColor = Colors.white;

      _themeMode = "Light";
    }
  }

  static bool _searchVisible = false;
  static bool get searchVisible => _searchVisible;
  static void toggleSearchVisible() {
    _searchVisible = !_searchVisible;
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

  void toggleTheme() {
    ThemeSettings.toggleTheme();
    notifyListeners();
  }

  bool get searchVisible => ThemeSettings.searchVisible;
  void toggleSearchVisible() {
    ThemeSettings.toggleSearchVisible();
    notifyListeners();
  }
}

ThemeSettingsObserver themeSettings = ThemeSettingsObserver();

class ProfileDetails {
  String name = "";
  String surname = "";
  String userID = FirebaseAuth.instance.currentUser!.uid;
  String bio = "";
  String email = "johndoe@gmail.com";
  String phone = "012 345 6789";
  String dialCode = "+27";
  String isoCode = "ZA";
  String location = "1234 Street Name, City, Country";
  String birthdate = "January 1, 2000";
  String profilePicture = "https://st3.depositphotos.com/4060975/17707/v/450/depositphotos_177073010-stock-illustration-male-vector-icon.jpg";
  String userType = "Veterinarian";

  // Age: 3, 
  // pictureUrl: gs://tailwaggr.appspot.com/forum_images/Golden2.jpg, 
  // bio: Good boy, 
  // type: dog, 
  // name: Fluffy

  List pets = [];
  
  List notifications = [
    Notification(DateTime(2024, 1, 2), "Friend Request", "Jane Doe", ""),
    Notification(DateTime(2024, 1, 1), "Like", "John Smith", ""),
    Notification(DateTime(2023, 1, 4), "Comment", "Alice Johnson", ""),
    Notification(DateTime(2023, 1, 3), "Following", "Bob Brown", ""),
    Notification(DateTime(2022, 1, 2), "Like", "Emily Johnson", ""),
    Notification(DateTime(2021, 12, 31), "Comment", "Michael Smith", ""),
    Notification(DateTime(2021, 12, 30), "Friend Request", "Sarah Brown", ""),
  ];

  List<Map<String, dynamic>> posts = [];


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
}

ProfileDetails profileDetails = ProfileDetails();
