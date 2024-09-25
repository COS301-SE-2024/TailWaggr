import 'package:cos301_capstone/Signup/Desktop_View.dart';
import 'package:cos301_capstone/Signup/Mobile_View.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:cos301_capstone/Signup/Signup.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'mockUIFirebaseApp.dart';

class SignupVariables {
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController signUpConfirmPasswordController = TextEditingController();
  TextEditingController signUpFirstNameController = TextEditingController();
  TextEditingController signUpLastNameController = TextEditingController();
  TextEditingController signUpBioController = TextEditingController();
  TextEditingController signUpPhoneNumberController = TextEditingController();
  TextEditingController signUpAddressController = TextEditingController();
}

/// Tests for the Signup page
/// clear && flutter test test/signup_test.dart

class MockFirebaseAuth extends Mock implements FirebaseAuth {}



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

  testWidgets('Renders Desktop Signup and UI components', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const Desktop_Signup()));

    // Verify the presence of essential UI components
    expect(find.text('Sign up'), findsOneWidget);
    expect(find.byKey(Key("signup-first-name-key")), findsOneWidget);
    expect(find.byKey(Key("signup-last-name-key")), findsOneWidget);
    expect(find.byKey(Key("signup-email-key")), findsOneWidget);
    expect(find.byKey(Key("signup-password-key")), findsOneWidget);
    expect(find.byKey(Key("signup-confirm-password-key")), findsOneWidget);

    expect(find.text('Password must contain the following:'), findsOneWidget);
    expect(find.text('A lowercase letter • A capital letter • A number • A special character • At least 8 characters'), findsOneWidget);

    expect(find.text("Create Account"), findsOneWidget);

    expect(find.text("Already have an account?"), findsOneWidget);
  });

  testWidgets('Toggles password visibility Desktop', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const Desktop_Signup()));

    final togglePassword = find.byIcon(Icons.visibility_off).first;
    final toggleConfirmPassword = find.byIcon(Icons.visibility_off).last;

    // Verify initial state: Password not visible
    expect(togglePassword, findsOneWidget);
    expect(toggleConfirmPassword, findsOneWidget);

    // Toggle password visibility
    await tester.tap(togglePassword);
    await tester.pump();

    // Verify visibility toggle
    expect(find.byIcon(Icons.visibility), findsOneWidget);

    // Toggle confirm password visibility
    await tester.tap(toggleConfirmPassword);
    await tester.pump();

    // Verify visibility toggle
    expect(find.byIcon(Icons.visibility), findsNWidgets(2));
  });

  testWidgets('Enters data into each text field Desktop', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const Desktop_Signup()));

    final firstNameField = find.byKey(Key("signup-first-name-key"));
    final lastNameField = find.byKey(Key("signup-last-name-key"));
    final emailField = find.byKey(Key("signup-email-key"));
    final passwordField = find.byKey(Key("signup-password-key"));
    final confirmPasswordField = find.byKey(Key("signup-confirm-password-key"));

    await tester.enterText(firstNameField, 'John');
    await tester.enterText(lastNameField, 'Doe');
    await tester.enterText(emailField, 'johndoe@gmail.com');
    await tester.enterText(passwordField, 'Password1!');
    await tester.enterText(confirmPasswordField, 'Password1!');

    expect(find.text('John'), findsOneWidget);
    expect(find.text('Doe'), findsOneWidget);
    expect(find.text('johndoe@gmail.com'), findsOneWidget);
    expect(find.text('Password1!'), findsNWidgets(2));
  });

  testWidgets('Renders Mobile Signup and UI components', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const Mobile_Signup()));

    // Verify the presence of essential UI components
    expect(find.text('Sign up'), findsOneWidget);
    expect(find.byKey(Key("signup-first-name-key")), findsOneWidget);
    expect(find.byKey(Key("signup-last-name-key")), findsOneWidget);
    expect(find.byKey(Key("signup-email-key")), findsOneWidget);
    expect(find.byKey(Key("signup-password-key")), findsOneWidget);
    expect(find.byKey(Key("signup-confirm-password-key")), findsOneWidget);

    expect(find.text('Password must contain the following:'), findsOneWidget);
    expect(find.text('A lowercase letter • A capital letter • A number • A special character • At least 8 characters'), findsOneWidget);

    expect(find.text("Create Account"), findsOneWidget);

    expect(find.text("Already have an account?"), findsOneWidget);
  });

  testWidgets('Toggles password visibility Mobile', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const Mobile_Signup()));

    final togglePassword = find.byIcon(Icons.visibility_off).first;
    final toggleConfirmPassword = find.byIcon(Icons.visibility_off).last;

    // Verify initial state: Password not visible
    expect(togglePassword, findsOneWidget);
    expect(toggleConfirmPassword, findsOneWidget);

    // Toggle password visibility
    await tester.tap(togglePassword);
    await tester.pump();

    // Verify visibility toggle
    expect(find.byIcon(Icons.visibility), findsOneWidget);

    // Toggle confirm password visibility
    await tester.tap(toggleConfirmPassword);
    await tester.pump();

    // Verify visibility toggle
    expect(find.byIcon(Icons.visibility), findsNWidgets(2));
  });

  testWidgets('Enters data into each text field Mobile', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    await tester.pumpWidget(createWidgetForTesting(child: const Mobile_Signup()));

    final firstNameField = find.byKey(Key("signup-first-name-key"));
    final lastNameField = find.byKey(Key("signup-last-name-key"));
    final emailField = find.byKey(Key("signup-email-key"));
    final passwordField = find.byKey(Key("signup-password-key"));
    final confirmPasswordField = find.byKey(Key("signup-confirm-password-key"));

    await tester.enterText(firstNameField, 'John');
    await tester.enterText(lastNameField, 'Doe');
    await tester.enterText(emailField, 'johndoe@gmail.com');
    await tester.enterText(passwordField, 'Password1!');
    await tester.enterText(confirmPasswordField, 'Password1!');

    expect(find.text('John'), findsOneWidget);
    expect(find.text('Doe'), findsOneWidget);
    expect(find.text('johndoe@gmail.com'), findsOneWidget);
    expect(find.text('Password1!'), findsNWidgets(2));
  });
}
