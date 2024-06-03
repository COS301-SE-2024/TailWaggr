import 'package:cos301_capstone/Login/Desktop_View.dart';
import 'package:cos301_capstone/Login/Mobile_View.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('DesktopLogin widget test', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };
    // Build the DesktopLogin widget.
    await tester.pumpWidget(MaterialApp(home: DesktopLogin()));

    // Verify that the DesktopLogin widget is displayed.
    expect(find.byType(DesktopLogin), findsOneWidget);

    // Verify that the "Login" text is displayed.
    expect(find.text('Login'), findsNWidgets(2));

    // Restore the original error handler
    FlutterError.onError = oldOnError;
  });
  testWidgets('Mobile_View widget test', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
          oldOnError!(details);
        }
      };
      // Build the Mobile_View widget.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold( // Add this
          body: Mobile_View(),
        ),
      ));

      // Verify that the Mobile_View widget is displayed.
      expect(find.byType(Mobile_View), findsOneWidget);

      // Verify that the "Welcome!" text is displayed.
      expect(find.text('Welcome!'), findsOneWidget);

      // Restore the original error handler
      FlutterError.onError = oldOnError;
  });
}