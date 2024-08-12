import 'package:cos301_capstone/Homepage/Post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Post Widget Tests', () {
    final postDetails = {
      "pictureUrl": "assets/images/pug.jpg",
      "name": "John Doe",
      "CreatedAt": DateTime(2023, 8, 11),
      "Content": "This is a sample post content.",
      "ImgUrl": "assets/images/pug.jpg",
      "PetIds": [
        {"name": "Fluffy", "pictureUrl": "assets/images/pug.jpg"},
        {"name": "Sparky", "pictureUrl": "assets/images/pug.jpg"},
      ],
      "numLikes": "10",
      "numComments": "5",
      "numViews": "200",
    };

    testWidgets('Displays basic information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Post(postDetails: postDetails, isTestMode: true),
          ),
        ),
      );

      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("Posted on 11 Aug 2023"), findsOneWidget);
      expect(find.text("This is a sample post content."), findsOneWidget);
    });

    testWidgets('Displays pet information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Post(postDetails: postDetails, isTestMode: true),
          ),
        ),
      );

      expect(find.text("Fluffy"), findsOneWidget);
      expect(find.text("Sparky"), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNWidgets(3));
    });

    testWidgets('Displays like, comment, and view counts', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Post(postDetails: postDetails, isTestMode: true),
          ),
        ),
      );

      expect(find.text("10"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);
      expect(find.text("200"), findsOneWidget);
    });

  });
}
