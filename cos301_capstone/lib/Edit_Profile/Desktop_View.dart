
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditProfileDesktop extends StatefulWidget {
  const EditProfileDesktop({super.key});

  @override
  State<EditProfileDesktop> createState() => _EditProfileDesktopState();
}

class _EditProfileDesktopState extends State<EditProfileDesktop> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 600,
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.only(bottom: 60, top: 5),
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
              Text("Edit Profile"),
              SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {} catch (e) {
                        print("Error: $e");
                      }
                    },
                    child: CircleAvatar(
                      radius: 75,
                      // backgroundImage: AssetImage("assets/images/profile.jpg"),
                      backgroundImage: NetworkImage(profileDetails.profilePicture),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 370,
                        child: TextField(
                          controller: EditProfileVariables.nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 370,
                        child: TextField(
                          controller: EditProfileVariables.surnameController,
                          decoration: InputDecoration(
                            labelText: "Surname",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
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
                  dialCode: profileDetails.dialCode,
                  isoCode: profileDetails.isoCode,
                  phoneNumber: profileDetails.phone,
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
                onPressed: () async {
                  setState(() {
                    profileDetails.Name = EditProfileVariables.nameController.text;
                    profileDetails.Surname = EditProfileVariables.surnameController.text;
                    profileDetails.Bio = EditProfileVariables.bioController.text;
                    profileDetails.Location = EditProfileVariables.addressController.text;
                  });
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                ),
                child: Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: bodyTextSize,
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
