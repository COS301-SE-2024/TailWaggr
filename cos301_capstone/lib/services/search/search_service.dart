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
    // print(querySnapshot.docs);
    for (final doc in querySnapshot.docs) {
      try {
        User user = User(id: doc.id, name: doc['name'], userType: doc['userType'], location: doc['address']);

        user.addProfileUrl(doc['profilePictureUrl']);
        user.addBio(doc['bio']);
        users.add(user);
      } catch (_) {}
    }

    return users;
  }
}
