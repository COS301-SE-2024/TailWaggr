// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class MobileHomepage extends StatefulWidget {
  const MobileHomepage({super.key});

  @override
  State<MobileHomepage> createState() => _MobileHomepageState();
}

class _MobileHomepageState extends State<MobileHomepage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Mobile Homepage"),
    );
  }
}