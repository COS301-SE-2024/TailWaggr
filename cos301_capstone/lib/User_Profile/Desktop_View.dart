// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/Pets/Pet_Profile.dart';
import 'package:cos301_capstone/services/HomePage/home_page_service.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class ProfileDesktop extends StatefulWidget {
  const ProfileDesktop({super.key, required this.userId});

  final String userId;
  @override
  State<ProfileDesktop> createState() => _ProfileDesktopState();
}

class _ProfileDesktopState extends State<ProfileDesktop> {

  ProfileDetails localProfileDetails = ProfileDetails();

  String formatDate(DateTime date) {
    return "${date.day} ${getMonthAbbreviation(date.month)} ${date.year}";
  }

  @override
  void initState() {
    super.initState();

    Future<void> getProfileDetails() async {
      if (widget.userId != profileDetails.userID) {
        Map<String, dynamic>? tempDetails = await ProfileService().getUserDetails(widget.userId);

        if (tempDetails != null && tempDetails['profileVisibility']) {
          localProfileDetails.userID = widget.userId;
          localProfileDetails.name = tempDetails['name'];
          localProfileDetails.surname = tempDetails['surname'];
          localProfileDetails.email = tempDetails['email'];
          localProfileDetails.bio = tempDetails['bio'];
          localProfileDetails.profilePicture = tempDetails['profilePictureUrl'];
          localProfileDetails.location = tempDetails['location'];
          localProfileDetails.phone = tempDetails['phoneDetails']['phoneNumber'];
          localProfileDetails.isoCode = tempDetails['phoneDetails']['isoCode'];
          localProfileDetails.dialCode = tempDetails['phoneDetails']['dialCode'];
          localProfileDetails.birthdate = formatDate(tempDetails['birthDate'].toDate());
          localProfileDetails.userType = tempDetails['userType'];

          localProfileDetails.pets = await ProfileService().getUserPets(widget.userId);
          List<DocumentReference> localPosts = await ProfileService().getUserPosts(widget.userId);

          profileDetails.myPosts.clear();

          for (var post in localPosts) {
            DocumentSnapshot postSnapshot = await post.get();
            Map<String, dynamic> postData = postSnapshot.data() as Map<String, dynamic>;
            postData['PostId'] = postSnapshot.id;
            localProfileDetails.myPosts.add(postData);
            print("Post data: $postData");
          }
        } else {
          localProfileDetails.userID = widget.userId;
          localProfileDetails.name = tempDetails!['name'];
          localProfileDetails.surname = tempDetails['surname'];
          localProfileDetails.bio = tempDetails['bio'];
          localProfileDetails.profilePicture = tempDetails['profilePictureUrl'];

          // Stubbed data
          localProfileDetails.email = "Private Profile";
          localProfileDetails.phone = "Private Profile";
          localProfileDetails.birthdate = "Private Profile";
          localProfileDetails.location = "Private Profile";
          localProfileDetails.userType = "Private Profile";
        }

        setState(() {
          print("Profile details set successfully for: ${localProfileDetails.userID}");
        });
      } else {
        localProfileDetails = profileDetails;
      }
    }

    getProfileDetails();

    profileDetails.isEditing.addListener(() {
      setState(() {});
    });

    PetProfileVariables.petEditted.addListener(() {
      Future<List<Map<String, dynamic>>> pets = GeneralService().getUserPets(profileDetails.userID);
      pets.then((value) {
        setState(() {
          profileDetails.pets = value;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    profileDetails.isEditing.removeListener(() {});
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
                    child: AboutMeContainer(profileDetails: localProfileDetails),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        MyPetsContainer(profileDetails: localProfileDetails),
                        SizedBox(height: 20),
                        PostsContainer(localProfileDetails: localProfileDetails),
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
  const PostsContainer({super.key, required this.localProfileDetails});

  final ProfileDetails localProfileDetails;

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
              ListOfPosts(profileDetails: widget.localProfileDetails),
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfPosts extends StatefulWidget {
  const ListOfPosts({super.key, required this.profileDetails});

  final ProfileDetails profileDetails;

  @override
  State<ListOfPosts> createState() => _ListOfPostsState();
}

class _ListOfPostsState extends State<ListOfPosts> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var post in widget.profileDetails.myPosts) ...[
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
                  if (widget.profileDetails.email == profileDetails.email) ...[
                    IconButton(
                      icon: Icon(Icons.delete, color: themeSettings.primaryColor),
                      onPressed: () async {
                        print("PostId: ${post["PostId"]}");

                        bool deleted = await HomePageService().deletePost(post["PostId"]);

                        if (deleted) {
                          print("Post deleted successfully.");
                          setState(() {
                            profileDetails.myPosts.remove(post);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete post'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    )
                  ],
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
  const AboutMeContainer({super.key, required this.profileDetails});

  final ProfileDetails profileDetails;

  @override
  State<AboutMeContainer> createState() => _AboutMeContainerState();
}

class _AboutMeContainerState extends State<AboutMeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
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
              backgroundImage: NetworkImage(widget.profileDetails.profilePicture),
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.profileDetails.name} ${widget.profileDetails.surname}", style: TextStyle(fontSize: subHeadingTextSize)),
                Text(widget.profileDetails.bio, style: TextStyle(fontSize: subBodyTextSize)),
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
                          widget.profileDetails.email,
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
                          widget.profileDetails.phone,
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
                          widget.profileDetails.birthdate,
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
                          widget.profileDetails.location,
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
  const MyPetsContainer({super.key, required this.profileDetails});

  final ProfileDetails profileDetails;

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
              for (var pet in widget.profileDetails.pets) ...[
                if (widget.profileDetails.userID == profileDetails.userID) ...[
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
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: PetProfileButton(
                      petName: pet["name"],
                      petBio: pet["bio"],
                      petPicture: pet["pictureUrl"],
                    ),
                  ),
                ]
              ],
              SizedBox(height: 20),
              if (widget.profileDetails.email == profileDetails.email) ...[
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
              ],
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
