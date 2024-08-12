import 'package:cos301_capstone/Forums/MessageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MessageView UI Tests', () {
    final dummyPost = {
      'messageId': 'postId1',
      'message': {
        'UserId': 'user1',
        'Content': 'This is a test message.',
      },
      'replies': [
        {
          'UserId': 'user2',
          'Content': 'This is a reply.',
        },
      ],
    };

    final dummyUserProfiles = {
      'user1': {
        'userName': 'User One',
      },
      'user2': {
        'userName': 'User Two',
      },
    };

    testWidgets('displays the message and user profile correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MessageView(
          post: dummyPost,
          forumId: 'forum1',
          userProfiles: dummyUserProfiles,
        ),
      ));

      // Verify the main message content
      expect(find.text('User One'), findsOneWidget);
      expect(find.text('This is a test message.'), findsOneWidget);
    });

    testWidgets('displays replies correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MessageView(
          post: dummyPost,
          forumId: 'forum1',
          userProfiles: dummyUserProfiles,
        ),
      ));

      // Verify the reply content
      expect(find.text('User Two'), findsOneWidget);
      expect(find.text('This is a reply.'), findsOneWidget);
    });

    testWidgets('shows TextField for typing reply', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MessageView(
          post: dummyPost,
          forumId: 'forum1',
          userProfiles: dummyUserProfiles,
        ),
      ));

      // Verify the presence of the TextField for replies
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Type your reply here'), findsOneWidget);
    });

     testWidgets('displays the correct user name', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MessageView(
          post: dummyPost,
          forumId: 'forum1',
          userProfiles: dummyUserProfiles,
        ),
      ));

      // Verify that the correct user's name is displayed
      expect(find.text('User One'), findsOneWidget);
    });
  });
}
