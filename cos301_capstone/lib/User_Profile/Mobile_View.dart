// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animations/animations.dart';
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

class ProfileMobile extends StatefulWidget {
  const ProfileMobile({super.key, required this.userId});

  final String userId;
  @override
  State<ProfileMobile> createState() => _ProfileMobileState();
}

class _ProfileMobileState extends State<ProfileMobile> {
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

        setState(() {});
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
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
              AboutMeContainer(profileDetails: localProfileDetails),
              SizedBox(height: 20),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    DetailsContainer(profileDetails: localProfileDetails),
                  ],
                ),
              )
            ],
          ),
        ),
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
            backgroundImage: NetworkImage(widget.profileDetails.profilePicture),
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.profileDetails.name} ${widget.profileDetails.surname}',
                  style: TextStyle(fontSize: subHeadingTextSize),
                ),
                Text(widget.profileDetails.bio, style: TextStyle(fontSize: subBodyTextSize)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsContainer extends StatefulWidget {
  const DetailsContainer({super.key, required this.profileDetails});

  final ProfileDetails profileDetails;
  @override
  State<DetailsContainer> createState() => _DetailsContainerState();
}

class _DetailsContainerState extends State<DetailsContainer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                    child: Icon(Icons.person_outline),
                  ),
                  Tab(
                    child: Icon(Icons.pets_outlined),
                  ),
                  Tab(
                    child: Icon(Icons.add_box_outlined),
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: TabBarView(
                  children: [
                    PersonalDetailsContainer(profileDetails: widget.profileDetails),
                    MyPetsContainer(profileDetails: widget.profileDetails),
                    PostsContainer(profileDetails: widget.profileDetails),
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
  const PersonalDetailsContainer({super.key, required this.profileDetails});

  final ProfileDetails profileDetails;
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var pet in widget.profileDetails.pets) ...[
            if (widget.profileDetails.email == profileDetails.email) ...[
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
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: petProfileButton(
                  pet["name"],
                  pet["bio"],
                  pet["pictureUrl"],
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
    );
  }
}

class PostsContainer extends StatefulWidget {
  const PostsContainer({super.key, required this.profileDetails});

  final ProfileDetails profileDetails;
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
          for (var post in widget.profileDetails.myPosts) ...[
            Stack(
              children: [
                IntrinsicHeight(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            post["ImgUrl"],
                            width: MediaQuery.of(context).size.width,
                            // height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          post["Content"],
                          style: TextStyle(
                            color: themeSettings.textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                        SizedBox(height: 20),
                        if (post['PetIds'].length > 0) ...[
                          Text(
                            "Pets included in this post: ",
                            style: TextStyle(
                              color: themeSettings.textColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var pet in post['PetIds']) ...[
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(pet["pictureUrl"]),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          pet["name"],
                                          style: TextStyle(color: themeSettings.textColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (widget.profileDetails.email == profileDetails.email) ...[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
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
                    ),
                  ),
                ]
              ],
            ),
            Divider(),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeSettings.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: listOfPosts(),
    );
  }
}
