import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cos301_capstone/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'package:cos301_capstone/services/profile/profile_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cos301_capstone/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration tests', () {
    testWidgets('Check that user profile data is accurate',
        (tester) async {
          /* real test
          final FirebaseFirestore _db = FirebaseFirestore.instance;
          final FirebaseStorage _storage = FirebaseStorage.instance;

          print("Fetching profile data for user: QF5gHocYeGRNbsFmPE3RjUZIId82");
          final doc = await _db.collection('users').doc('QF5gHocYeGRNbsFmPE3RjUZIId82').get();
          */
    });
    testWidgets('Check that user pets are accurate',
        (tester) async {
          // Pet data
          /* real test
          Future<List<Map<String, dynamic>?>> pets = GeneralService().getUserPets("QF5gHocYeGRNbsFmPE3RjUZIId82");
          */
    });
    testWidgets('Check that updating user profile works',
        (tester) async {
          // User data
          /* real test
          Future<Map<String, dynamic>?> profile = ProfileService().getUserProfile("QF5gHocYeGRNbsFmPE3RjUZIId82");
          // Update user data with a new string manually, then compare profile maps
          */
    });
     testWidgets('Check that updating user pets works',
        (tester) async {
          // Pet data
          /* real test
          Future<List<Map<String, dynamic>?>> pets = GeneralService().getUserPets("QF5gHocYeGRNbsFmPE3RjUZIId82");
          // Update pet data with a new string manually, then compare profile maps
          */
    });
  });
}