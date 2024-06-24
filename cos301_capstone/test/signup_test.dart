import 'package:cos301_capstone/Signup/Desktop_View.dart';
import 'package:cos301_capstone/Signup/Mobile_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cos301_capstone/Signup/Signup.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  testWidgets('Desktop_Signup widget test', (WidgetTester tester) async {
    // Mock the FirebaseAuth
    final mockAuth = MockFirebaseAuth();
    await tester.pumpWidget(MaterialApp(home: Signup()));
    // Build the Desktop_Signup widget.
    await tester.pumpWidget(MaterialApp(home: Desktop_Signup()));

    // Verify that the Desktop_Signup widget is displayed.
    expect(find.byType(Desktop_Signup), findsOneWidget);

    // Verify that the TextFields and ElevatedButton are displayed.
    expect(find.byType(TextField), findsNWidgets(5));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
  testWidgets('Mobile_Signup widget test', (WidgetTester tester) async {
    // Build the Mobile_Signup widget.
    await tester.pumpWidget(MaterialApp(home: Mobile_Signup()));

    // Verify that the Mobile_Signup widget is displayed.
    expect(find.byType(Mobile_Signup), findsOneWidget);

    // Verify that the "Sign up" text is displayed.
    expect(find.text('Sign up'), findsOneWidget);
  });
} 