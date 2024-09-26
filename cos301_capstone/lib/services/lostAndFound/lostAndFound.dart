import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Pet {
  final String petId;
  final bool found;
  final DateTime? lastSeen;
  final GeoPoint lastSeenLocation;
  double distance;

  Pet({
    required this.petId,
    required this.found,
    required this.lastSeenLocation,
    this.lastSeen,
    this.distance = 0.0,
  });

  factory Pet.fromDocument(DocumentSnapshot doc) {
    return Pet(
      petId: doc['petID'],
      found: doc['found'] ?? false,
      lastSeen: (doc['lastSeen'] as Timestamp?)?.toDate(),
      lastSeenLocation: doc['lastSeenLocation'],
    );
  }
    void addDistance(double indistance) {
    distance = indistance;
  }
}

class LostAndFound {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Report a pet missing
  Future<void> reportPetMissing(String petId, LatLng loc) async {
    try {
      GeoPoint location = GeoPoint(loc.latitude, loc.longitude);
      DocumentReference petRef = _firestore.collection('lostPets').doc(petId);

      await petRef.set({
        'petID': petId,
        'lastSeenLocation': location, // Geopoint
        'lastSeen': FieldValue.serverTimestamp(), // Timestamp
        'found': false, // Mark as missing
        'sightings': [] // Empty sightings array
      });

      print('Pet $petId has been reported missing.');
    } catch (e) {
      print('Error reporting pet missing: $e');
    }
  }

  // Report a pet sighting
  Future<void> reportPetSighting(String petId, String founderId, LatLng loc) async {
    try {
      GeoPoint location = GeoPoint(loc.latitude, loc.longitude);
      DocumentReference petRef = _firestore.collection('lostPets').doc(petId);
      Timestamp now = Timestamp.now();
      // Add a new sighting to the sightings array
      await petRef.update({
        'sightings': FieldValue.arrayUnion([
          {
            'founderId': founderId,
            'lastSeen': now, // Timestamp
            'locationFound': location, // Geopoint
          }
        ]),
        'lastSeenLocation': location, // Update last seen location
        'lastSeen': now, // Update last seen timestamp
      });

      print('Pet sighting reported for petId $petId.');
    } catch (e) {
      print('Error reporting pet sighting: $e');
    }
  }

Future<List<Pet>> getLostPetsNearby(LatLng userLocation, double radius) async {
  List<Pet> petsWithinRadius = [];

  try {
    // Get all lost pets from the database
    QuerySnapshot lostPetsSnapshot = await _firestore.collection('lostPets').where('found', isEqualTo: false).get();

    for (var doc in lostPetsSnapshot.docs) {
      GeoPoint lastSeenLocation = doc['lastSeenLocation'];
      double distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        lastSeenLocation.latitude,
        lastSeenLocation.longitude,
      );

      // Add the pet's distance from the user in kilometers
      if ((distance / 1000) <= radius) {
        Pet pet = Pet.fromDocument(doc);
        pet.addDistance(distance / 1000);
        petsWithinRadius.add(pet);
      }
    }

    print('Found ${petsWithinRadius.length} lost pets within $radius km of user location.');
  } catch (e) {
    print('Error fetching lost pets: $e');
  }

  return petsWithinRadius;
}

}
