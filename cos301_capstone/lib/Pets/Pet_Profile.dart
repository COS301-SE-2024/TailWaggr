// ignore_for_file: file_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/Pets/PetProfileDesktop.dart';
import 'package:cos301_capstone/Pets/PetProfileMobile.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PetProfileVariables {
  static TextEditingController nameController = TextEditingController();
  static TextEditingController bioController = TextEditingController();
  static TextEditingController birthdateController = TextEditingController();
  static DateTime? birthdate;
  static String? petId;

  static ImagePicker imagePicker = ImagePicker();
  static String? profilePicture;

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
        'birthdate': birthdate,
        'profilePicture': profilePicture,
      },
    );
  }

  static Future<void> updatePet(bool usingNewImage) async {
    print("Updating pet profile");
    print("Pet ID: $petId");
    print("Name: ${nameController.text}");
    print("Bio: ${bioController.text}");
    print("Birthdate: $birthdate");
    await ProfileService().updatePet(
      profileDetails.userID,
      petId!,
      {
        'name': nameController.text,
        'bio': bioController.text,
        'birthDate': birthdate,
      },
      usingNewImage ? PetProfileVariables.imagePicker.filesNotifier.value![0] : null,
    );
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
