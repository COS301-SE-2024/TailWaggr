import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cos301_capstone/Signup/Signup.dart';

void main() {
    testWidgets('Signup widget test', (WidgetTester tester) async {
        // Build the Signup widget.
        await tester.pumpWidget(MaterialApp(home: Signup()));

        // Verify that the Signup widget is displayed.
        expect(find.byType(Signup), findsOneWidget);

        // You can add more checks here to verify the state of the Signup widget.
        // For example, you might check that certain text fields or buttons are displayed.
    });
}