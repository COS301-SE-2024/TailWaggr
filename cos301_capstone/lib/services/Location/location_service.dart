import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> getVets(LatLng userLocation, double radius) async {
    GeoPoint geoPoint = GeoPoint(userLocation.latitude, userLocation.longitude);
    return _getUsersByRoleWithinRadius(geoPoint, radius, 'vet');
  }

  Future<List<User>> getPetKeepers(LatLng userLocation, double radius) async {
    GeoPoint geoPoint = GeoPoint(userLocation.latitude, userLocation.longitude);
    return _getUsersByRoleWithinRadius(geoPoint, radius, 'pet_keeper');
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
      distance: firestoreDoc['distance'],
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
