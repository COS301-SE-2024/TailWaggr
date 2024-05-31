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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AbouMeContainer(),
            SizedBox(height: 20),
            // Divider(),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  // Container taking up 1/3rd of the width
                  MyPetsContainer(),
                  SizedBox(width: 20),
                  // Container taking up 2/3rds of the width
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
                        Text(
                          "Personal Details",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
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
                    PersonalDetails(),
                    Icon(Icons.add_box_outlined),
                    Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ],
          ),
        ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.vertical,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [

        //     ],
        //   ),
        // ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(profileDetails.ProfilePicture),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About Me",
                style: TextStyle(
                  fontSize: Subtitle_Text_Size,
                  color: themeSettings.Primary_Colour,
                ),
              ),
              SizedBox(height: 20),
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
                child: Text("Edit Profile", style: TextStyle(color: themeSettings.Text_Colour)),
              ),
            ],
          )
        ],
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
      flex: 1, // This sets the flex to 1/3rd
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
                  fontSize: Subtitle_Text_Size,
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
    return SizedBox(
      width: 300,
      child: Row(
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
      ),
    );
  }
}

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.Card_Colour,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themeSettings.Primary_Colour),
            ),
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: themeSettings.Text_Colour.withOpacity(0.5)),
                SizedBox(width: 10),
                Text(profileDetails.Email),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.Card_Colour,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themeSettings.Primary_Colour),
            ),
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: themeSettings.Text_Colour.withOpacity(0.5)),
                SizedBox(width: 10),
                Text(profileDetails.Email),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.Card_Colour,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themeSettings.Primary_Colour),
            ),
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: themeSettings.Text_Colour.withOpacity(0.5)),
                SizedBox(width: 10),
                Text(profileDetails.Email),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.Card_Colour,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themeSettings.Primary_Colour),
            ),
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: themeSettings.Text_Colour.withOpacity(0.5)),
                SizedBox(width: 10),
                Text(profileDetails.Email),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.Card_Colour,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themeSettings.Primary_Colour),
            ),
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: themeSettings.Text_Colour.withOpacity(0.5)),
                SizedBox(width: 10),
                Text(profileDetails.Email),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.Card_Colour,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themeSettings.Primary_Colour),
            ),
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: themeSettings.Text_Colour.withOpacity(0.5)),
                SizedBox(width: 10),
                Text(profileDetails.Email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
