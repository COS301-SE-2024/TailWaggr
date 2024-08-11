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
import 'package:mockito/mockito.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseStorage extends Mock implements FirebaseStorage {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockReference extends Mock implements Reference {}
class MockTaskSnapshot extends Mock implements TaskSnapshot {}

void main() {
  late GeneralService generalService;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseStorage mockStorage;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
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
  });

  group('GeneralService', () {
    test('getUserPets returns list of pets', () async {
      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('pets')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn({'name': 'Merlin'});

      final pets = await generalService.getUserPets('userId');

      expect(pets, isA<List<Map<String, dynamic>>>());
      expect(pets.length, 1);
      expect(pets[0]['name'], 'Merlin');
    });

    test('getPetById returns pet data if exists', () async {
      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('pets')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn({'name': 'Merlin'});

      final pet = await generalService.getPetById('userId', 'petId');

      expect(pet, isA<Map<String, dynamic>>());
      expect(pet!['name'], 'Merlin');
    });

    test('getPetById returns null if pet does not exist', () async {
      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('pets')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(false);

      final pet = await generalService.getPetById('userId', 'petId');

      expect(pet, isNull);
    });

    test('deleteImageFromStorage deletes image successfully', () async {
      when(mockStorage.ref(any)).thenReturn(mockReference);
      when(mockReference.delete()).thenAnswer((_) async => null);

      await generalService.deleteImageFromStorage('filePath');

      verify(mockReference.delete()).called(1);
    });
  });
}