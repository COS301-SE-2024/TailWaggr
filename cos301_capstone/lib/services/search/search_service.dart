import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/services/Location/location_service.dart';

class SearchService {
  final _db = FirebaseFirestore.instance;
  DocumentSnapshot? _lastDocument;

  Future<List<User>> searchUsers(String query, bool loadMore) async {
    final users = <User>[];

    Query querySnapshot = _db
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .where('emailVerified', isEqualTo: true)
        .orderBy('name', descending: false)
        .limit(5);

    if (loadMore && _lastDocument != null) {
      querySnapshot = querySnapshot.startAfterDocument(_lastDocument!);
    }

    final querySnapshotData = await querySnapshot.get();

    // Update _lastDocument for pagination
    if (querySnapshotData.docs.isNotEmpty) {
      _lastDocument = querySnapshotData.docs.last;
    }

    for (final doc in querySnapshotData.docs) {
      // _lastDocument = querySnapshotData.docs.last;

      GeoPoint location = GeoPoint(0, 0);

      try {
        location = doc['address'];
      } catch (_) {}

      User user = User(id: doc.id, name: doc['name'], userType: doc['userType'], location: location);

      user.addProfileUrl(doc['profilePictureUrl']);
      user.addBio(doc['bio']);
      users.add(user);
    }

    return users;
  }
}
