// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/material.dart';

class ProfileMobile extends StatefulWidget {
  const ProfileMobile({Key? key}) : super(key: key);

  @override
  State<ProfileMobile> createState() => _ProfileMobileState();
}

class _ProfileMobileState extends State<ProfileMobile> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 20,
        color: themeSettings.Text_Colour,
      ),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AbouMeContainer(),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
class AbouMeContainer extends StatefulWidget {
  const AbouMeContainer({super.key});

  @override
  State<AbouMeContainer> createState() => _AbouMeContainerState();
}

class _AbouMeContainerState extends State<AbouMeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeSettings.Card_Colour,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: themeSettings.Text_Colour.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(profileDetails.ProfilePicture),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(profileDetails.Name, style: TextStyle(fontSize: Sub_Heading_Text_Size)),
                  Text(profileDetails.Bio, style: TextStyle(fontSize: Sub_Body_Text_Size)),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Edit Profile
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeSettings.Primary_Colour,
                ),
                child: Text("Edit Profile", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              // Text("Profile Details", style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Primary_Colour)),
              // Divider(),
              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Icon(Icons.email_outlined, color: themeSettings.Text_Colour.withOpacity(0.5)),
              //     SizedBox(width: 10),
              //     Flexible(
              //       child: Text(
              //         profileDetails.Email,
              //         style: TextStyle(fontSize: Sub_Body_Text_Size),
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //     ),
              //   ],
              // ),
              // Container(
              //   padding: EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: themeSettings.Card_Colour,
              //     borderRadius: BorderRadius.circular(10),
              //     // border: Border.all(color: themeSettings.Primary_Colour),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(Icons.phone, color: themeSettings.Text_Colour.withOpacity(0.5)),
              //       SizedBox(width: 10),
              //       Flexible(
              //         child: Text(
              //           profileDetails.Phone,
              //           style: TextStyle(fontSize: Sub_Body_Text_Size),
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: themeSettings.Card_Colour,
              //     borderRadius: BorderRadius.circular(10),
              //     // border: Border.all(color: themeSettings.Primary_Colour),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(Icons.calendar_month, color: themeSettings.Text_Colour.withOpacity(0.5)),
              //       SizedBox(width: 10),
              //       Flexible(
              //         child: Text(
              //           profileDetails.Birthdate,
              //           style: TextStyle(fontSize: Sub_Body_Text_Size),
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: themeSettings.Card_Colour,
              //     borderRadius: BorderRadius.circular(10),
              //     // border: Border.all(color: themeSettings.Primary_Colour),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(Icons.home, color: themeSettings.Text_Colour.withOpacity(0.5)),
              //       SizedBox(width: 10),
              //       Flexible(
              //         child: Text(
              //           profileDetails.Location,
              //           style: TextStyle(fontSize: Sub_Body_Text_Size),
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20),
              // Text("User type", style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Primary_Colour)),
              // Container(
              //   padding: EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: themeSettings.Card_Colour,
              //     borderRadius: BorderRadius.circular(10),
              //     // border: Border.all(color: themeSettings.Primary_Colour),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(Icons.pets, color: themeSettings.Text_Colour.withOpacity(0.5)),
              //       SizedBox(width: 10),
              //       Text("Pet enthusiast", style: TextStyle(fontSize: Sub_Body_Text_Size)),
              //     ],
              //   ),
              // ),
              // if (profileDetails.UserType == "Veterinarian")
              //   Container(
              //     padding: EdgeInsets.all(8),
              //     decoration: BoxDecoration(
              //       color: themeSettings.Card_Colour,
              //       borderRadius: BorderRadius.circular(10),
              //       // border: Border.all(color: themeSettings.Primary_Colour),
              //     ),
              //     child: Row(
              //       children: [
              //         Icon(Icons.medical_services, color: themeSettings.Text_Colour.withOpacity(0.5)),
              //         SizedBox(width: 10),
              //         Text("Veterinarian", style: TextStyle(fontSize: Sub_Body_Text_Size)),
              //       ],
              //     ),
              //   ),
              // if (profileDetails.UserType == "PetKeeper")
              //   Container(
                //   padding: EdgeInsets.all(8),
                //   decoration: BoxDecoration(
                //     color: themeSettings.Card_Colour,
                //     borderRadius: BorderRadius.circular(10),
                //     // border: Border.all(color: themeSettings.Primary_Colour),
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(Icons.medical_services, color: themeSettings.Text_Colour.withOpacity(0.5)),
                //       SizedBox(width: 10),
                //       Text("Pet sitter", style: TextStyle(fontSize: Sub_Body_Text_Size)),
                //     ],
                //   ),
                // ),
            ],
          )
        ],
      ),
    );
  }
}
