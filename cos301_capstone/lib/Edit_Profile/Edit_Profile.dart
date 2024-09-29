// ignore_for_file: file_names

import 'dart:ui';

import 'package:cos301_capstone/Edit_Profile/Desktop_View.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Edit_Profile/Mobile_View.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:cos301_capstone/services/imageApi/imageFilter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> themeModeNotifier = ValueNotifier<int>(0);
late Color primaryColor;
late Color secondaryColor;
late Color backgroundColor;
late Color textColor;
late Color cardColor;
late Color navbarTextColor;

class EditProfileVariables {
  static TextEditingController nameController = TextEditingController();
  static TextEditingController surnameController = TextEditingController();
  static TextEditingController bioController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController addressController = TextEditingController();
  static TextEditingController birthdateController = TextEditingController();
  static DateTime? birthdate;
  static ImageFilter imageFilter = ImageFilter();

  static void setBirthDateControllers(Object? p0) {
    print("Selected date: $p0");
    EditProfileVariables.birthdate = p0 as DateTime;

    EditProfileVariables.birthdateController.text = "${p0.day} ${getMonthAbbreviation(p0.month)} ${p0.year}";
    profileDetails.birthdate = "${p0.day} ${getMonthAbbreviation(p0.month)} ${p0.year}";
  }

  static Future<void> updatePersonalDetails(context, imagePicker) async {
    profileDetails.name = EditProfileVariables.nameController.text;
    profileDetails.surname = EditProfileVariables.surnameController.text;
    profileDetails.bio = EditProfileVariables.bioController.text;
    profileDetails.location = EditProfileVariables.addressController.text;

    PlatformFile? newProfileImage;

    if (imagePicker.filesNotifier.value != null && imagePicker.filesNotifier.value!.isNotEmpty) {
      newProfileImage = imagePicker.filesNotifier.value![0];
    }
    //moderate image
    if (newProfileImage != null) {
    Map<String, dynamic> moderationResult = await imageFilter.moderateImage(imagePicker.filesNotifier.value![0]);
    print("Moderation result: $moderationResult");
    //create dialog box for moderation
    if (moderationResult['status'] == 'error') {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(moderationResult['message']),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    } else if (moderationResult['status'] == 'fail') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent, // Customize color if needed
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "🔞 Warning!",  // Title
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: themeSettings.textColor, // Customize text color
                ),
              ),
              SizedBox(height: 8),
              Text(
                moderationResult['message'],  // Full message
                style: TextStyle(color: themeSettings.textColor), // Customize text color
              ),
            ],
          ),
          duration: Duration(seconds: 20),  // Increase the duration if needed
          behavior: SnackBarBehavior.floating,  // Makes the snackbar floating
        ),
      );
      //prevent the post from being uploaded
      //stop image from being uploaded
      return;}
      else{
        //image is safe to upload
        print("Image is safe to upload");
      }
                    
    }
    print("Birthdate: ${EditProfileVariables.birthdate}");

    Map<String, dynamic> jsonData = {
      'name': profileDetails.name,
      'surname': profileDetails.surname,
      'bio': profileDetails.bio,
      'location': profileDetails.location,
      'phoneDetails': {
        'dialCode': profileDetails.dialCode,
        'isoCode': profileDetails.isoCode,
        'phoneNumber': profileDetails.phone,
      },
    };

    if (EditProfileVariables.birthdate != null) {
      jsonData['birthDate'] = EditProfileVariables.birthdate;
    }

    await ProfileService().updateProfile(
      profileDetails.userID,
      jsonData,
      newProfileImage,
      null,
    );

    profileDetails.isEditing.value++;
    Navigator.pop(context);
  }

  static Future<void> setNavbarPreferences(bool usingImage, bool usingDefaultImage) async {
    PlatformFile? sidebarImage;

    if (imagePicker.filesNotifier.value != null && imagePicker.filesNotifier.value!.isNotEmpty) {
      sidebarImage = imagePicker.filesNotifier.value![0];
    }

    await ProfileService().updateProfile(
      profileDetails.userID,
      {
        'preferences': {
          'themeMode': "Custom",
          'Colours': {
            'PrimaryColour': primaryColor.value,
            'SecondaryColour': secondaryColor.value,
            'BackgroundColour': backgroundColor.value,
            'TextColour': textColor.value,
            'CardColour': cardColor.value,
            'NavbarTextColour': navbarTextColor.value,
          },
          'usingImage': usingImage,
          'usingDefaultImage': usingDefaultImage,
        },
      },
      null,
      usingImage && !usingDefaultImage ? sidebarImage : null,
    );

    profileDetails.isEditing.value++;
  }
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
    EditProfileVariables.nameController.text = profileDetails.name;
    EditProfileVariables.surnameController.text = profileDetails.surname;
    EditProfileVariables.bioController.text = profileDetails.bio;
    EditProfileVariables.emailController.text = profileDetails.email;
    EditProfileVariables.phoneController.text = profileDetails.phone;
    EditProfileVariables.addressController.text = profileDetails.location;
    EditProfileVariables.birthdateController.text = profileDetails.birthdate;

    setState(() {
      primaryColor = themeSettings.primaryColor;
      secondaryColor = themeSettings.secondaryColor;
      backgroundColor = themeSettings.backgroundColor;
      textColor = themeSettings.textColor;
      cardColor = themeSettings.cardColor;
      navbarTextColor = themeSettings.navbarTextColour;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return EditProfileDesktop();
        } else {
          return const Scaffold(
            body: EditProfileMobile(),
          );
        }
      },
    );
  }
}
