// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:io';

import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditProfileMobile extends StatefulWidget {
  const EditProfileMobile({super.key});

  @override
  State<EditProfileMobile> createState() => _EditProfileMobileState();
}

class _EditProfileMobileState extends State<EditProfileMobile> {
  String? _imagePath;

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          _imagePath = result.files.single.path;
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        print("Open File Picker");
                        FilePickerResult? result = await FilePicker.platform.pickFiles();

                        if (result != null) {
                          File file = File(result.files.single.path!);
                        } else {
                          // User canceled the picker
                          print("User Canceled");
                        }
                      } catch (e) {
                        print("Error: $e");
                      }
                    },
                    child: CircleAvatar(
                      radius: 75,
                      // backgroundImage: AssetImage("assets/images/profile.jpg"),
                      backgroundImage: NetworkImage(profileDetails.ProfilePicture),
                    ),
                  ),
                  SizedBox(width: 20),
                  TextField(
                    controller: EditProfileVariables.nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: EditProfileVariables.surnameController,
                    decoration: InputDecoration(
                      labelText: "Surname",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: EditProfileVariables.bioController,
                decoration: InputDecoration(
                  labelText: "Bio",
                  border: OutlineInputBorder(),
                ),
                maxLines: null, // Allow the field to expand
              ),
              SizedBox(height: 20),
              TextField(
                controller: EditProfileVariables.emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              SizedBox(height: 20),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  useBottomSheetSafeArea: true,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                // selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: PhoneNumber(
                  dialCode: profileDetails.DialCode,
                  isoCode: profileDetails.isoCode,
                  phoneNumber: profileDetails.Phone,
                ),
                textFieldController: EditProfileVariables.phoneController,
                formatInput: true,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                inputBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: EditProfileVariables.addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(themeSettings.Primary_Colour),
                ),
                child: Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: Body_Text_Size,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
