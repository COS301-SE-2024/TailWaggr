// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animations/animations.dart';
import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:flutter/material.dart';

class ProfileTablet extends StatefulWidget {
  const ProfileTablet({Key? key}) : super(key: key);

  @override
  State<ProfileTablet> createState() => _ProfileTabletState();
}

class _ProfileTabletState extends State<ProfileTablet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DesktopNavbar(),
          Container(
            width: MediaQuery.of(context).size.width - (themeSettings.searchVisible ? 550 : 250),
            color: ThemeSettings.Background_Colour,
            padding: EdgeInsets.all(20),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 20,
                color: ThemeSettings.Text_Colour,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AbouMeContainer(),
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
        color: ThemeSettings.Card_Colour,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ThemeSettings.Text_Colour.withOpacity(0.2),
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
            backgroundImage: NetworkImage(profileDetails.ProfilePicture),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(profileDetails.Name, style: TextStyle(fontSize: Sub_Heading_Text_Size)),
                  Text(profileDetails.Bio, style: TextStyle(fontSize: Sub_Body_Text_Size)),
                ],
              ),
              SizedBox(height: 20),
              OpenContainer(
                transitionDuration: Duration(milliseconds: 300),
                closedBuilder: (context, action) {
                  return Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: themeSettings.Primary_Colour,
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
                        style: TextStyle(color: themeSettings.Primary_Colour, fontSize: 20),
                      ),
                      iconTheme: IconThemeData(color: themeSettings.Primary_Colour),
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
          color: ThemeSettings.Card_Colour,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: ThemeSettings.Text_Colour.withOpacity(0.2),
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
                petName: pet["Name"],
                petBio: pet["Bio"],
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
                style: TextStyle(fontSize: Sub_Heading_Text_Size),
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(height: 8),
              Text(
                widget.petBio,
                style: TextStyle(fontSize: Sub_Body_Text_Size),
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