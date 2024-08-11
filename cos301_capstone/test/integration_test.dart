import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'mocks.mocks.dart'; // Import the generated mocks

void main() {
  late GeneralService generalService;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseStorage mockStorage;
  late CollectionReference<Map<String, dynamic>> mockCollectionReference;
  late DocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;
  late MockReference mockReference;
  late MockTaskSnapshot mockTaskSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockReference = MockReference();
    mockTaskSnapshot = MockTaskSnapshot();

    generalService = GeneralService(db: mockFirestore, storage: mockStorage);

    // Stubbing Firestore calls
    when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockDocumentReference.collection('pets')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
    when(mockQueryDocumentSnapshot.data()).thenReturn({'name': 'Merlin'});
    when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);

    // Stubbing Firebase Storage calls
    when(mockStorage.ref(any)).thenReturn(mockReference);
    when(mockReference.delete()).thenAnswer((_) async => mockTaskSnapshot);
  });

  group('GeneralService', () {
    test('getUserPets returns list of pets', () async {
      final result = await generalService.getUserPets('QF5gHocYeGRNbsFmPE3RjUZIId82');
      // Verify Firestore calls
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollectionReference.doc('QF5gHocYeGRNbsFmPE3RjUZIId82')).called(1);
      verify(mockDocumentReference.collection('pets')).called(1);
      verify(mockCollectionReference.get()).called(1);

      // Check result
      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result, isNotEmpty);
      expect(result.first, isA<Map<String, dynamic>>());
      expect(result.first['name'], 'Merlin');
    });

    test('getPetById returns pet data if exists', () async {
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn({'name': 'Merlin'});
      final result = await generalService.getPetById('QF5gHocYeGRNbsFmPE3RjUZIId82', 'RGeqrusnbA2C7xJmGLeg');
      // Verify Firestore calls
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollectionReference.doc('QF5gHocYeGRNbsFmPE3RjUZIId82')).called(1);
      verify(mockDocumentReference.collection('pets')).called(1);
      verify(mockCollectionReference.doc('RGeqrusnbA2C7xJmGLeg')).called(1);
      verify(mockDocumentReference.get()).called(1);

      // Check result
      expect(result, isA<Map<String, dynamic>>());
      expect(result!['name'], 'Merlin');
    });

    test('deleteImageFromStorage deletes image successfully', () async {
      await generalService.deleteImageFromStorage('path/to/image.jpg');

      // Verify Storage calls
      verify(mockStorage.ref('path/to/image.jpg')).called(1);
      verify(mockReference.delete()).called(1);
    });
  });
}