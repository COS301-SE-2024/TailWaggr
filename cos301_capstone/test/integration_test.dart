import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'package:cos301_capstone/services/HomePage/home_page_service.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:cos301_capstone/services/Notifications/notifications.dart';
import 'package:cos301_capstone/services/Location/location_service.dart';
import 'package:cos301_capstone/services/forum/forum.dart';
import 'mocks.mocks.dart'; // Import the generated mocks

void main(){
  // TestWidgetsFlutterBinding.ensureInitialized();
  late GeneralService generalService;
  late HomePageService homePageService;
  late ProfileService profileService;
  late NotificationsServices notificationsServices;
  late LocationService locationService;
  late ForumServices forumService;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseStorage mockStorage;
  late CollectionReference<Map<String, dynamic>> mockCollectionReference;
  late DocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;
  late MockReference mockReference;
  late MockTaskSnapshot mockTaskSnapshot;

  setUpAll(() async {
      // await Firebase.initializeApp();
    });

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
    // homePageService = HomePageService(db: mockFirestore, storage: mockStorage);
    profileService = ProfileService(db: mockFirestore, storage: mockStorage);
    notificationsServices = NotificationsServices(db: mockFirestore);
    locationService = LocationService(firestore: mockFirestore);
    // forumService = ForumServices(db: mockFirestore);

    // Stubbing Firestore calls
    when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockDocumentReference.collection('pets')).thenReturn(mockCollectionReference);
    when(mockDocumentReference.collection('notifications')).thenReturn(mockCollectionReference);
    when(mockDocumentReference.collection('messages')).thenReturn(mockCollectionReference);
    when(mockDocumentReference.collection('forum')).thenReturn(mockCollectionReference);
    when(mockFirestore.collection('forum')).thenReturn(mockCollectionReference);
    when(mockFirestore.collection('posts')).thenReturn(mockCollectionReference);
    when(mockFirestore.collection('profile')).thenReturn(mockCollectionReference);
    when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
    // Stubbing Firebase Storage calls
    when(mockStorage.ref(any)).thenReturn(mockReference);
    when(mockReference.delete()).thenAnswer((_) async => mockTaskSnapshot);
  });

  group('GeneralService', () {
    test('getUserPets returns list of pets', () async {
      when(mockQueryDocumentSnapshot.data()).thenReturn({'name': 'Merlin'});
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

  // group('HomePageService', () {
  //   String postId = '5KnN9GatvW0Dka9j8Dmv';
  //   test('addPost adds post successfully', () async {
  //     final platformFile = PlatformFile(
  //       name: 'test.txt',
  //       size: 1024,
  //       bytes: Uint8List.fromList([/* file bytes here */]),
  //     );
  //     List<Map<String, dynamic>> petIds = [
  //       {'id': 'RGeqrusnbA2C7xJmGLeg'},
  //     ];
  //     final result = await homePageService.addPost('Hello, world', platformFile, "Hello World", petIds);
  //     // Verify Firestore calls
  //     verify(mockFirestore.collection('posts')).called(1);
  //     verify(mockCollectionReference.doc(any)).called(1);
  //     // Check result
  //     expect(result, true);
  //   });
  // });
  group('ProfileService', () {
    test('getUserDetails returns user data if exists', () async {
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn({'name': 'John Doe'});
      final result = await profileService.getUserDetails('QF5gHocYeGRNbsFmPE3RjUZIId82');
      // Verify Firestore calls
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollectionReference.doc('QF5gHocYeGRNbsFmPE3RjUZIId82')).called(1);
      verify(mockDocumentReference.get()).called(1);

      // Check result
      expect(result, isA<Map<String, dynamic>>());
      expect(result!['name'], 'John Doe');
    });
  });
  group('NotificationsServices', () {
  });
  group('LocationService', () {
  });
  group('ForumServices', () {
  });
}