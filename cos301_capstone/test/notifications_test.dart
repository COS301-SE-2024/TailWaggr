import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/Notifications/Desktop_View.dart';
import 'package:cos301_capstone/Notifications/Mobile_View.dart';
import 'package:cos301_capstone/Notifications/Tablet_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /**
   * To run only the tests in this file, run the following command:
   * flutter test test/notifications_test.dart
   * 
   * Optionally to clean failing tests:
   * clear && flutter test test/notifications_test.dart
   */

  testWidgets('Desktop Notifications builds correctly', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed, statusCode: 400')) {
        oldOnError!(details);
      }
    };

    // await tester.pumpWidget(MaterialApp(home: User_Profile()));
    await tester.pumpWidget(const MaterialApp(home: DesktopNotifications()));

    /**
     * Testing to see if the navbar components render correctly.
     * The navbar should contain the following widgets:
     * 1. Home
     * 2. Search
     * 3. Notifications
     * 4. Events
     * 5. Locate
     * 6. Forums
     * 7. Profile
     * 8. Logout
     */
    final homeText = find.text('Home');
    final searchText = find.text('Search');
    final notificationsText = find.text('Notifications');
    final eventsText = find.text('Events');
    final locateText = find.text('Locate');
    final forumsText = find.text('Forums');
    final profileText = find.text('Profile');
    final logoutText = find.text('Logout');
    expect(homeText, findsOneWidget);
    expect(searchText, findsOneWidget);
    expect(notificationsText, findsExactly(2));
    expect(eventsText, findsOneWidget);
    expect(locateText, findsOneWidget);
    expect(forumsText, findsOneWidget);
    expect(profileText, findsOneWidget);
    expect(logoutText, findsOneWidget);

    /**
     * Testing to see if the notifications container is rendered correctly.
     * The profileDetails.notifications List should either be empty or contain notifications.
     * The following notifications should be rendered:
     * 1. Friend Request (should contain the text "has requested to follow you" and the buttons "Accept" and "Decline")
     * 2. Like (should contain the text "has liked your post" and the buttons "View Post")
     * 3. Comment (should contain the text "has commented on your post" and the buttons "View Post")
     * 4. Following (should contain the text "started following you" and the buttons "Follow Back")
     * For each notification, there should be a date.
     */
    final friendRequestDate = find.text("02 Jan 2024");
    final friendRequest = find.text(" has requested to follow you");
    final acceptButton = find.text("Accept");
    final declineButton = find.text("Decline");
    expect(friendRequestDate, findsOneWidget);
    expect(friendRequest, findsExactly(2));
    expect(acceptButton, findsExactly(2));
    expect(declineButton, findsExactly(2));

    final likeDate = find.text("01 Jan 2024");
    final like = find.text(" has liked your post");
    final viewPostButton = find.text("View Post");
    expect(likeDate, findsOneWidget);
    expect(like, findsExactly(2));
    expect(viewPostButton, findsExactly(4));

    final commentDate = find.text("04 Jan 2023");
    final comment = find.text(" has commented on your post");
    final viewPostButton2 = find.text("View Post");
    expect(commentDate, findsOneWidget);
    expect(comment, findsExactly(2));
    expect(viewPostButton2, findsExactly(4));

    final followingDate = find.text("03 Jan 2023");
    final following = find.text(" started following you");
    final followBackButton = find.text("Follow Back");
    expect(followingDate, findsOneWidget);
    expect(following, findsOneWidget);
    expect(followBackButton, findsOneWidget);
  });

  testWidgets('Tablet Notifications builds correctly', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed, statusCode: 400')) {
        oldOnError!(details);
      }
    };

    // await tester.pumpWidget(MaterialApp(home: User_Profile()));
    await tester.pumpWidget(const MaterialApp(home: TabletNotifications()));

    /**
     * Testing to see if the navbar components render correctly.
     * The navbar should contain the following widgets:
     * 1. Home
     * 2. Search
     * 3. Notifications
     * 4. Events
     * 5. Locate
     * 6. Forums
     * 7. Profile
     * 8. Logout
     */
    final homeText = find.text('Home');
    final searchText = find.text('Search');
    final notificationsText = find.text('Notifications');
    final eventsText = find.text('Events');
    final locateText = find.text('Locate');
    final forumsText = find.text('Forums');
    final profileText = find.text('Profile');
    final logoutText = find.text('Logout');
    expect(homeText, findsOneWidget);
    expect(searchText, findsOneWidget);
    expect(notificationsText, findsExactly(2));
    expect(eventsText, findsOneWidget);
    expect(locateText, findsOneWidget);
    expect(forumsText, findsOneWidget);
    expect(profileText, findsOneWidget);
    expect(logoutText, findsOneWidget);

    /**
     * Testing to see if the notifications container is rendered correctly.
     * The profileDetails.notifications List should either be empty or contain notifications.
     * The following notifications should be rendered:
     * 1. Friend Request (should contain the text "has requested to follow you" and the buttons "Accept" and "Decline")
     * 2. Like (should contain the text "has liked your post" and the buttons "View Post")
     * 3. Comment (should contain the text "has commented on your post" and the buttons "View Post")
     * 4. Following (should contain the text "started following you" and the buttons "Follow Back")
     * For each notification, there should be a date.
     */
    final friendRequestDate = find.text("02 Jan 2024");
    final friendRequest = find.text("Requested to follow you");
    final acceptButton = find.text("Accept");
    final declineButton = find.text("Decline");
    expect(friendRequestDate, findsOneWidget);
    expect(friendRequest, findsExactly(2));
    expect(acceptButton, findsExactly(2));
    expect(declineButton, findsExactly(2));

    final likeDate = find.text("01 Jan 2024");
    final like = find.text("Liked your post");
    final viewPostButton = find.text("View Post");
    expect(likeDate, findsOneWidget);
    expect(like, findsExactly(2));
    expect(viewPostButton, findsExactly(4));

    final commentDate = find.text("04 Jan 2023");
    final comment = find.text("Commented on your post");
    final viewPostButton2 = find.text("View Post");
    expect(commentDate, findsOneWidget);
    expect(comment, findsExactly(2));
    expect(viewPostButton2, findsExactly(4));

    final followingDate = find.text("03 Jan 2023");
    final following = find.text("Started following you");
    final followBackButton = find.text("Follow Back");
    expect(followingDate, findsOneWidget);
    expect(following, findsOneWidget);
    expect(followBackButton, findsOneWidget);
  });

  testWidgets('Mobile Notifications builds correctly', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed, statusCode: 400')) {
        oldOnError!(details);
      }
    };

    // await tester.pumpWidget(MaterialApp(home: User_Profile()));
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      drawer: const NavbarDrawer(),
      appBar: AppBar(
        backgroundColor: themeSettings.primaryColor,
        title: const Text(
          "TailWaggr",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: const MobileNotifications(),
    )));

    final drawerButton = find.byIcon(Icons.menu);
    await tester.tap(drawerButton);
    await tester.pumpAndSettle();

    /**
     * Testing to see if the navbar components render correctly.
     * The navbar should contain the following widgets:
     * 1. Home
     * 2. Search
     * 3. Notifications
     * 4. Events
     * 5. Forums
     * 6. Profile
     * 7. Logout
     */
    final homeText = find.text('Home');
    final searchText = find.text('Search');
    final notificationsText = find.text('Notifications');
    final eventsText = find.text('Events');
    final forumsText = find.text('Forums');
    final profileText = find.text('Profile');
    final logoutText = find.text('Logout');
    expect(homeText, findsOneWidget);
    expect(searchText, findsOneWidget);
    expect(notificationsText, findsExactly(2));
    expect(eventsText, findsOneWidget);
    expect(forumsText, findsOneWidget);
    expect(profileText, findsOneWidget);
    expect(logoutText, findsOneWidget);

    /**
     * Testing to see if the notifications container is rendered correctly.
     * The profileDetails.notifications List should either be empty or contain notifications.
     * The following notifications should be rendered:
     * 1. Friend Request (should contain the text "has requested to follow you" and the buttons "Accept" and "Decline")
     * 2. Like (should contain the text "has liked your post" and the buttons "View Post")
     * 3. Comment (should contain the text "has commented on your post" and the buttons "View Post")
     * 4. Following (should contain the text "started following you" and the buttons "Follow Back")
     * For each notification, there should be a date.
     */
    final friendRequestDate = find.text("02 Jan 2024");
    final friendRequest = find.text("Requested to follow you");
    final acceptButton = find.text("Accept");
    final declineButton = find.text("Decline");
    expect(friendRequestDate, findsOneWidget);
    expect(friendRequest, findsExactly(2));
    expect(acceptButton, findsExactly(2));
    expect(declineButton, findsExactly(2));

    final likeDate = find.text("01 Jan 2024");
    final like = find.text("Liked your post");
    final viewPostButton = find.text("View Post");
    expect(likeDate, findsOneWidget);
    expect(like, findsExactly(2));
    expect(viewPostButton, findsExactly(4));

    final commentDate = find.text("04 Jan 2023");
    final comment = find.text("Commented on your post");
    final viewPostButton2 = find.text("View Post");
    expect(commentDate, findsOneWidget);
    expect(comment, findsExactly(2));
    expect(viewPostButton2, findsExactly(4));

    final followingDate = find.text("03 Jan 2023");
    final following = find.text("Started following you");
    final followBackButton = find.text("Follow Back");
    expect(followingDate, findsOneWidget);
    expect(following, findsOneWidget);
    expect(followBackButton, findsOneWidget);
  });
}
