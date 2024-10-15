// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:cos301_capstone/User_Auth/Auth_Gate.dart';
import 'package:cos301_capstone/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Fetch vets when the app starts
  // final vetService = VetService(firebaseFunctionUrl: 'https://us-central1-tailwaggr.cloudfunctions.net/getVets');
  // await vetService.fetchAndStoreVets("-25.751065353022884, 28.24424206468121", 200000);
  // final homePageService = HomePageService();

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
