// ignore_for_file: file_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/Pets/PetProfileDesktop.dart';
import 'package:cos301_capstone/Pets/PetProfileMobile.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PetProfileVariables {
  static TextEditingController nameController = TextEditingController();
  static TextEditingController bioController = TextEditingController();
  static TextEditingController birthdateController = TextEditingController();
  static DateTime? birthdate;
  static String? petId;

  static ImagePicker imagePicker = ImagePicker();
  static String? profilePicture;

  static ValueNotifier<int> petEditted = ValueNotifier<int>(0);

  static void setBirthDateControllers(Object? p0) {
    birthdate = p0 as DateTime;

    birthdateController.text = "${p0.day} ${getMonthAbbreviation(p0.month)} ${p0.year}";
  }

  static String getFormattedDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = getMonthAbbreviation(date.month);
    String year = date.year.toString();
    return '$day $month $year';
  }

  static Future<void> createPet() async {
    await ProfileService().addPet(
      profileDetails.userID,
      {
        'name': nameController.text,
        'bio': bioController.text,
        'birthDate': birthdate,
      },
      imagePicker.filesNotifier.value![0],
    );

    Future<List<Map<String, dynamic>>> pets = GeneralService().getUserPets(profileDetails.userID);
    pets.then((value) {
      profileDetails.pets = value;
    });

    petEditted.value++;
  }

  static Future<void> updatePet(bool usingNewImage) async {
    Map<String, dynamic> petData = {
      'name': nameController.text,
      'bio': bioController.text,
    };

    if (birthdate != null) {
      petData['birthDate'] = birthdate;
    }
    await ProfileService().updatePet(
      profileDetails.userID,
      petId!,
      petData,
      usingNewImage ? PetProfileVariables.imagePicker.filesNotifier.value![0] : null,
    );

    Future<List<Map<String, dynamic>>> pets = GeneralService().getUserPets(profileDetails.userID);
    pets.then((value) {
      profileDetails.pets = value;
    });

    petEditted.value++;
  }

  static Future<void> deletePet() async {
    await ProfileService().deletePet(profileDetails.userID, petId!);

    

    petEditted.value++;
  }
}

class PetProfile extends StatefulWidget {
  PetProfile({
    super.key,
    required this.creatingNewPet,
    this.petName,
    this.petBio,
    this.petBirthdate,
    this.petProfilePicture,
    this.petID,
  });

  final bool creatingNewPet;
  String? petName;
  String? petBio;
  Timestamp? petBirthdate;
  String? petProfilePicture;
  String? petID;

  @override
  State<PetProfile> createState() => _PetProfileState();
}

class _PetProfileState extends State<PetProfile> {
  @override
  void initState() {
    super.initState();
    PetProfileVariables.nameController.text = widget.petName ?? '';
    PetProfileVariables.bioController.text = widget.petBio ?? '';
    if (widget.petBirthdate != null) {
      PetProfileVariables.birthdate = widget.petBirthdate?.toDate();
      PetProfileVariables.birthdateController.text = PetProfileVariables.getFormattedDate(widget.petBirthdate?.toDate() ?? DateTime.now());
    }
    PetProfileVariables.profilePicture = widget.petProfilePicture;
    PetProfileVariables.petId = widget.petID;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return PetProfileDesktop(
            creatingNewPet: widget.creatingNewPet,
          );
        } else {
          return Scaffold(
            body: PetProfileMobile(
              creatingNewPet: widget.creatingNewPet,
            ),
          );
        }
      },
    );
  }
}
