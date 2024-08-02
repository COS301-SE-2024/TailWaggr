// ignore_for_file: file_names, must_be_immutable

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

  static ImagePicker imagePicker = ImagePicker();
  static String? profilePicture;

  static void setPetDetails() {
    nameController.text = profileDetails.name;
    bioController.text = profileDetails.bio;
    birthdateController.text = profileDetails.birthdate;
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
  });

  final bool creatingNewPet;
  String? petName;
  String? petBio;
  String? petBirthdate;
  String? petProfilePicture;

  @override
  State<PetProfile> createState() => _PetProfileState();
}

class _PetProfileState extends State<PetProfile> {
  @override
  void initState() {
    super.initState();
    PetProfileVariables.nameController.text = widget.petName ?? '';
    PetProfileVariables.bioController.text = widget.petBio ?? '';
    PetProfileVariables.birthdateController.text = widget.petBirthdate ?? '';
    PetProfileVariables.profilePicture = widget.petProfilePicture;
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
