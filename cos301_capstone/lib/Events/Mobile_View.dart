// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class MobileEvents extends StatefulWidget {
  const MobileEvents({super.key});

  @override
  State<MobileEvents> createState() => _MobileEventsState();
}

class _MobileEventsState extends State<MobileEvents> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Mobile Events"),
    );
  }
}