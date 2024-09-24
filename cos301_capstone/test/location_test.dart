import 'package:cos301_capstone/Location/Desktop_View.dart' as desktopView;
import 'package:cos301_capstone/Location/Tablet_View.dart' as tabletView;
import 'package:cos301_capstone/Location/Mobile_View.dart' as mobileView;
import 'package:cos301_capstone/Location/Location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

import 'mockUIFirebaseApp.dart';

/// Mock GoogleMapController class
/// clear && flutter test test/location_test.dart

class MockGoogleMapController extends Mock implements GoogleMapController {}

class MockLocationVAF extends Mock implements LocationVAF {}

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

  testWidgets('LocationDesktop widget test', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed')) {
        oldOnError!(details);
      }
    };
    await tester.pumpWidget(createWidgetForTesting(child: desktopView.LocationDesktop()));

    expect(find.byKey(Key('tabController')), findsOneWidget);
    expect(find.byKey(Key('tabBarView')), findsOneWidget);
  });

  testWidgets('Testing the Vets Tab for Desktop', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed')) {
        oldOnError!(details);
      }
    };
    await tester.pumpWidget(createWidgetForTesting(child: desktopView.LocationDesktop()));

    final vetsTab = find.byKey(Key('vetsTab'));

    expect(vetsTab, findsOneWidget);

    await tester.tap(vetsTab);
    await tester.pump();

    expect(find.byKey(Key("search-vets-input")), findsOneWidget);
    expect(find.byKey(Key("search-vets-distance-input")), findsOneWidget);
    expect(find.byKey(Key("apply-filters-button")), findsOneWidget);

    // for when there are no vets to display
    expect(find.text("No veterinary clinics found within the specified radius, try increasing the search radius."), findsOneWidget);
  });

  testWidgets('LocationTablet widget test', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed')) {
        oldOnError!(details);
      }
    };
    await tester.pumpWidget(createWidgetForTesting(child: tabletView.LocationTablet()));

    expect(find.byKey(Key('tabController')), findsOneWidget);
    expect(find.byKey(Key('tabBarView')), findsOneWidget);
  });

  testWidgets('Testing the Vets Tab for Tablet', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed')) {
        oldOnError!(details);
      }
    };
    await tester.pumpWidget(createWidgetForTesting(child: tabletView.LocationTablet()));

    final vetsTab = find.byKey(Key('vetsTab'));

    expect(vetsTab, findsOneWidget);

    await tester.tap(vetsTab);
    await tester.pump();

    expect(find.byKey(Key("search-vets-input")), findsOneWidget);
    expect(find.byKey(Key("search-vets-distance-input")), findsOneWidget);
    expect(find.byKey(Key("apply-filters-button")), findsOneWidget);

    // for when there are no vets to display
    expect(find.text("No veterinary clinics found within the specified radius, try increasing the search radius."), findsOneWidget);
  });

  testWidgets('LocationMobile widget test', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed')) {
        oldOnError!(details);
      }
    };
    await tester.pumpWidget(createWidgetForTesting(child: mobileView.LocationMobile()));

    expect(find.byKey(Key('tabController')), findsOneWidget);
    expect(find.byKey(Key('tabBarView')), findsOneWidget);
  });

  testWidgets('Testing the Vets Tab for Mobile', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by') && !details.exceptionAsString().contains('HTTP request failed')) {
        oldOnError!(details);
      }
    };
    await tester.pumpWidget(createWidgetForTesting(child: mobileView.LocationMobile()));

    final vetsTab = find.byKey(Key('vetsTab'));

    expect(vetsTab, findsOneWidget);

    await tester.tap(vetsTab);
    await tester.pump();

    expect(find.byKey(Key("search-vets-input")), findsOneWidget);
    expect(find.byKey(Key("search-vets-distance-input")), findsOneWidget);
    expect(find.byKey(Key("apply-filters-button")), findsOneWidget);

    // for when there are no vets to display
    expect(find.text("No veterinary clinics found within the specified radius, try increasing the search radius."), findsOneWidget);
  });

  // Note, google maps requires integration test to show the map
}
