// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Forgot_Password/Forgot_Password.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/Location/Location.dart';
// import 'package:cos301_capstone/Location/Desktop_View.dart';
// import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/Login/Login.dart';
import 'package:cos301_capstone/LostAndFound/LostAndFound.dart';
import 'package:cos301_capstone/User_Profile/User_Profile.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
// import 'package:cos301_capstone/Navbar/Navbar.dart';
// import 'package:cos301_capstone/Notifications/Notifications.dart';
// import 'package:cos301_capstone/User_Profile/Desktop_View.dart';
// import 'package:cos301_capstone/User_Profile/User_Profile.dart';
// import 'package:cos301_capstone/Signup/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  void populateUserData() async {
    Future<Map<String, dynamic>?> tempDetails = ProfileService().getUserDetails(FirebaseAuth.instance.currentUser!.uid);
    tempDetails.then((value) {
      profileDetails.name = value!['name'];
      profileDetails.surname = value['surname'];
      profileDetails.email = value['email'];
      profileDetails.bio = value['bio'];
      profileDetails.profilePicture = value['profilePictureUrl'];
      profileDetails.location = value['location'];
      profileDetails.themeMode = value['preferences']['themeMode'];
      profileDetails.userType = value['userType'];
      profileDetails.isPublic = value['profileVisibility'];

      profileDetails.phone = value['phoneDetails']['phoneNumber'];
      profileDetails.isoCode = value['phoneDetails']['isoCode'];
      profileDetails.dialCode = value['phoneDetails']['dialCode'];
      profileDetails.usingImage = value['preferences']['usingImage'];
      profileDetails.usingDefaultImage = value['preferences']['usingDefaultImage'];
      profileDetails.sidebarImage = value['sidebarImage'];

      profileDetails.birthdate = formatDate(value['birthDate'].toDate());

      themeSettings.toggleTheme(value['preferences']['themeMode']);

      profileDetails.setCustomColours({
        "PrimaryColour": value['preferences']['Colours']['PrimaryColour'],
        "SecondaryColour": value['preferences']['Colours']['SecondaryColour'],
        "BackgroundColour": value['preferences']['Colours']['BackgroundColour'],
        "TextColour": value['preferences']['Colours']['TextColour'],
        "CardColour": value['preferences']['Colours']['CardColour'],
        "NavbarTextColour": value['preferences']['Colours']['NavbarTextColour'],
      });
    });

    await LocationVAF.initializeLocation();
  }

  String formatDate(DateTime date) {
    return "${date.day} ${getMonthAbbreviation(date.month)} ${date.year}";
  }

  void populateUserPets() {
    Future<List<Map<String, dynamic>>> pets = GeneralService().getUserPets(FirebaseAuth.instance.currentUser!.uid);
    pets.then((value) {
      profileDetails.pets = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          populateUserData();
          populateUserPets();

          return Homepage();
        }
        return Login();
      },
    );
  }
}
