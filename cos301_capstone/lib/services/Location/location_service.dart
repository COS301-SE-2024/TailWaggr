import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/services/Location/find_vets_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  late final FirebaseFirestore _firestore;
  LocationService({FirebaseFirestore? firestore}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
  }

  Future<List<Vet>> getVets(LatLng userLocation, double radius) async {
    GeoPoint geoPoint = GeoPoint(userLocation.latitude, userLocation.longitude);
    try {
      // Access the user's "pets" subcollection
      Query querySnapshot = await _firestore.collection('vets');
      QuerySnapshot<Object?> vetsData = await querySnapshot.get();
      List<Vet> vetList = [];
      for (var doc in vetsData.docs) {
        // Convert location map to GeoPoint
        Map<String, dynamic> locationMap = doc['location'];
        GeoPoint locationGeoPoint = GeoPoint(locationMap['lat'], locationMap['lng']);

        Vet vet = Vet(
          name: doc['name'],
          // location: doc['location'],
          location: locationGeoPoint,
          address: doc['address'],
          placeId: doc['place_id'],
        );

        double distance = Geolocator.distanceBetween(
          geoPoint.latitude,
          geoPoint.longitude,
          vet.location.latitude,
          vet.location.longitude,
        );

        vet.addDistance(distance / 1000);

        if ((distance / 1000) <= radius) {
          vetList.add(vet);
        }
      }

      // // Convert each document to a map and add it to a list
      // final vets = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      // log("Vets fetched successfully.");
      // List<Vet> vetList = vets.map((vetData) => Vet.fromFirestore(vetData)).toList();
      // for (Vet vet in vetList) {
      //   log(vet.name);
      //   double distance = Geolocator.distanceBetween(
      //     geoPoint.latitude,
      //     geoPoint.longitude,
      //     vet.location.latitude,
      //     vet.location.longitude,
      //   );
      //   vet.addDistance(distance / 1000);
      // }
      return vetList; // Return the list of pets
    } catch (e) {
      print("Error fetching vets: $e");
      return []; // Return an empty list if an error occurs
    }
  }

  Future<List<Vet>> getVetsByName(String name) async {
    String searchLowerBound = name;
    String searchUpperBound = name + '\uf8ff';
    var vetQuerySnapshot = await _firestore.collection('vets').where('name', isGreaterThanOrEqualTo: searchLowerBound).where('name', isLessThanOrEqualTo: searchUpperBound).get();
    List<Vet> matchingVets = [];

    for (var doc in vetQuerySnapshot.docs) {
      Vet vet = Vet.fromFirestore(doc.data());
      matchingVets.add(vet); // Add vet to the list
    }

    return matchingVets; // Return the list of matching vets
  }

  Future<List<User>> getPetKeepers(LatLng userLocation, double radius) async {
    GeoPoint geoPoint = GeoPoint(userLocation.latitude, userLocation.longitude);
    return _getUsersByRoleWithinRadius(geoPoint, radius, 'pet_keeper');
  }

  Future<List<User>> getPetKeepersByName(String name) async {
    String searchLowerBound = name;
    String searchUpperBound = name + '\uf8ff';
    var petKeeperQuerySnapshot = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: searchLowerBound)
        .where('name', isLessThanOrEqualTo: searchUpperBound)
        .where('userType', isEqualTo: 'pet_keeper')
        .get();
    List<User> matchingPetKeepers = [];

    for (var doc in petKeeperQuerySnapshot.docs) {
      User petKeeper = User.fromFirestore(doc.data());
      matchingPetKeepers.add(petKeeper); // Add pet keeper to the list
    }

    return matchingPetKeepers; // Return the list of matching pet keepers
  }

  Future<List<User>> _getUsersByRoleWithinRadius(GeoPoint userLocation, double radius, String userType) async {
    List<User> usersWithinRadius = [];

    try {
      Query usersSnapshot = await _firestore.collection('users').where('userType', isEqualTo: userType);

      QuerySnapshot<Object?> usersData = await usersSnapshot.get();
      for (var doc in usersData.docs) {
        print(doc.data());
        User user = User(
          id: doc.id,
          name: doc['name'],
          userType: doc['userType'],
          location: doc['location'],
        );
        double distance = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          user.location.latitude,
          user.location.longitude,
        );

        user.addDistance(distance / 1000);
        user.addEmail(doc['email']);

        if ((distance / 1000) <= radius) {
          usersWithinRadius.add(user);
        }
      }
    } catch (e) {
      print("Error getting users: $e");
    }

    return usersWithinRadius;
  }

  Future<List<User>> getUsersByName(String name) async {
    // Adjust the name to search for any name that starts with the given input,
    // and extends to all possible names that start with the input by appending
    // a high-value unicode character to cover all cases.
    String searchLowerBound = name;
    String searchUpperBound = name + '\uf8ff';
    var userQuerySnapshot = await _firestore.collection('users').where('name', isGreaterThanOrEqualTo: searchLowerBound).where('name', isLessThanOrEqualTo: searchUpperBound).get();
    List<User> matchingUsers = [];

    for (var doc in userQuerySnapshot.docs) {
      User user = User.fromFirestore(doc.data());

      if (user.userType == 'vet' || user.userType == 'pet_keeper') {
        matchingUsers.add(user); // Add user to the list if they are a vet or pet_keeper
      }
    }

    return matchingUsers; // Return the list of matching users
  }
}

class User {
  final String id;
  final String name;
  final String userType;
  final GeoPoint location;
  String email;
  String phone;
  double distance;

  User({required this.id, required this.name, required this.userType, required this.location, this.distance = 0.0, this.email = '', this.phone = ''});

  factory User.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return User(
      id: firestoreDoc['id'],
      name: firestoreDoc['name'],
      userType: firestoreDoc['userType'],
      location: firestoreDoc['location'],
    );
  }
  void addDistance(double indistance) {
    distance = indistance;
  }

  void addEmail(String inemail) {
    email = inemail;
  }

  void addPhone(String inphone) {
    phone = inphone;
  }
}

class Vet {
  final String name;
  final GeoPoint location;
  final String placeId;
  final String address;
  double distance = 0.0;

  Vet({required this.name, required this.location, required this.address, required this.placeId});

  factory Vet.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return Vet(
      name: firestoreDoc['name'],
      location: firestoreDoc['location'],
      address: firestoreDoc['address'],
      placeId: firestoreDoc['place_id'],
    );
  }
  void addDistance(double indistance) {
    distance = indistance;
  }
}
