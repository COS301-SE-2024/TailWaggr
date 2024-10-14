// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:collection';
import 'dart:developer';

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/Login/Login.dart';
import 'package:cos301_capstone/NotVerified.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      profileDetails.score = value['score'];
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

      try {
        // Assuming profileDetails.friends is of type Map<String, String>
        var friendsMap = Map<String, String>.from(value['friends']);
        profileDetails.friends = HashMap<String, String>.from(friendsMap);
        // print("Friends found: " + profileDetails.friends.toString());
      } catch (e) {
        print("No friends found for the user");
        log(e.toString());
      }

      try {
        // Assuming profileDetails.requests is of type Map<String, String>
        var requestsMap = Map<String, String>.from(value['friendRequests']);
        profileDetails.requests = HashMap<String, String>.from(requestsMap);
        // print("Requests found: " + profileDetails.requests.toString());
      } catch (e) {
        print("No requests found for the user");
        log(e.toString());
      }
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

          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            return Homepage();
            // print("Email Verified");
          }

          else {
            print("Email not verified");
            return NotVerified();
          }

          // return Homepage(); 
        }
        return Login();
      },
    );
  }
}
