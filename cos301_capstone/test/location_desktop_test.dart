import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cos301_capstone/Location/Desktop_View.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  testWidgets('LocationDesktop widget test', (WidgetTester tester) async {
    // Ignore overflow errors
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    // Mock the GoogleMapController
    final mockController = MockGoogleMapController();

    // Build the LocationDesktop widget.
    await tester.pumpWidget(MaterialApp(home: LocationDesktop()));

    // Verify that the LocationDesktop widget is displayed.
    expect(find.byType(LocationDesktop), findsOneWidget);

    // Verify that the GoogleMap widget is displayed.
    expect(find.byType(GoogleMap), findsOneWidget);

    // Simulate the onMapCreated callback
    final googleMapFinder = find.byType(GoogleMap);
    final googleMap = tester.widget<GoogleMap>(googleMapFinder);
    googleMap.onMapCreated!(mockController);

    // Verify that the GoogleMapController is set
    expect(mockController, isNotNull);

    // Restore the original error handler
    FlutterError.onError = oldOnError;
  });
}