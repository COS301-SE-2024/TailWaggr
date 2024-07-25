// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
// import 'package:cos301_capstone/Location/Desktop_View.dart';
// import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/Login/Login.dart';
import 'package:cos301_capstone/User_Profile/User_Profile.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
// import 'package:cos301_capstone/Navbar/Navbar.dart';
// import 'package:cos301_capstone/Notifications/Notifications.dart';
// import 'package:cos301_capstone/User_Profile/Desktop_View.dart';
// import 'package:cos301_capstone/User_Profile/User_Profile.dart';
// import 'package:cos301_capstone/Signup/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cos301_capstone/services/Profile/profile.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          populateUserData();
          populateUserPets();

          // return Homepage();
          return User_Profile();
        }
        return Login();
      },
    );
  }
}

void populateUserData() async {
  // print("Populating user data...");
  // print(FirebaseAuth.instance.currentUser!.uid);

  Future<Map<String, dynamic>?> tempDetails = ProfileService().getUserProfile(FirebaseAuth.instance.currentUser!.uid);
  tempDetails.then((value) {
    // print("User data populated successfully.");
    // print(value);
    profileDetails.name = value!['name'];
    profileDetails.surname = value['surname'];
    profileDetails.email = value['email'];
    profileDetails.bio = value['bio'];
    profileDetails.profilePicture = value['profilePictureUrl'];
  });
}

void populateUserPets() {
  Future<List<Map<String, dynamic>>> pets = GeneralService().getUserPets(FirebaseAuth.instance.currentUser!.uid);
  pets.then((value) {
    profileDetails.pets = value;
  });
}
