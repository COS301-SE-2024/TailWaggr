// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animations/animations.dart';
import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
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
    return Scaffold(
      body: Row(
        children: [
          Container(
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
                  AboutMeContainer(),
                  SizedBox(height: 20),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(profileDetails.name, style: TextStyle(fontSize: subHeadingTextSize)),
                  Text(profileDetails.bio, style: TextStyle(fontSize: subBodyTextSize)),
                ],
              ),
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
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        "Edit Profile",
                        style: TextStyle(color: themeSettings.primaryColor, fontSize: 20),
                      ),
                      iconTheme: IconThemeData(color: themeSettings.primaryColor),
                    ),
                    body: EditProfile(),
                  );
                },
              ),
            ],
          )
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
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(width: 10),
                        Text("Events"),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: TabBarView(
                  children: [
                    MyPetsContainer(),
                    Icon(Icons.add_box_outlined),
                    Icon(Icons.calendar_month),
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

class MyPetsContainer extends StatefulWidget {
  const MyPetsContainer({super.key});

  @override
  State<MyPetsContainer> createState() => _MyPetsContainerState();
}

class _MyPetsContainerState extends State<MyPetsContainer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var pet in profileDetails.pets)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: PetProfileButton(
                petName: pet["name"],
                petBio: pet["bio"],
              ),
            ),
        ],
      ),
    );
  }
}

class PetProfileButton extends StatefulWidget {
  const PetProfileButton({Key? key, required this.petName, required this.petBio}) : super(key: key);

  final String petName;
  final String petBio;

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
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.petName,
                style: TextStyle(fontSize: subHeadingTextSize),
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(height: 8),
              Text(
                widget.petBio,
                style: TextStyle(fontSize: subBodyTextSize),
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
