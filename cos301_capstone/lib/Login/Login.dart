// ignore_for_file: file_names

import 'package:cos301_capstone/Login/Desktop_View.dart';
import 'package:cos301_capstone/Login/Mobile_View.dart';
import 'package:cos301_capstone/Login/Tablet_View.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1000) {
          return const Scaffold(
            body: DesktopLogin(),
          );
        } 
        else if (constraints.maxWidth > 800) {
          return const Scaffold(
            body: Tablet_View(),
          );
        }
        else {
          return const Scaffold(
            body: Mobile_View(),
          );
        }
      },
    );
  }
}
