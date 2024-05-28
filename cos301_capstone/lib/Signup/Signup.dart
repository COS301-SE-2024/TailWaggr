// ignore_for_file: file_names

import 'package:cos301_capstone/Signup/Desktop_View.dart';
import 'package:cos301_capstone/Signup/Mobile_View.dart';
import 'package:cos301_capstone/Signup/Tablet_View.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1000) {
          return const Scaffold(
            body: Desktop_Signup(),
          );
        } 
        else if (constraints.maxWidth > 800) {
          return const Scaffold(
            body: Tablet_Signup(),
          );
        }
        else {
          return const Scaffold(
            body: Mobile_Signup(),
          );
        }
      },
    );
  }
}
