import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/LostAndFound/LostAndFoundDesktop.dart' as desktopView;
import 'package:cos301_capstone/LostAndFound/LostAndFoundTablet.dart' as tabletView;
import 'package:cos301_capstone/LostAndFound/LostAndFoundMobile.dart' as mobileView;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

import 'mockUIFirebaseApp.dart';

/// Testing for the Lost and Found page
/// clear && flutter test test/lostandfound_test.dart

class MockProfileDetails extends Mock implements ProfileDetails {}

void main() {
  setupFirebaseAuthMocks();

  late List<Map<String, dynamic>> pets;
  late List<Map<String, dynamic>> profilePets;
  late List<Marker> markers = [];
  List<bool> selectedLostPet = [];
  ValueNotifier<int> selectedPet = ValueNotifier<int>(-1);
  ValueNotifier<GeoPoint> selectedLocation = ValueNotifier<GeoPoint>(GeoPoint(0, 0));

  setUpAll(() async {
    await Firebase.initializeApp();

    // Initialize pets and profilePets here once
    pets = [
      {"petName": "Bella", "lastSeen": "2021-09-01", "location": GeoPoint(-25.751065353022884, 28.24424206468121), "potentialSightings": []},
      {
        "petName": "Max",
        "lastSeen": "2021-09-05",
        "location": GeoPoint(-26.2041028, 28.0473051),
        "potentialSightings": [
          {
            "seenDate": "2021-09-06",
            "location": GeoPoint(-26.2041, 28.0473),
          },
          {
            "seenDate": "2021-09-07",
            "location": GeoPoint(-26.2042, 28.0474),
          },
        ],
      },
      {
        "petName": "Lucy",
        "lastSeen": "2021-08-20",
        "location": GeoPoint(-33.9248685, 18.4240553),
        "potentialSightings": [
          {
            "seenDate": "2021-08-21",
            "location": GeoPoint(-33.9249, 18.4240),
          },
        ]
      },
      {
        "petName": "Charlie",
        "lastSeen": "2021-07-15",
        "location": GeoPoint(-34.603722, -58.381592),
        "potentialSightings": [
          {
            "seenDate": "2021-07-16",
            "location": GeoPoint(-34.6037, -58.3815),
          },
          {
            "seenDate": "2021-07-17",
            "location": GeoPoint(-34.6038, -58.3814),
          },
          {
            "seenDate": "2021-07-18",
            "location": GeoPoint(-34.6039, -58.3813),
          },
        ]
      },
      {
        "petName": "Milo",
        "lastSeen": "2021-06-10",
        "location": GeoPoint(51.5074, -0.1278),
        "potentialSightings": [
          {
            "seenDate": "2021-06-11",
            "location": GeoPoint(51.5073, -0.1277),
          },
        ]
      },
      {
        "petName": "Rocky",
        "lastSeen": "2021-10-25",
        "location": GeoPoint(40.712776, -74.005974),
        "potentialSightings": [
          {
            "seenDate": "2021-10-26",
            "location": GeoPoint(40.7127, -74.0060),
          },
          {
            "seenDate": "2021-10-27",
            "location": GeoPoint(40.7128, -74.0059),
          },
        ]
      }
    ];

    profilePets = [
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

    markers.add(
      Marker(
        markerId: MarkerId("My Location"),
        position: LatLng(0, 0),
        infoWindow: InfoWindow(
          title: "My Location",
          snippet: "You are here",
        ),
      ),
    );

    for (Map<String, dynamic> pet in pets) {
      markers.add(
        Marker(
          markerId: MarkerId(pet["petName"]),
          position: LatLng(pet["location"].latitude, pet["location"].longitude),
          infoWindow: InfoWindow(
            title: pet["petName"],
            snippet: "Last seen: ${pet["lastSeen"]}",
          ),
        ),
      );
    }
  });

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('Displays basic components for Desktop', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('HTTP request failed') &&
          !details.exceptionAsString().contains('No Firebase App') &&
          !details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    profileDetails.pets = profilePets;

    for (int i = 0; i < profileDetails.pets.length; i++) {
      selectedLostPet.add(false);
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: desktopView.LostAndFoundDesktop(),
        ),
      ),
    );

    expect(find.text("Lost and Found"), findsNWidgets(2));
    expect(find.text("Report Lost Pet"), findsOneWidget);
    expect(find.byKey(Key("search-lost-pets-distance-input")), findsOneWidget);
    expect(find.byKey(Key("apply-filters-button")), findsOneWidget);

    // expect(find.text("Bella"), findsOneWidget);
    // expect(find.text("Max"), findsOneWidget);
    // expect(find.text("Lucy"), findsOneWidget);
    // expect(find.text("Charlie"), findsOneWidget);
    // expect(find.text("Milo"), findsOneWidget);
    // expect(find.text("Rocky"), findsOneWidget);
  });


  testWidgets('Testing clicking a pet and viewing the sightings', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('HTTP request failed') &&
          !details.exceptionAsString().contains('No Firebase App') &&
          !details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    profileDetails.pets = profilePets;

    for (int i = 0; i < profileDetails.pets.length; i++) {
      selectedLostPet.add(false);
    }

    // await tester.pumpWidget(
    //   MaterialApp(
    //     home: Scaffold(
    //       body: desktopView.ListOfPets(
    //         pets: pets,
    //         markers: markers,
    //         selectedPet: selectedPet,
    //         selectedLocation: selectedLocation,
    //       ),
    //     ),
    //   ),
    // );

    // // Tap on the pet to select it
    // await tester.tap(find.text("Bella"));
    // await tester.pumpAndSettle();

    // // Assert
    // expect(find.text("Sightings for Bella"), findsOneWidget);
    // expect(find.text("No sightings found"), findsOneWidget);

    // await tester.tap(find.byIcon(Icons.arrow_back));
    // await tester.pumpAndSettle();

    // await tester.tap(find.text("Max"), warnIfMissed: false);
    // await tester.pumpAndSettle();

    // expect(find.text("Sightings for Max"), findsOneWidget);
    // expect(find.text("Date: 2021-09-06"), findsOneWidget);
    // expect(find.text("Date: 2021-09-07"), findsOneWidget);
  });

  testWidgets('Displays basic components for Tablet', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('HTTP request failed') &&
          !details.exceptionAsString().contains('No Firebase App') &&
          !details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    profileDetails.pets = profilePets;

    for (int i = 0; i < profileDetails.pets.length; i++) {
      selectedLostPet.add(false);
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: tabletView.LostAndFoundTablet(),
        ),
      ),
    );

    expect(find.text("Lost and Found"), findsNWidgets(2));
    expect(find.text("Report Lost Pet"), findsOneWidget);
    expect(find.byKey(Key("search-lost-pets-distance-input")), findsOneWidget);
    expect(find.byKey(Key("apply-filters-button")), findsOneWidget);

    // expect(find.text("Bella"), findsOneWidget);
    // expect(find.text("Max"), findsOneWidget);
    // expect(find.text("Lucy"), findsOneWidget);
    // expect(find.text("Charlie"), findsOneWidget);
    // expect(find.text("Milo"), findsOneWidget);
    // expect(find.text("Rocky"), findsOneWidget);
  });

  testWidgets('Testing clicing a pet and viewing the sightings', (WidgetTester tester) async {
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!details.exceptionAsString().contains('HTTP request failed') &&
          !details.exceptionAsString().contains('No Firebase App') &&
          !details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        oldOnError!(details);
      }
    };

    profileDetails.pets = profilePets;

    for (int i = 0; i < profileDetails.pets.length; i++) {
      selectedLostPet.add(false);
    }

    // await tester.pumpWidget(
    //   MaterialApp(
    //     home: Scaffold(
    //       body: tabletView.ListOfPets(
    //         pets: pets,
    //         markers: markers,
    //         selectedPet: selectedPet,
    //         selectedLocation: selectedLocation,
    //       ),
    //     ),
    //   ),
    // );

    // // Tap on the pet to select it
    // await tester.tap(find.text("Bella"));
    // await tester.pumpAndSettle();

    // // Assert
    // expect(find.text("Sightings for Bella"), findsOneWidget);
    // expect(find.text("No sightings found"), findsOneWidget);

    // await tester.tap(find.byIcon(Icons.arrow_back));
    // await tester.pumpAndSettle();

    // await tester.tap(find.text("Max"), warnIfMissed: false);
    // await tester.pumpAndSettle();
  });
}
