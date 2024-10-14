import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/services/Location/location_service.dart';

class SearchService {
  final _db = FirebaseFirestore.instance;

  Future<List<User>> searchUsers(String query) async {
    final users = <User>[];
    final querySnapshot = await _db
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        // .where('name', isEqualTo: "Tim")
        .get();

    print("Users fetched successfully.");
    print(querySnapshot.docs.length);
    for (final doc in querySnapshot.docs) {
      GeoPoint location = GeoPoint(0, 0);

      try {
        bool verified = doc['emailVerified'];
      } catch (e) {
        continue;
      }

      if (doc['name'] == "Shuaib") {
        print("Shuaib found");
      }

      try {
        location = doc['address'];
      } catch (e) {
        // print(e);
      }

      User user = User(id: doc.id, name: doc['name'], userType: doc['userType'], location: location);

      user.addProfileUrl(doc['profilePictureUrl']);
      user.addBio(doc['bio']);
      users.add(user);
    }

    return users;
  }
}
