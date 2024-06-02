// ignore_for_file: file_names

import 'package:cos301_capstone/Edit_Profile/Desktop_View.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Edit_Profile/Mobile_View.dart';
import 'package:flutter/material.dart';

class EditProfileVariables {
  static TextEditingController nameController = TextEditingController();
  static TextEditingController surnameController = TextEditingController();
  static TextEditingController bioController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController addressController = TextEditingController();
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    EditProfileVariables.nameController.text = profileDetails.Name;
    EditProfileVariables.surnameController.text = profileDetails.Surname;
    EditProfileVariables.bioController.text = profileDetails.Bio;
    EditProfileVariables.emailController.text = profileDetails.Email;
    EditProfileVariables.phoneController.text = profileDetails.Phone;
    EditProfileVariables.addressController.text = profileDetails.Location;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1000) {
          return const Scaffold(
            body: EditProfileDesktop(),
          );
        } else {
          return const Scaffold(
            body: EditProfileMobile(),
          );
        }
      },
    );
  }
}
