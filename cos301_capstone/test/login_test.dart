
import 'package:cos301_capstone/Login/Desktop_View.dart';
import 'package:cos301_capstone/Login/Mobile_View.dart';
import 'package:cos301_capstone/Login/Tablet_View.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import './mockUIFirebaseApp.dart'; // from: https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart

/// Tests for the Login page
/// clear && flutter test test/login_test.dart


void main() {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('Renders DesktopLogin and UI components', (WidgetTester tester) async {

    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const DesktopLogin()));

    // Verify the presence of essential UI components
    expect(find.text('TailWaggr'), findsOneWidget);
    expect(find.text('Login'), findsNWidgets(2));
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
  });

  testWidgets('Toggles password visibility Desktop', (WidgetTester tester) async {

    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const DesktopLogin()));

    // Verify initial state: Password not visible
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    // Toggle password visibility
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    // Verify visibility toggle
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('Renders TabletLogin and UI components', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const TabletLogin()));

    // Verify the presence of essential UI components
    expect(find.text('TailWaggr'), findsOneWidget);
    expect(find.text('Login'), findsNWidgets(2));
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
  });

testWidgets('Renders MobileLogin and UI components', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const Mobile_View()));

    // Verify the presence of essential UI components
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
  });

  testWidgets('Toggles password visibility Desktop', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const Mobile_View()));

    // Verify initial state: Password not visible
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    // Toggle password visibility
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    // Verify visibility toggle
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

}
