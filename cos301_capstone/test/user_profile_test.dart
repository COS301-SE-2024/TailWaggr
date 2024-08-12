
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/User_Profile/Desktop_View.dart';
import 'package:cos301_capstone/User_Profile/Mobile_View.dart';
import 'package:cos301_capstone/User_Profile/Tablet_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileDesktop builds correctly', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed, statusCode: 400')) {
        oldOnError!(details);
      }
    };

    // await tester.pumpWidget(MaterialApp(home: User_Profile()));
    await tester.pumpWidget(const MaterialApp(home: ProfileDesktop()));

    /**
     * Testing to see if the navbar components render correctly.
     * The navbar should contain the following widgets:
     * 1. Search
     * 2. Locate
     * 3. Profile
     * 4. Logout
     */
    final locateText = find.text('Locate');
    final profileText = find.text('Profile');
    final logoutText = find.text('Logout');
    expect(locateText, findsOneWidget);
    expect(profileText, findsOneWidget);
    expect(logoutText, findsOneWidget);

    /**
     * Testing to see if the post container is rendered correctly.
     * The post container should contain the following widgets:
     * 1. TabBar
     * 2. TabBarView
     */
    final tabBar = find.byType(TabBar);
    final tabView = find.byType(TabBarView);
    expect(tabBar, findsOneWidget);
    expect(tabView, findsOneWidget);

    /**
     * Testing to see if the About me container is rendered correctly.
     * The post container should contain the following text:
     * 1. Edit Profile
     * 2. Profile Details
     * 3. User type
     * 4. Pet enthusiast
     */
    final editProfileText = find.text('Edit Profile');
    final profileDetailsText = find.text('Profile Details');
    final userTypeText = find.text("User type");
    final petEnthusiastText = find.text("Pet enthusiast");
    expect(editProfileText, findsOneWidget);
    expect(profileDetailsText, findsOneWidget);
    expect(userTypeText, findsOneWidget);
    expect(petEnthusiastText, findsOneWidget);

    /**
     * Testing to see if the My Pets container is rendered correctly.
     * The post container should contain the following text:
     * 1. My Pets
     */
    final myPetsText = find.text('My Pets');
    expect(myPetsText, findsOneWidget);
  });

  testWidgets('ProfileTablet builds correctly', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed, statusCode: 400')) {
        oldOnError!(details);
      }
    };

    // await tester.pumpWidget(MaterialApp(home: User_Profile()));
    await tester.pumpWidget(const MaterialApp(home: ProfileTablet()));

    /**
     * Testing to see if the navbar components render correctly.
     * The navbar should contain the following widgets:
     * 1. Search
     * 2. Locate
     * 3. Profile
     * 4. Logout
     */
    final locateText = find.text('Locate');
    final profileText = find.text('Profile');
    final logoutText = find.text('Logout');
    expect(locateText, findsOneWidget);
    expect(profileText, findsOneWidget);
    expect(logoutText, findsOneWidget);

    /**
     * Testing to see if the post container is rendered correctly.
     * The post container should contain the following widgets:
     * 1. TabBar
     * 2. TabBarView
     */
    final tabBar = find.byType(TabBar);
    final tabView = find.byType(TabBarView);
    expect(tabBar, findsOneWidget);
    expect(tabView, findsOneWidget);

    /**
     * Testing to see if the About me container is rendered correctly.
     * The post container should contain the following text:
     * 1. Edit Profile
     * 2. Profile Details
     * 3. User type
     * 4. Pet enthusiast
     */
    final editProfileText = find.text('Edit Profile');
    expect(editProfileText, findsOneWidget);

    /**
     * Testing to see if the My Pets container is rendered correctly.
     * The post container should contain the following text:
     * 1. My Pets
     */
    final myPetsText = find.text('Pets');
    expect(myPetsText, findsOneWidget);
  });

  testWidgets('ProfileMobile builds correctly', (WidgetTester tester) async {
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
      body: const ProfileMobile(),
    )));

    final drawerButton = find.byIcon(Icons.menu);
    await tester.tap(drawerButton);
    await tester.pumpAndSettle();

    /**
     * Testing to see if the navbar components render correctly.
     * The navbar should contain the following widgets:
     * 1. Search
     * 2. Locate
     * 3. Profile
     * 4. Logout
     */
    final profileText = find.text('Profile');
    final logoutText = find.text('Logout');
    expect(profileText, findsOneWidget);
    expect(logoutText, findsOneWidget);

    /**
     * Testing to see if the post container is rendered correctly.
     * The post container should contain the following widgets:
     * 1. TabBar
     * 2. TabBarView
     */
    final tabBar = find.byType(TabBar);
    final tabView = find.byType(TabBarView);
    expect(tabBar, findsOneWidget);
    expect(tabView, findsOneWidget);

    /**
     * Testing to see if the About me container is rendered correctly.
     * The post container should contain the following text:
     * 1. Edit Profile
     * 2. Profile Details
     * 3. User type
     * 4. Pet enthusiast
     */
    final editProfileText = find.text('Edit Profile');
    expect(editProfileText, findsOneWidget);

    /**
     * Testing to see if the My Pets container is rendered correctly.
     * The post container should contain the following text:
     * 1. My Pets
     */
    final myPetsText = find.text('Pets');
    expect(myPetsText, findsOneWidget);
  });
}
