// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Homepage/Homepage.dart';
// import 'package:cos301_capstone/Location/Desktop_View.dart';
// import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/Login/Login.dart';
// import 'package:cos301_capstone/Navbar/Navbar.dart';
// import 'package:cos301_capstone/Notifications/Notifications.dart';
// import 'package:cos301_capstone/User_Profile/Desktop_View.dart';
// import 'package:cos301_capstone/User_Profile/User_Profile.dart';
// import 'package:cos301_capstone/Signup/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          // return Navbar();
          // return ProfileDesktop();
          // return User_Profile();
          // return Location();
          return Homepage();
          // return Notifications();
        }
        return Login();
        // return Signup();
      },
    );
  }
}
