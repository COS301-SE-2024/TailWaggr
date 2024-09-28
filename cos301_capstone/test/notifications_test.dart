import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/Notifications/Desktop_View.dart' as desktopNotifications;
import 'package:cos301_capstone/Notifications/Mobile_View.dart';
import 'package:cos301_capstone/Notifications/Tablet_View.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mockUIFirebaseApp.dart';

class MockProfileDetails extends Mock implements ProfileDetails {}

/// Tests for the notifications page
/// clear && flutter test test/notifications_test.dart

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

  String formatDate(Timestamp timeStamp) {
    DateTime date = timeStamp.toDate();
    String month = getMonthAbbreviation(date.month);
    return "${date.day.toString()} $month ${date.year.toString()}";
  }

  void testFunction(String str) {}

  testWidgets('Desktop Notifications builds correctly', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed, statusCode: 400')) {
        oldOnError!(details);
      }
    };

    // await tester.pumpWidget(MaterialApp(home: User_Profile()));
    await tester.pumpWidget(const MaterialApp(home: desktopNotifications.DesktopNotifications()));

    expect(find.byKey(Key('loading-notifications')), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: desktopNotifications.DesktopNotifications()));

    final state = tester.state<desktopNotifications.DesktopNotificationsState>(
      find.byType(desktopNotifications.DesktopNotifications),
    );

    // Manually set the notifications
    state.notifications = [
      {
        "AvatarUrlId": "testId1",
        "Content": "testContent1",
        "CreatedAt": Timestamp.fromDate(DateTime(2024, 12, 1)),
        "NotificationTypeId": 1,
        "Read": false,
        "ReferenceId": "testIdRef1",
        "UserId": "testUserId1",
      },
      {
        "AvatarUrlId": "testId2",
        "Content": "testContent2",
        "CreatedAt": Timestamp.fromDate(DateTime(2024, 12, 2)),
        "NotificationTypeId": 2,
        "Read": false,
        "ReferenceId": "testIdRef2",
        "UserId": "testUserId2",
      }
    ];
    state.hasNewNotifications = true; // Update this as needed

    await tester.pump();

    expect(find.text("Notifications"), findsOneWidget);
  });

  testWidgets('Desktop Notification Card builds correctly', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed, statusCode: 400')) {
        oldOnError!(details);
      }
    };

    Map<String, dynamic> notification = {
      "AvatarUrlId": "testId",
      "Content": "testContent",
      "CreatedAt": Timestamp.fromDate(DateTime(2024, 12, 1)),
      "NotificationTypeId": 3,
      "Read": false,
      "ReferenceId": "testIdRef",
      "UserId": "testUserId",
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: desktopNotifications.NotificationCard(
            notification: notification,
            formatDate: formatDate,
            onMarkAsRead: testFunction,
          ),
        ),
      ),
    );

    expect(find.text('1 Dec 2024'), findsOneWidget);
    expect(find.text('testContent'), findsOneWidget);
    expect(find.byKey(Key('view-message')), findsOneWidget);
  });
}
