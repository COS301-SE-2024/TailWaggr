// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/User_Auth/Auth_Gate.dart';
import 'package:cos301_capstone/firebase_options.dart';
import 'package:cos301_capstone/services/Notifications/pushNotifications.dart';
import 'package:cos301_capstone/services/Location/find_vets_service.dart';
import 'package:cos301_capstone/services/HomePage/home_page_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Fetch vets when the app starts
  // final vetService = VetService(firebaseFunctionUrl: 'https://us-central1-tailwaggr.cloudfunctions.net/getVets');
  // LatLng myLocation = await LocationVAF.getCurrentLocation();
  // String location = "${myLocation.latitude},${myLocation.longitude}";
  // await vetService.fetchAndStoreVets(location, 50000);
  final homePageService = HomePageService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TailWaggr',
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
