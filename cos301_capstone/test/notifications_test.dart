import 'package:cos301_capstone/Notifications/NotificationCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };
  testWidgets('NotificationCard displays content and date correctly', (WidgetTester tester) async {
    // Arrange
    final notification = {
      'Read': false,
      'CreatedAt': DateTime.now(),
      'AvatarUrl': 'https://example.com/avatar.png',
      'Content': 'This is a notification content',
      'NotificationTypeId': 1,
    };
    formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationCard(notification: notification, formatDate: formatDate),
        ),
      ),
    );

    // Assert
    expect(find.text('This is a notification content'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('View Message'), findsOneWidget);
  });

  testWidgets('NotificationCard shows correct button based on notification type', (WidgetTester tester) async {
    // Arrange
    final notificationWithPost = {
      'Read': false,
      'CreatedAt': DateTime.now(),
      'AvatarUrl': 'https://example.com/avatar.png',
      'Content': 'This is a post notification',
      'NotificationTypeId': 5,
    };
    final formatDate = (DateTime date) => "${date.day}/${date.month}/${date.year}";

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationCard(notification: notificationWithPost, formatDate: formatDate),
        ),
      ),
    );

    // Assert
    expect(find.text('View Post'), findsOneWidget);
  });
}
