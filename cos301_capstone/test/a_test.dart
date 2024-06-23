import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cos301_capstone/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'package:cos301_capstone/services/profile/profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('integration tests', () {
    testWidgets('help',
        (tester) async {
      // User data
      Future<Map<String, dynamic>?> pets = ProfileService().getUserProfile("QF5gHocYeGRNbsFmPE3RjUZIId82");
    });
  });
}