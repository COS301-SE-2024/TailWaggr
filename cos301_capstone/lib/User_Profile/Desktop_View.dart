// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/Pets/Pet_Profile.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class ProfileDesktop extends StatefulWidget {
  const ProfileDesktop({Key? key}) : super(key: key);

  @override
  State<ProfileDesktop> createState() => _ProfileDesktopState();
}

class _ProfileDesktopState extends State<ProfileDesktop> {
  @override
  void initState() {
    super.initState();
    profileDetails.isEditing.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DesktopNavbar(),
          Container(
            width: MediaQuery.of(context).size.width - (themeSettings.searchVisible ? 550 : 250),
            color: themeSettings.backgroundColor,
            padding: EdgeInsets.all(20),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 20,
                color: themeSettings.textColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: AboutMeContainer(),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        MyPetsContainer(),
                        SizedBox(height: 20),
                        PostsContainer(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostsContainer extends StatefulWidget {
  const PostsContainer({super.key});

  @override
  State<PostsContainer> createState() => _PostsContainerState();
}

class _PostsContainerState extends State<PostsContainer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2, // This sets the flex to 2/3rds
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeSettings.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Posts",
                style: TextStyle(
                  fontSize: subHeadingTextSize,
                  color: themeSettings.primaryColor,
                ),
              ),
              Divider(),
              ListOfPosts(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfPosts extends StatelessWidget {
  const ListOfPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var post in profileDetails.myPosts) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 175,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        post["ImgUrl"],
                        height: 125,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post["Content"],
                          style: TextStyle(fontSize: bodyTextSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        if (post['PetIds'].length > 0) Text("Included pets:", style: TextStyle(fontSize: subBodyTextSize)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            for (var includedPet in post["PetIds"]) ...[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(includedPet['pictureUrl']),
                                    ),
                                    Text(includedPet['name'], style: TextStyle(fontSize: textSize)),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AboutMeContainer extends StatefulWidget {
  const AboutMeContainer({super.key});

  @override
  State<AboutMeContainer> createState() => _AboutMeContainerState();
}

class _AboutMeContainerState extends State<AboutMeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeSettings.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(profileDetails.profilePicture),
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${profileDetails.name} ${profileDetails.surname}", style: TextStyle(fontSize: subHeadingTextSize)),
                Text(profileDetails.bio, style: TextStyle(fontSize: subBodyTextSize)),
                SizedBox(height: 20),
                OpenContainer(
                  transitionDuration: Duration(milliseconds: 300),
                  closedBuilder: (context, action) {
                    return Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: themeSettings.primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                  closedColor: Colors.transparent,
                  closedElevation: 0,
                  openBuilder: (context, action) {
                    return EditProfile();
                  },
                ),
                SizedBox(height: 20),
                Text("Profile Details", style: TextStyle(fontSize: bodyTextSize, color: themeSettings.primaryColor)),
                Divider(),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.primaryColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined, color: themeSettings.textColor.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          profileDetails.email,
                          style: TextStyle(fontSize: subBodyTextSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.primaryColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: themeSettings.textColor.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          profileDetails.phone,
                          style: TextStyle(fontSize: subBodyTextSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.primaryColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month, color: themeSettings.textColor.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          profileDetails.birthdate,
                          style: TextStyle(fontSize: subBodyTextSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.primaryColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.home, color: themeSettings.textColor.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          profileDetails.location,
                          style: TextStyle(fontSize: subBodyTextSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text("User type", style: TextStyle(fontSize: bodyTextSize, color: themeSettings.primaryColor)),
                Divider(),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.primaryColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.pets, color: themeSettings.textColor.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Text("Pet enthusiast", style: TextStyle(fontSize: subBodyTextSize)),
                    ],
                  ),
                ),
                if (profileDetails.userType == "Veterinarian")
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: themeSettings.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: themeSettings.primaryColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.medical_services, color: themeSettings.textColor.withOpacity(0.5)),
                        SizedBox(width: 10),
                        Text("Veterinarian", style: TextStyle(fontSize: subBodyTextSize)),
                      ],
                    ),
                  ),
                if (profileDetails.userType == "PetKeeper")
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: themeSettings.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: themeSettings.primaryColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.medical_services, color: themeSettings.textColor.withOpacity(0.5)),
                        SizedBox(width: 10),
                        Text("Pet sitter", style: TextStyle(fontSize: subBodyTextSize)),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyPetsContainer extends StatefulWidget {
  const MyPetsContainer({super.key});

  @override
  State<MyPetsContainer> createState() => _MyPetsContainerState();
}

class _MyPetsContainerState extends State<MyPetsContainer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2, // This sets the flex to 1/3rd
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeSettings.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Pets",
                style: TextStyle(
                  fontSize: subHeadingTextSize,
                  color: themeSettings.primaryColor,
                ),
              ),
              Divider(),
              for (var pet in profileDetails.pets) ...[
                OpenContainer(
                  transitionDuration: Duration(milliseconds: 300),
                  closedBuilder: (context, action) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),

                        child: PetProfileButton(
                          petName: pet["name"],
                          petBio: pet["bio"],
                          petPicture: pet["pictureUrl"],
                        ),
                      ),
                    );
                  },
                  closedColor: Colors.transparent,
                  closedElevation: 0,
                  openBuilder: (context, action) {
                    return PetProfile(
                      creatingNewPet: false,
                      petName: pet["name"],
                      petBio: pet["bio"],
                      petBirthdate: pet["birthDate"],
                      petProfilePicture: pet["pictureUrl"],
                      petID: pet["petID"],
                    );
                  },
                ),
              ],
              SizedBox(height: 20),
              OpenContainer(
                transitionDuration: Duration(milliseconds: 300),
                closedBuilder: (context, action) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: DottedBorder(
                      padding: EdgeInsets.all(20),
                      borderType: BorderType.RRect,
                      radius: Radius.circular(100),
                      color: themeSettings.textColor,
                      strokeWidth: 0.5,
                      dashPattern: [5, 5], // Modify the dash pattern to make the border more spread out
                      child: Row(
                        children: [
                          Icon(Icons.add, color: themeSettings.primaryColor, size: 30),
                          SizedBox(width: 10),
                          Text(
                            "Add a new pet to your family",
                            style: TextStyle(color: themeSettings.textColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                closedColor: Colors.transparent,
                closedElevation: 0,
                openBuilder: (context, action) {
                  return PetProfile(
                    creatingNewPet: true,
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class PetProfileButton extends StatefulWidget {
  const PetProfileButton({Key? key, required this.petName, required this.petBio, required this.petPicture}) : super(key: key);

  final String petName;
  final String petBio;
  final String petPicture;

  @override
  State<PetProfileButton> createState() => _PetProfileButtonState();
}

class _PetProfileButtonState extends State<PetProfileButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(widget.petPicture),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.petName,
                style: TextStyle(fontSize: subHeadingTextSize, color: themeSettings.textColor),
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(height: 8),
              Text(
                widget.petBio,
                style: TextStyle(fontSize: subBodyTextSize, color: themeSettings.textColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
