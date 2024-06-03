import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cos301_capstone/Navbar/Navbar.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  testWidgets('DesktopNavbar widget test', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    // Mock the FirebaseAuth
    final mockAuth = MockFirebaseAuth();

    // Build the DesktopNavbar widget.
    await tester.pumpWidget(MaterialApp(home: DesktopNavbar()));
    // Wait for the widget tree to settle.
    await tester.pumpAndSettle();
    // Verify that the DesktopNavbar widget is displayed.
    expect(find.byType(DesktopNavbar), findsOneWidget);

    // Verify that the CircleAvatar, TextFields and ElevatedButton are displayed.
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Restore the original error handler
    FlutterError.onError = oldOnError;
  });
}