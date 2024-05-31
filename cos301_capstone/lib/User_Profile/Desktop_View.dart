// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/material.dart';

class ProfileDesktop extends StatefulWidget {
  const ProfileDesktop({Key? key}) : super(key: key);

  @override
  State<ProfileDesktop> createState() => _ProfileDesktopState();
}

class _ProfileDesktopState extends State<ProfileDesktop> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 20,
        color: themeSettings.Text_Colour,
      ),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: AbouMeContainer(),
            ),
            SizedBox(width: 20),
            // Divider(),
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
              offset: Offset(0, 5),
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
                // Text(
                //   "About Me",
                //   style: TextStyle(
                //     fontSize: Subtitle_Text_Size,
                //     color: themeSettings.Primary_Colour,
                //   ),
                // ),
                // SizedBox(height: 20),
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
                      Text(profileDetails.Email, style: TextStyle(fontSize: Sub_Body_Text_Size)),
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
                      Text(profileDetails.Phone, style: TextStyle(fontSize: Sub_Body_Text_Size)),
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
                      Text(profileDetails.Birthdate, style: TextStyle(fontSize: Sub_Body_Text_Size)),
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
