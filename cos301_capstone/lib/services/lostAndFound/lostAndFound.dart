import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Pet {
  final String petId;
  final bool found;
  final DateTime? lastSeen;
  final GeoPoint lastSeenLocation;
  double distance;
  final String petName;
  final List<Sighting> sightings;
  String pictureUrl;
  String ownerId;

  Pet({
    required this.petId,
    required this.found,
    required this.lastSeenLocation,
    this.lastSeen,
    this.distance = 0.0,
    required this.petName,
    this.sightings = const [],
    this.pictureUrl = '',
    this.ownerId = '',
  });

  factory Pet.fromDocument(DocumentSnapshot doc, {String petName = 'Unknown', String petPictureUrl = ''}) {
    List<dynamic> sightingsData = doc['sightings'] ?? [];

    // Filter out any invalid or empty sightings (e.g., empty strings)
    List<Sighting> sightingsList = sightingsData.where((s) => s is Map<String, dynamic> && s.isNotEmpty).map((s) => Sighting.fromMap(s)).toList();

    return Pet(
      petId: doc['petID'],
      found: doc['found'] ?? false,
      lastSeen: (doc['lastSeen'] as Timestamp?)?.toDate(),
      lastSeenLocation: doc['lastSeenLocation'],
      petName: petName,
      sightings: sightingsList,
      pictureUrl: petPictureUrl,
      ownerId: doc['ownerId'],
    );
  }

  void addDistance(double indistance) {
    distance = indistance;
  }
}

// Class to represent a pet sighting
class Sighting {
  final String founderId;
  final GeoPoint locationFound;
  final DateTime lastSeen;

  Sighting({
    required this.founderId,
    required this.locationFound,
    required this.lastSeen,
  });

  factory Sighting.fromMap(Map<String, dynamic> data) {
    return Sighting(
      founderId: data['founderId'],
      locationFound: data['locationFound'],
      lastSeen: (data['lastSeen'] as Timestamp).toDate(),
    );
  }
}

class LostAndFoundService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Report a pet missing
  Future<void> reportPetMissing(String petId, LatLng loc, String ownerId) async {
    try {
      GeoPoint location = GeoPoint(loc.latitude, loc.longitude);
      DocumentReference petRef = _firestore.collection('lostPets').doc(petId);

      await petRef.set({
        'petID': petId,
        'ownerId': ownerId,
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
        // 'lastSeenLocation': location, // Update last seen location
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

        // print('Distance to pet ${doc['petID']}: ${distance / 1000} km');

        if ((distance / 1000) <= radius) {
          String petId = doc['petID'];

          // Fetch pet details from the user's sub-collection
          DocumentSnapshot? petDetails = await _getPetNameById(petId, doc['ownerId']);
          String petName = petDetails!['name'] ?? 'Unknown';
          String pictureUrl = petDetails['pictureUrl'] ?? '';
          Pet pet = Pet.fromDocument(doc, petName: petName, petPictureUrl: pictureUrl);
          pet.addDistance(distance / 1000);
          petsWithinRadius.add(pet);
        }
      }

      // print('Found ${petsWithinRadius.length} lost pets within $radius km of user location.');
    } catch (e) {
      print('Error fetching lost pets: $e');
    }

    return petsWithinRadius;
  }

// Helper function to get the pet name from users' sub-collection
  Future<DocumentSnapshot?> _getPetNameById(String petId, String ownerId) async {
    try {
      return await _firestore.collection('users').doc(ownerId).collection('pets').doc(petId).get();
    } catch (e) {
      print('Error fetching pet name: $e');
      return null;
    }
  }

  //report a pet found and remove it from the lost pets collection
  Future<void> reportPetFound(String petId) async {
    try {
      DocumentReference petRef = _firestore.collection('lostPets').doc(petId);
      await petRef.update({
        'found': true,
      });

      print('Pet $petId has been reported found.');
    } catch (e) {
      print('Error reporting pet found: $e');
    }
  }
}
