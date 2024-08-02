// ignore_for_file: must_be_immutable

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Pets/Pet_Profile.dart';
import 'package:flutter/material.dart';

class PetProfileDesktop extends StatefulWidget {
  PetProfileDesktop({
    super.key,
    required this.creatingNewPet,
  });

  final bool creatingNewPet;

  @override
  State<PetProfileDesktop> createState() => _PetProfileDesktopState();
}

class _PetProfileDesktopState extends State<PetProfileDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSettings.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeSettings.backgroundColor,
        iconTheme: IconThemeData(color: themeSettings.primaryColor),
      ),
      body: Center(
        child: Container(
          width: 600,
          // height: 600,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeSettings.cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.creatingNewPet ? 'Create Your Pets Profile' : 'Update your pets profile',
                style: TextStyle(color: themeSettings.primaryColor, fontSize: subtitleTextSize),
              ),
              if (widget.creatingNewPet) ...[
                Text(
                  'Please fill in the details below to create your pets profile',
                  style: TextStyle(
                    color: themeSettings.textColor,
                    fontSize: bodyTextSize,
                  ),
                ),
                Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          PetProfileVariables.imagePicker.pickFiles();
                        },
                        child: CircleAvatar(
                          radius: 75,
                          // backgroundImage: AssetImage("assets/images/profile.jpg"),
                          backgroundImage: NetworkImage(""),
                        ),
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
                            controller: PetProfileVariables.nameController,
                            decoration: InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(
                              color: themeSettings.textColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 370,
                          child: TextField(
                            controller: PetProfileVariables.bioController,
                            decoration: InputDecoration(
                              labelText: "Bio",
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(
                              color: themeSettings.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              Text('Pet Name: ${PetProfileVariables.nameController.text}'),
              Text('Pet Bio: ${PetProfileVariables.bioController.text}'),
            ],
          ),
        ),
      ),
    );
  }
}
