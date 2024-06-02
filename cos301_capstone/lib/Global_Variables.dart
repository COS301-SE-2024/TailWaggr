// ignore_for_file: constant_identifier_names, non_constant_identifier_names, prefer_const_constructors
import 'package:flutter/material.dart';

const Title_Text_Size = 56.0;
const Subtitle_Text_Size = 40.0;
const Sub_Heading_Text_Size = 30.0;
const Body_Text_Size = 20.0;
const Sub_Body_Text_Size = 16.0;

class ThemeSettings {
  static Color _primaryColor = Color(0xFF7228A0);
  static Color _secondaryColor = Color(0xFF9C89FF);
  static Color _tertiaryColor = Color(0xFF99CCED);
  static Color _backgroundColor = Colors.white10;
  static Color _textColor = Colors.black;
  static Color _cardColor = Colors.white;
  static var _themeMode = "Light";

  static Color get Primary_Colour => _primaryColor;
  static Color get Secondary_Colour => _secondaryColor;
  static Color get Tertiary_Colour => _tertiaryColor;
  static Color get Background_Colour => _backgroundColor;
  static Color get Text_Colour => _textColor;
  static Color get Card_Colour => _cardColor;
  static String get themeMode => _themeMode;

  static void toggleTheme() {
    if (_themeMode == "Light") {
      _primaryColor = Color(0xFF7228A0);
      _secondaryColor = Color.fromARGB(255, 0, 0, 0);
      _tertiaryColor = Color.fromARGB(255, 0, 0, 0);
      _backgroundColor = Color.fromARGB(255, 21, 21, 21);
      _textColor = Colors.white;
      _cardColor = Color.fromARGB(255, 21, 21, 21);
      _themeMode = "Dark";
    } else if (_themeMode == "Dark") {
      _primaryColor = Color(0xFF7228A0);
      _secondaryColor = Color(0xFF9C89FF);
      _tertiaryColor = Color(0xFF99CCED);
      _backgroundColor = Colors.white;
      _textColor = Colors.black;
      _cardColor = Colors.white;
      _themeMode = "Light";
    }
  }
}

class ThemeSettingsObserver extends ChangeNotifier {
  Color get Primary_Colour => ThemeSettings.Primary_Colour;
  Color get Secondary_Color => ThemeSettings.Secondary_Colour;
  Color get Tertiary_Colour => ThemeSettings.Tertiary_Colour;
  Color get Background_Colour => ThemeSettings.Background_Colour;
  Color get Text_Colour => ThemeSettings.Text_Colour;
  Color get Card_Colour => ThemeSettings.Card_Colour;
  String get themeMode => ThemeSettings.themeMode;

  void ToggleTheme() {
    ThemeSettings.toggleTheme();
    print("Theme Mode: " + themeSettings.themeMode);
    notifyListeners();
  }
}

ThemeSettingsObserver themeSettings = ThemeSettingsObserver();

class ProfileDetails {
  String Name = "John Doe";
  String Bio = "This is my bio";
  String Email = "johndoe@gmail.com";
  String Phone = "012 345 6789";
  String Location = "1234 Street Name, City, Country";
  String Birthdate = "January 1, 2000";
  String ProfilePicture = "https://st3.depositphotos.com/4060975/17707/v/450/depositphotos_177073010-stock-illustration-male-vector-icon.jpg";
  String UserType = "Veterinarian";

  List pets = [
    {
      "Name": "Bella",
      "Bio": "Bella is a playful Golden Retriever who loves to fetch balls and swim in the lake. She is known for her friendly demeanor and her ability to learn new tricks quickly.",
      "Birthdate": "March 14, 2020"
    },
    {
      "Name": "Max",
      "Bio": "Max is a curious and adventurous Siamese cat who enjoys climbing and exploring. He has a knack for finding the coziest spots in the house to nap.",
      "Birthdate": "July 22, 2019"
    },
    {
      "Name": "Luna",
      "Bio": "Luna is a gentle and affectionate Ragdoll cat. She loves being around people and often follows her owner around the house. Her striking blue eyes are mesmerizing.",
      "Birthdate": "September 10, 2021"
    },
    {
      "Name": "Charlie",
      "Bio": "Charlie is an energetic and loyal Labrador Retriever. He enjoys long walks in the park and playing with his favorite squeaky toys. He's always eager to please.",
      "Birthdate": "January 5, 2018"
    },
    {
      "Name": "Daisy",
      "Bio": "Daisy is a sweet and playful Beagle. She loves to sniff around and follow scents, often leading to unexpected adventures. She's very social and enjoys the company of other dogs.",
      "Birthdate": "May 3, 2021"
    },
    {
      "Name": "Oliver",
      "Bio": "Oliver is a mischievous and clever Bengal cat. He loves to climb and explore high places, often surprising his owners with his agility. His beautiful coat is a sight to behold.",
      "Birthdate": "December 15, 2020"
    },
    {
      "Name": "Molly",
      "Bio": "Molly is a loving and gentle English Bulldog. She enjoys lounging around the house and being pampered. Her wrinkled face and soft snoring are absolutely endearing.",
      "Birthdate": "June 25, 2019"
    },
    {
      "Name": "Rocky",
      "Bio": "Rocky is a strong and brave German Shepherd. He excels in obedience training and is very protective of his family. He's always ready for action and loves to play fetch.",
      "Birthdate": "October 30, 2018"
    },
    {
      "Name": "Chloe",
      "Bio": "Chloe is a delicate and graceful Persian cat. She enjoys quiet and calm environments, often found lounging on a soft cushion. Her long, luxurious fur requires regular grooming.",
      "Birthdate": "February 17, 2020"
    },
    {
      "Name": "Leo",
      "Bio":
          "Leo is a vibrant and talkative African Grey Parrot. He loves to mimic sounds and words, often surprising his owners with his extensive vocabulary. He's very social and enjoys being around people.",
      "Birthdate": "August 8, 2015"
    }
  ];
}

ProfileDetails profileDetails = ProfileDetails();
