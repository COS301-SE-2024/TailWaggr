// ignore_for_file: file_names

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
  String name = "John";
  String surname = "Doe";
  String bio = "This is my bio";
  String email = "johndoe@gmail.com";
  String phone = "012 345 6789";
  String dialCode = "+27";
  String isoCode = "ZA";
  String location = "1234 Street Name, City, Country";
  String birthdate = "January 1, 2000";
  String profilePicture = "https://st3.depositphotos.com/4060975/17707/v/450/depositphotos_177073010-stock-illustration-male-vector-icon.jpg";
  String userType = "Veterinarian";

  List pets = [
    {
      "name": "Bella",
      "bio": "Bella is a playful Golden Retriever who loves to fetch balls and swim in the lake. She is known for her friendly demeanor and her ability to learn new tricks quickly.",
      "birthdate": "March 14, 2020"
    },
    {
      "name": "Max",
      "bio": "Max is a curious and adventurous Siamese cat who enjoys climbing and exploring. He has a knack for finding the coziest spots in the house to nap.",
      "birthdate": "July 22, 2019"
    },
    {
      "name": "Luna",
      "bio": "Luna is a gentle and affectionate Ragdoll cat. She loves being around people and often follows her owner around the house. Her striking blue eyes are mesmerizing.",
      "birthdate": "September 10, 2021"
    },
    {
      "name": "Charlie",
      "bio": "Charlie is an energetic and loyal Labrador Retriever. He enjoys long walks in the park and playing with his favorite squeaky toys. He's always eager to please.",
      "birthdate": "January 5, 2018"
    },
    {
      "name": "Daisy",
      "bio": "Daisy is a sweet and playful Beagle. She loves to sniff around and follow scents, often leading to unexpected adventures. She's very social and enjoys the company of other dogs.",
      "birthdate": "May 3, 2021"
    },
    {
      "name": "Oliver",
      "bio": "Oliver is a mischievous and clever Bengal cat. He loves to climb and explore high places, often surprising his owners with his agility. His beautiful coat is a sight to behold.",
      "birthdate": "December 15, 2020"
    },
    {
      "name": "Molly",
      "bio": "Molly is a loving and gentle English Bulldog. She enjoys lounging around the house and being pampered. Her wrinkled face and soft snoring are absolutely endearing.",
      "birthdate": "June 25, 2019"
    },
    {
      "name": "Rocky",
      "bio": "Rocky is a strong and brave German Shepherd. He excels in obedience training and is very protective of his family. He's always ready for action and loves to play fetch.",
      "birthdate": "October 30, 2018"
    },
    {
      "name": "Chloe",
      "bio": "Chloe is a delicate and graceful Persian cat. She enjoys quiet and calm environments, often found lounging on a soft cushion. Her long, luxurious fur requires regular grooming.",
      "birthdate": "February 17, 2020"
    },
    {
      "name": "Leo",
      "bio":
          "Leo is a vibrant and talkative African Grey Parrot. He loves to mimic sounds and words, often surprising his owners with his extensive vocabulary. He's very social and enjoys being around people.",
      "birthdate": "August 8, 2015"
    }
  ];

  List notifications = [
    Notification(DateTime(2024, 1, 2), "Friend Request", "Jane Doe", ""),
    Notification(DateTime(2024, 1, 1), "Like", "John Smith", ""),
    Notification(DateTime(2023, 1, 4), "Comment", "Alice Johnson", ""),
    Notification(DateTime(2023, 1, 3), "Following", "Bob Brown", ""),
    Notification(DateTime(2022, 1, 2), "Like", "Emily Johnson", ""),
    Notification(DateTime(2021, 12, 31), "Comment", "Michael Smith", ""),
    Notification(DateTime(2021, 12, 30), "Friend Request", "Sarah Brown", ""),
  ];
}

class Notification {
  DateTime date;
  String type;
  String fromUser;
  String profilePictureUrl;

  Notification(this.date, this.type, this.fromUser, this.profilePictureUrl);

  String getFormattedDate() {
    String day = date.day.toString().padLeft(2, '0');
    String month = _getMonthAbbreviation(date.month);
    String year = date.year.toString();
    return '$day $month $year';
  }

  String _getMonthAbbreviation(int month) {
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
