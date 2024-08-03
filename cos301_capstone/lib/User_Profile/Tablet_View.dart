// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animations/animations.dart';
import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/Pets/Pet_Profile.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ProfileTablet extends StatefulWidget {
  const ProfileTablet({Key? key}) : super(key: key);

  @override
  State<ProfileTablet> createState() => _ProfileTabletState();
}

class _ProfileTabletState extends State<ProfileTablet> {
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
            color: ThemeSettings.backgroundColor,
            padding: EdgeInsets.all(20),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 20,
                color: ThemeSettings.textColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AboutMeContainer(),
                  SizedBox(height: 20),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        DetailsContainer(),
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
        color: ThemeSettings.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ThemeSettings.textColor.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.1,
            backgroundImage: NetworkImage(profileDetails.profilePicture),
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profileDetails.name} ${profileDetails.surname}',
                  style: TextStyle(fontSize: subHeadingTextSize),
                ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsContainer extends StatefulWidget {
  const DetailsContainer({super.key});

  @override
  State<DetailsContainer> createState() => _DetailsContainerState();
}

class _DetailsContainerState extends State<DetailsContainer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2, // This sets the flex to 2/3rds
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThemeSettings.cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: ThemeSettings.textColor.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline),
                        SizedBox(width: 10),
                        Text("Details"),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pets_outlined),
                        SizedBox(width: 10),
                        Text("Pets"),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_box_outlined),
                        SizedBox(width: 10),
                        Text("Posts"),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: TabBarView(
                  children: [
                    PersonalDetailsContainer(),
                    MyPetsContainer(),
                    PostsContainer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalDetailsContainer extends StatefulWidget {
  const PersonalDetailsContainer({super.key});

  @override
  State<PersonalDetailsContainer> createState() => _PersonalDetailsContainerState();
}

class _PersonalDetailsContainerState extends State<PersonalDetailsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: themeSettings.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Personal Information", style: TextStyle(fontSize: bodyTextSize, color: themeSettings.primaryColor)),
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
  Widget petProfileButton(String petName, String petBio, String petPicture) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(petPicture),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                petName,
                style: TextStyle(fontSize: subHeadingTextSize, color: themeSettings.textColor),
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(height: 8),
              Text(
                petBio,
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

  @override
  void initState() {
    super.initState();
    print("State being called");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var pet in profileDetails.pets) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: OpenContainer(
                transitionDuration: Duration(milliseconds: 300),
                closedBuilder: (context, action) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: petProfileButton(
                        pet["name"],
                        pet["bio"],
                        pet["pictureUrl"],
                      ),
                    ),
                  );
                },
                closedColor: Colors.transparent,
                closedElevation: 0,
                openBuilder: (context, action) {
                  print(pet);
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
    );
  }
}

class PostsContainer extends StatefulWidget {
  const PostsContainer({super.key});

  @override
  State<PostsContainer> createState() => _PostsContainerState();
}

class _PostsContainerState extends State<PostsContainer> {
  Widget listOfPosts() {
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
                        SingleChildScrollView(
                          child: Row(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: themeSettings.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: listOfPosts(),
    );
  }
}
