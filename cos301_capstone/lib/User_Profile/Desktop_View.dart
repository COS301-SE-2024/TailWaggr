// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/Navbar/Navbar.dart';
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
    print(themeSettings.Card_Colour);
    super.initState();
  }

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
                color: themeSettings.Text_Colour,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: ListenableBuilder(
                      listenable: navbarIndexObserver,
                      builder: (BuildContext context, Widget? child) {
                        return AboutMeContainer();
                      },
                    ),
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
          color: themeSettings.Card_Colour,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: themeSettings.Text_Colour.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                dividerColor: Colors.transparent,
                tabs: [
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
        color: themeSettings.Card_Colour,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: themeSettings.Text_Colour.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
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
                        iconTheme: IconThemeData(color: themeSettings.Primary_Colour),
                      ),
                      body: EditProfile(),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text("Profile Details", style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Primary_Colour)),
                Divider(),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.Card_Colour,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.Primary_Colour),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined, color: themeSettings.Text_Colour.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          profileDetails.Email,
                          style: TextStyle(fontSize: Sub_Body_Text_Size),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.Card_Colour,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.Primary_Colour),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: themeSettings.Text_Colour.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          profileDetails.Phone,
                          style: TextStyle(fontSize: Sub_Body_Text_Size),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.Card_Colour,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.Primary_Colour),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month, color: themeSettings.Text_Colour.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          profileDetails.Birthdate,
                          style: TextStyle(fontSize: Sub_Body_Text_Size),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.Card_Colour,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.Primary_Colour),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.home, color: themeSettings.Text_Colour.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          profileDetails.Location,
                          style: TextStyle(fontSize: Sub_Body_Text_Size),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text("User type", style: TextStyle(fontSize: Body_Text_Size, color: themeSettings.Primary_Colour)),
                Divider(),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeSettings.Card_Colour,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: themeSettings.Primary_Colour),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.pets, color: themeSettings.Text_Colour.withOpacity(0.5)),
                      SizedBox(width: 10),
                      Text("Pet enthusiast", style: TextStyle(fontSize: Sub_Body_Text_Size)),
                    ],
                  ),
                ),
                if (profileDetails.UserType == "Veterinarian")
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: themeSettings.Card_Colour,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: themeSettings.Primary_Colour),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.medical_services, color: themeSettings.Text_Colour.withOpacity(0.5)),
                        SizedBox(width: 10),
                        Text("Veterinarian", style: TextStyle(fontSize: Sub_Body_Text_Size)),
                      ],
                    ),
                  ),
                if (profileDetails.UserType == "PetKeeper")
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: themeSettings.Card_Colour,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: themeSettings.Primary_Colour),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.medical_services, color: themeSettings.Text_Colour.withOpacity(0.5)),
                        SizedBox(width: 10),
                        Text("Pet sitter", style: TextStyle(fontSize: Sub_Body_Text_Size)),
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
          color: themeSettings.Card_Colour,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: themeSettings.Text_Colour.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
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
                  fontSize: Sub_Heading_Text_Size,
                  color: themeSettings.Primary_Colour,
                ),
              ),
              Divider(),
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
        ),
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
