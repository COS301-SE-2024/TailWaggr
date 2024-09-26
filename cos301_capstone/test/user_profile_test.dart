import 'dart:math';

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/User_Profile/Desktop_View.dart' as desktopView;
import 'package:cos301_capstone/User_Profile/Tablet_View.dart' as tabletView;
import 'package:cos301_capstone/User_Profile/Mobile_View.dart' as mobileView;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mockUIFirebaseApp.dart';

/// Tests for the User Profile widget
/// clear && flutter test test/user_profile_test.dart

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

  group('Testing Desktop User Profile', () {
    testWidgets('Testing the PostsContainer widget for Desktop', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(child: desktopView.PostsContainer()));

      expect(find.text("Posts"), findsOneWidget);
    });

    testWidgets('Testing the ListOfPosts widget for Desktop', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.myPosts = [
        {
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
        }
      ];

      await tester.pumpWidget(createWidgetForTesting(child: desktopView.ListOfPosts()));

      expect(find.text("This is a sample post content."), findsOneWidget);
      expect(find.text("Included pets:"), findsOneWidget);
      expect(find.text("Fluffy"), findsOneWidget);
      expect(find.text("Sparky"), findsOneWidget);
    });

    testWidgets('Testing the AboutMeContainer widget for Desktop', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.email = "johndoe@gmail.com";
      profileDetails.phone = "0123456789";
      profileDetails.birthdate = "1999-12-12";
      profileDetails.location = "Pretoria";
      profileDetails.userType = "Veterinarian";

      await tester.pumpWidget(createWidgetForTesting(child: desktopView.AboutMeContainer()));

      expect(find.text("Profile Details"), findsOneWidget);
      expect(find.text("johndoe@gmail.com"), findsOneWidget);
      expect(find.text("0123456789"), findsOneWidget);
      expect(find.text("1999-12-12"), findsOneWidget);
      expect(find.text("Pretoria"), findsOneWidget);
      expect(find.text("Pet enthusiast"), findsOneWidget);
      expect(find.text("Veterinarian"), findsOneWidget);
    });

    testWidgets('Testing the MyPetsContainer widget for Desktop', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(child: desktopView.MyPetsContainer()));

      expect(find.text("My Pets"), findsOneWidget);
    });

    testWidgets('Testing the PetProfileButton widget for Desktop', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.pets = [
        {
          "bio": "This is a sample pet bio.",
          "birthDate": "2020-01-01",
          "name": "Fluffy",
          "petID": "RGeqrusnbA2C7xJmGLeg",
          "pictureUrl":
              "https://firebasestorage.googleapis.com/v0/b/tailwaggr.appspot.com/o/pet_images%2FQF5gHocYeGRNbsFmPE3RjUZIId82_1723142218973.png?alt=media&token=83901b81-3380-48c8-9225-ed5b94752dde",
        },
        {
          "bio": "This is a sample pet bio.",
          "birthDate": "2020-01-01",
          "name": "Sparky",
          "petID": "fdpyhCqVvruozhhvDkBU",
          "pictureUrl":
              "https://firebasestorage.googleapis.com/v0/b/tailwaggr.appspot.com/o/pet_images%2FQF5gHocYeGRNbsFmPE3RjUZIId82_1723142218973.png?alt=media&token=83901b81-3380-48c8-9225-ed5b94752dde",
        }
      ];

      await tester.pumpWidget(
        createWidgetForTesting(
          child: desktopView.PetProfileButton(
            petName: profileDetails.pets[0]["name"],
            petBio: profileDetails.pets[0]["bio"],
            petPicture: profileDetails.pets[0]["pictureUrl"],
          ),
        ),
      );

      expect(find.text("Fluffy"), findsOneWidget);
      expect(find.text("This is a sample pet bio."), findsOneWidget);

      await tester.pumpWidget(
        createWidgetForTesting(
          child: desktopView.PetProfileButton(
            petName: profileDetails.pets[1]["name"],
            petBio: profileDetails.pets[1]["bio"],
            petPicture: profileDetails.pets[1]["pictureUrl"],
          ),
        ),
      );

      expect(find.text("Sparky"), findsOneWidget);
      expect(find.text("This is a sample pet bio."), findsOneWidget);
    });
  });

  group('Testing Tablet User Profile', () {
    testWidgets('Testing the PostsContainer widget for Tablet', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.myPosts = [
        {
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
        }
      ];

      await tester.pumpWidget(createWidgetForTesting(child: tabletView.PostsContainer()));

      expect(find.text("This is a sample post content."), findsOneWidget);
      expect(find.text("Included pets:"), findsOneWidget);
      expect(find.text("Fluffy"), findsOneWidget);
      expect(find.text("Sparky"), findsOneWidget);
    });

    testWidgets('Testing the AboutMeContainer widget for Tablet', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.name = "John";
      profileDetails.surname = "Doe";
      profileDetails.bio = "This is a sample bio.";

      await tester.pumpWidget(createWidgetForTesting(child: tabletView.AboutMeContainer()));

      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("This is a sample bio."), findsOneWidget);
    });

    testWidgets('Testing the DetailsContainer widget for Tablet', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(child: tabletView.DetailsContainer()));

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.text("Details"), findsOneWidget);

      expect(find.byIcon(Icons.pets_outlined), findsOneWidget);
      expect(find.text("Pets"), findsOneWidget);

      expect(find.byIcon(Icons.add_box_outlined), findsOneWidget);
      expect(find.text("Posts"), findsOneWidget);
    });

    testWidgets('Testing the PersonalDetailsContainer widget for Tablet', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.email = "johndoe@gmail.com";
      profileDetails.phone = "0123456789";
      profileDetails.birthdate = "1999-12-12";
      profileDetails.location = "Pretoria";
      profileDetails.userType = "Veterinarian";

      await tester.pumpWidget(createWidgetForTesting(child: tabletView.PersonalDetailsContainer()));

      expect(find.text("Personal Information"), findsOneWidget);
      expect(find.text("johndoe@gmail.com"), findsOneWidget);
      expect(find.text("0123456789"), findsOneWidget);
      expect(find.text("1999-12-12"), findsOneWidget);
      expect(find.text("Pretoria"), findsOneWidget);
      expect(find.text("Veterinarian"), findsOneWidget);
    });

    testWidgets('Testing the MyPetsContainer widget for Tablet', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.pets = [
        {
          "bio": "This is a sample pet bio.",
          "birthDate": "2020-01-01",
          "name": "Fluffy",
          "petID": "RGeqrusnbA2C7xJmGLeg",
          "pictureUrl":
              "https://firebasestorage.googleapis.com/v0/b/tailwaggr.appspot.com/o/pet_images%2FQF5gHocYeGRNbsFmPE3RjUZIId82_1723142218973.png?alt=media&token=83901b81-3380-48c8-9225-ed5b94752dde",
        },
        {
          "bio": "This is a sample pet bio 2.",
          "birthDate": "2020-01-01",
          "name": "Sparky",
          "petID": "fdpyhCqVvruozhhvDkBU",
          "pictureUrl":
              "https://firebasestorage.googleapis.com/v0/b/tailwaggr.appspot.com/o/pet_images%2FQF5gHocYeGRNbsFmPE3RjUZIId82_1723142218973.png?alt=media&token=83901b81-3380-48c8-9225-ed5b94752dde",
        }
      ];

      await tester.pumpWidget(createWidgetForTesting(child: tabletView.MyPetsContainer()));

      expect(find.text("Fluffy"), findsOneWidget);
      expect(find.text("This is a sample pet bio."), findsOneWidget);

      expect(find.text("Sparky"), findsOneWidget);
      expect(find.text("This is a sample pet bio 2."), findsOneWidget);
    });
  });

  group('Testing Mobile User Profile', () {
    testWidgets('Testing the PostsContainer widget for Mobile', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.myPosts = [
        {
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
        }
      ];

      await tester.pumpWidget(createWidgetForTesting(child: mobileView.PostsContainer()));

      expect(find.text("This is a sample post content."), findsOneWidget);
      expect(find.text("Pets included in this post: "), findsOneWidget);
      expect(find.text("Fluffy"), findsOneWidget);
      expect(find.text("Sparky"), findsOneWidget);
    });

    testWidgets('Testing the AboutMeContainer widget for Mobile', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.name = "John";
      profileDetails.surname = "Doe";
      profileDetails.bio = "This is a sample bio.";

      await tester.pumpWidget(createWidgetForTesting(child: mobileView.AboutMeContainer()));

      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("This is a sample bio."), findsOneWidget);
    });

    testWidgets('Testing the DetailsContainer widget for Mobile', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      await tester.pumpWidget(createWidgetForTesting(child: mobileView.DetailsContainer()));

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.pets_outlined), findsOneWidget);
      expect(find.byIcon(Icons.add_box_outlined), findsOneWidget);
    });

    testWidgets('Testing the PersonalDetailsContainer widget for Mobile', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.email = "johndoe@gmail.com";
      profileDetails.phone = "0123456789";
      profileDetails.birthdate = "1999-12-12";
      profileDetails.location = "Pretoria";
      profileDetails.userType = "Veterinarian";

      await tester.pumpWidget(createWidgetForTesting(child: mobileView.PersonalDetailsContainer()));

      expect(find.text("Personal Information"), findsOneWidget);
      expect(find.text("johndoe@gmail.com"), findsOneWidget);
      expect(find.text("0123456789"), findsOneWidget);
      expect(find.text("1999-12-12"), findsOneWidget);
      expect(find.text("Pretoria"), findsOneWidget);
      expect(find.text("Veterinarian"), findsOneWidget);
    });

    testWidgets('Testing the MyPetsContainer widget for Mobile', (WidgetTester tester) async {
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!details.exceptionAsString().contains('A RenderFlex overflowed by') &&
            !details.exceptionAsString().contains('firebase_storage/no-bucket') &&
            !details.exceptionAsString().contains('Incorrect use of ParentDataWidget') &&
            !details.exceptionAsString().contains('HTTP request failed')) {
          oldOnError!(details);
        }
      };

      profileDetails.pets = [
        {
          "bio": "This is a sample pet bio.",
          "birthDate": "2020-01-01",
          "name": "Fluffy",
          "petID": "RGeqrusnbA2C7xJmGLeg",
          "pictureUrl":
              "https://firebasestorage.googleapis.com/v0/b/tailwaggr.appspot.com/o/pet_images%2FQF5gHocYeGRNbsFmPE3RjUZIId82_1723142218973.png?alt=media&token=83901b81-3380-48c8-9225-ed5b94752dde",
        },
        {
          "bio": "This is a sample pet bio 2.",
          "birthDate": "2020-01-01",
          "name": "Sparky",
          "petID": "fdpyhCqVvruozhhvDkBU",
          "pictureUrl":
              "https://firebasestorage.googleapis.com/v0/b/tailwaggr.appspot.com/o/pet_images%2FQF5gHocYeGRNbsFmPE3RjUZIId82_1723142218973.png?alt=media&token=83901b81-3380-48c8-9225-ed5b94752dde",
        }
      ];

      await tester.pumpWidget(createWidgetForTesting(child: mobileView.MyPetsContainer()));

      expect(find.text("Fluffy"), findsOneWidget);
      expect(find.text("This is a sample pet bio."), findsOneWidget);

      expect(find.text("Sparky"), findsOneWidget);
      expect(find.text("This is a sample pet bio 2."), findsOneWidget);
    });
  });
}
