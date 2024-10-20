import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Desktop_View.dart' as desktopView;
import 'package:cos301_capstone/Homepage/Tablet_View.dart' as tabletView;
import 'package:cos301_capstone/Homepage/Mobile_View.dart' as mobileView;
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/Homepage/Post.dart' as post;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mockUIFirebaseApp.dart';

class MockFileData {
  final Uint8List bytes;
  final String name;

  MockFileData({required this.bytes, required this.name});
}

/// Tests for the Post widget
/// clear && flutter test test/homePage_test.dart

class MockProfileDetails extends Mock implements ProfileDetails {}

class MockPlatformFile extends Mock implements PlatformFile {}

// class MockGeneralService extends Mock implements GeneralService {}

class MockImagePicker extends Mock implements ImagePicker {}

@GenerateMocks([FirebaseAuth])
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

  /// Testing the post widget for the homepage
  group('Post Widget Tests', () {
    final postDetails = {
      "pictureUrl": "assets/images/pug.jpg",
      "name": "John Doe",
      "CreatedAt": DateTime(2023, 8, 11),
      "Content": "This is a sample post content.",
      "ImgUrl": "assets/images/pug.jpg",
      "PetIds": [
        {"name": "Fluffy", "pictureUrl": "assets/images/pug.jpg", "petId": "RGeqrusnbA2C7xJmGLeg"},
        {"name": "Sparky", "pictureUrl": "assets/images/pug.jpg", "petId": "fdpyhCqVvruozhhvDkBU"},
      ],
      "numLikes": "10",
      "numComments": "5",
      "numViews": "200",
      "postId": "4u3x5fW5Bf9ECTaZ3jn7",
      "userId": "QF5gHocYeGRNbsFmPE3RjUZIId82",
    };

    testWidgets('Displays basic information', (WidgetTester tester) async {
      // Required as flutter tests cannot make http requests
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: post.Post(postDetails: postDetails),
          ),
        ),
      );

      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("Posted on 11 Aug 2023"), findsOneWidget);
      expect(find.text("This is a sample post content."), findsOneWidget);
    });

    testWidgets('Displays pet information', (WidgetTester tester) async {
      // Required as flutter tests cannot make http requests
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: post.Post(postDetails: postDetails),
          ),
        ),
      );

      expect(find.text("Fluffy"), findsOneWidget);
      expect(find.text("Sparky"), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNWidgets(3));
    });

    testWidgets('Displays like, comment, and view counts', (WidgetTester tester) async {
      // Required as flutter tests cannot make http requests
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: post.Post(postDetails: postDetails),
          ),
        ),
      );

      expect(find.text("10"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);
      expect(find.text("200"), findsOneWidget);
    });
  });

  group('Testing the post container for Desktop', () {
    testWidgets('Check post container for Desktop', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('firebase_storage/no-bucket')) {
          oldOnError!(details);
        }
      };

      profileDetails.pets = [
        {
          'name': 'Fluffy',
          'pictureUrl': 'https://firebasestorage.googleapis.com/v0/b/tailwaggr.appspot.com/o/profile_images%2FGolden1.jpg?alt=media&token=82a1575f-fb0d-4144-8203-561b6733a31a',
          'petId': 'KK5Yw7OSWm7EwF19Wokg',
          'type': 'dog',
          'age': 3,
          'bio': 'Good boy',
        }
      ];

      // Now you can pass mockProfileDetails into your widget as needed
      await tester.pumpWidget(createWidgetForTesting(child: desktopView.UploadPostContainer()));

      // expect(find.byKey(Key('post-text-key')), findsOneWidget);
      expect(find.text('What\'s on your mind'), findsOneWidget);
      expect(find.text('Add a photo'), findsOneWidget);
      expect(find.text('Include your pets'), findsOneWidget);
      expect(find.byKey(ValueKey('post-text-key')), findsOneWidget); // Text field is empty
      expect(find.byKey(ValueKey('add-photo-button')), findsOneWidget); // Add photo button is visible
      expect(find.text('Select a pet'), findsNothing); // Pet selection is not visible
    });

    // testWidgets('Should display post text input and add post text', (WidgetTester tester) async {
    //   final oldOnError = FlutterError.onError;
    //   FlutterError.onError = (FlutterErrorDetails details) {
    //     if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('firebase_storage/no-bucket')) {
    //       oldOnError!(details);
    //     }
    //   };

    //   await tester.pumpWidget(createWidgetForTesting(
    //     child: desktopView.UploadPostContainer(),
    //   ));

    //   // Verify that the post text field is visible
    //   expect(find.byKey(Key('post-text-key')), findsOneWidget);

    //   // Add text to the post input
    //   await tester.enterText(find.byKey(Key('post-text-key')), "This is a test post");
    //   expect(find.text("This is a test post"), findsOneWidget);
    // });

    // testWidgets('Should display image when one is selected', (WidgetTester tester) async {
    //   final oldOnError = FlutterError.onError;
    //   FlutterError.onError = (FlutterErrorDetails details) {
    //     if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('firebase_storage/no-bucket')) {
    //       oldOnError!(details);
    //     }
    //   };

    //   // final mockFile = PlatformFile(
    //   //   name: 'test_image.png',
    //   //   bytes: Uint8List.fromList([0, 0, 0]),
    //   //   size: 1024,s
    //   //   path: 'path/to/test_image.png',
    //   // );

    //   await tester.pumpWidget(createWidgetForTesting(
    //     child: desktopView.UploadPostContainer(),
    //   ));

    //   // Mock the image selection process
    //   await tester.tap(find.byKey(Key('add-photo-button')));
    //   await tester.pump();
    // });

    testWidgets('Should display pets list and allow selection', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(
        child: desktopView.UploadPostContainer(),
      ));

      // Ensure the "Include your pets" text is visible
      expect(find.text('Include your pets'), findsOneWidget);

      // Tap the button to select a pet
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify the pet selection UI is displayed
      expect(find.text('Select a pet'), findsOneWidget);
      expect(find.text('Fluffy'), findsOneWidget);

      // Select a pet
      await tester.tap(find.text('Fluffy'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify that the selected pet is displayed
      expect(find.text('Fluffy'), findsOneWidget); // One in the selection and one in the pet list
    });

    testWidgets('Should display error when trying to post without text', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(
        child: desktopView.UploadPostContainer(),
      ));

      // Try to post without text
      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Cannot post without a message'), findsOneWidget);
    });

    testWidgets('Should display error when no image is selected', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(
        child: desktopView.UploadPostContainer(),
      ));

      // Add text to the post input
      await tester.enterText(find.byKey(Key('post-text-key')), "This is a test post");

      // Try to post without selecting an image
      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('No image selected'), findsOneWidget);
    });
  });

  group('Testing the post container for Tablet', () {
    testWidgets('Check post container for Tablet', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('firebase_storage/no-bucket')) {
          oldOnError!(details);
        }
      };

      profileDetails.pets = [
        {
          'name': 'Fluffy',
          'pictureUrl': 'https://firebasestorage.googleapis.com/v0/b/tailwaggr.appspot.com/o/profile_images%2FGolden1.jpg?alt=media&token=82a1575f-fb0d-4144-8203-561b6733a31a',
          'petId': 'KK5Yw7OSWm7EwF19Wokg',
          'type': 'dog',
          'age': 3,
          'bio': 'Good boy',
        }
      ];

      // Now you can pass mockProfileDetails into your widget as needed
      await tester.pumpWidget(createWidgetForTesting(child: tabletView.UploadPostContainer()));

      // expect(find.byKey(Key('post-text-key')), findsOneWidget);
      expect(find.text('What\'s on your mind'), findsOneWidget);
      expect(find.text('Add a photo'), findsOneWidget);
      expect(find.text('Include your pets'), findsOneWidget);
      expect(find.byKey(ValueKey('post-text-key')), findsOneWidget); // Text field is empty
      expect(find.byKey(ValueKey('add-photo-button')), findsOneWidget); // Add photo button is visible
      expect(find.text('Select a pet'), findsNothing); // Pet selection is not visible
    });

    testWidgets('Should display post text input and add post text', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('firebase_storage/no-bucket')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(
        child: tabletView.UploadPostContainer(),
      ));

      // Verify that the post text field is visible
      expect(find.byKey(Key('post-text-key')), findsOneWidget);

      // Add text to the post input
      await tester.enterText(find.byKey(Key('post-text-key')), "This is a test post");
      expect(find.text("This is a test post"), findsOneWidget);
    });

    // testWidgets('Should display image when one is selected', (WidgetTester tester) async {
    //   final oldOnError = FlutterError.onError;
    //   FlutterError.onError = (FlutterErrorDetails details) {
    //     if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('firebase_storage/no-bucket')) {
    //       oldOnError!(details);
    //     }
    //   };

    //   // final mockFile = PlatformFile(
    //   //   name: 'test_image.png',
    //   //   bytes: Uint8List.fromList([0, 0, 0]),
    //   //   size: 1024,
    //   //   path: 'path/to/test_image.png',
    //   // );

    //   await tester.pumpWidget(createWidgetForTesting(
    //     child: tabletView.UploadPostContainer(),
    //   ));

    //   // Mock the image selection process
    //   await tester.tap(find.byKey(Key('add-photo-button')));
    //   await tester.pump();
    // });

    testWidgets('Should display pets list and allow selection', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(
        child: tabletView.UploadPostContainer(),
      ));

      // Ensure the "Include your pets" text is visible
      expect(find.text('Include your pets'), findsOneWidget);

      // Tap the button to select a pet
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify the pet selection UI is displayed
      expect(find.text('Select a pet'), findsOneWidget);
      expect(find.text('Fluffy'), findsOneWidget);

      // Select a pet
      await tester.tap(find.text('Fluffy'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify that the selected pet is displayed
      expect(find.text('Fluffy'), findsOneWidget); // One in the selection and one in the pet list
    });

    testWidgets('Should display error when trying to post without text', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(
        child: tabletView.UploadPostContainer(),
      ));

      // Try to post without text
      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Cannot post without a message'), findsOneWidget);
    });

    // testWidgets('Should display error when no image is selected', (WidgetTester tester) async {
    //   final oldOnError = FlutterError.onError;
    //   FlutterError.onError = (FlutterErrorDetails details) {
    //     if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
    //         !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
    //         !details.exceptionAsString().contains('HTTP request failed')) {
    //       oldOnError!(details);
    //     }
    //   };

    //   await tester.pumpWidget(createWidgetForTesting(
    //     child: tabletView.UploadPostContainer(),
    //   ));

    //   // Add text to the post input
    //   await tester.enterText(find.byKey(Key('post-text-key')), "This is a test post");

    //   // Try to post without selecting an image
    //   await tester.tap(find.text('Post'));
    //   await tester.pumpAndSettle();

    //   // Verify error message is shown
    //   expect(find.text('No image selected'), findsOneWidget);
    // });
  });

  group('Testing the post container for Tablet', () {
    testWidgets('Check post container for Desktop', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('firebase_storage/no-bucket')) {
          oldOnError!(details);
        }
      };

      profileDetails.pets = [
        {
          'name': 'Fluffy',
          'pictureUrl': 'https://firebasestorage.googleapis.com/v0/b/tailwaggr.appspot.com/o/profile_images%2FGolden1.jpg?alt=media&token=82a1575f-fb0d-4144-8203-561b6733a31a',
          'petId': 'KK5Yw7OSWm7EwF19Wokg',
          'type': 'dog',
          'age': 3,
          'bio': 'Good boy',
        }
      ];

      // Now you can pass mockProfileDetails into your widget as needed
      await tester.pumpWidget(createWidgetForTesting(child: mobileView.UploadPostContainer()));

      // expect(find.byKey(Key('post-text-key')), findsOneWidget);
      expect(find.text('What\'s on your mind'), findsOneWidget);
      expect(find.text('Add a photo'), findsOneWidget);
      expect(find.text('Include your pets'), findsOneWidget);
      expect(find.byKey(ValueKey('post-text-key')), findsOneWidget); // Text field is empty
      expect(find.byKey(ValueKey('add-photo-button')), findsOneWidget); // Add photo button is visible
      expect(find.text('Select a pet'), findsNothing); // Pet selection is not visible
    });

    testWidgets('Should display post text input and add post text', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('firebase_storage/no-bucket')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(
        child: mobileView.UploadPostContainer(),
      ));

      // Verify that the post text field is visible
      expect(find.byKey(Key('post-text-key')), findsOneWidget);

      // Add text to the post input
      await tester.enterText(find.byKey(Key('post-text-key')), "This is a test post");
      expect(find.text("This is a test post"), findsOneWidget);
    });

    // testWidgets('Should display image when one is selected', (WidgetTester tester) async {
    //   final oldOnError = FlutterError.onError;
    //   FlutterError.onError = (FlutterErrorDetails details) {
    //     if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('firebase_storage/no-bucket')) {
    //       oldOnError!(details);
    //     }
    //   };

    //   // final mockFile = PlatformFile(
    //   //   name: 'test_image.png',
    //   //   bytes: Uint8List.fromList([0, 0, 0]),
    //   //   size: 1024,
    //   //   path: 'path/to/test_image.png',
    //   // );

    //   await tester.pumpWidget(createWidgetForTesting(
    //     child: mobileView.UploadPostContainer(),
    //   ));

    //   // Mock the image selection process
    //   await tester.tap(find.byKey(Key('add-photo-button')));
    //   await tester.pump();
    // });

    testWidgets('Should display pets list and allow selection', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(
        child: mobileView.UploadPostContainer(),
      ));

      // Ensure the "Include your pets" text is visible
      expect(find.text('Include your pets'), findsOneWidget);

      // Tap the button to select a pet
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify the pet selection UI is displayed
      expect(find.text('Select a pet'), findsOneWidget);
      expect(find.text('Fluffy'), findsOneWidget);

      // Select a pet
      await tester.tap(find.text('Fluffy'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify that the selected pet is displayed
      expect(find.text('Fluffy'), findsOneWidget); // One in the selection and one in the pet list
    });

    testWidgets('Should display error when trying to post without text', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(
        child: mobileView.UploadPostContainer(),
      ));

      // Try to post without text
      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Cannot post without a message'), findsOneWidget);
    });

    // testWidgets('Should display error when no image is selected', (WidgetTester tester) async {
    //   final oldOnError = FlutterError.onError;
    //   FlutterError.onError = (FlutterErrorDetails details) {
    //     if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
    //         !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
    //         !details.exceptionAsString().contains('HTTP request failed')) {
    //       oldOnError!(details);
    //     }
    //   };

    //   await tester.pumpWidget(createWidgetForTesting(
    //     child: mobileView.UploadPostContainer(),
    //   ));

    //   // Add text to the post input
    //   await tester.enterText(find.byKey(Key('post-text-key')), "This is a test post");

    //   // Try to post without selecting an image
    //   await tester.tap(find.text('Post'));
    //   await tester.pumpAndSettle();

    //   // Verify error message is shown
    //   expect(find.text('No image selected'), findsOneWidget);
    // });
  });
}
