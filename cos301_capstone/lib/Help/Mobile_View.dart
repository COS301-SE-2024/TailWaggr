// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:accordion/accordion.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileHelp extends StatefulWidget {
  const MobileHelp({super.key});

  @override
  State<MobileHelp> createState() => _MobileHelpState();
}

class _MobileHelpState extends State<MobileHelp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: themeSettings.backgroundColor,
      child: Container(
        width: (MediaQuery.of(context).size.width),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: themeSettings.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Help Menu",
                style: TextStyle(
                  color: themeSettings.textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("How do i?", style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold)),
              Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("General", style: TextStyle(color: themeSettings.textColor.withOpacity(0.5), fontSize: 12)),
                ),
                Expanded(child: Divider()),
              ]),
              Accordion(
                headerBorderColor: themeSettings.primaryColor,
                headerBorderWidth: 1,
                headerBorderColorOpened: themeSettings.primaryColor,
                headerBackgroundColor: Colors.transparent,
                contentBackgroundColor: themeSettings.cardColor,
                contentBorderColor: themeSettings.primaryColor,
                contentBorderWidth: 1,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                children: <AccordionSection>[
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Logout?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click on the profile icon on the bottom left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click logout.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Change my theme?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click on the profile icon on the bottom left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click on the top option of the dropdown menu.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Select the theme you would like to use.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
              Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Homepage", style: TextStyle(color: themeSettings.textColor.withOpacity(0.5), fontSize: 12)),
                ),
                Expanded(child: Divider()),
              ]),
              Accordion(
                headerBorderColor: themeSettings.primaryColor,
                headerBorderWidth: 1,
                headerBorderColorOpened: themeSettings.primaryColor,
                headerBackgroundColor: Colors.transparent,
                contentBackgroundColor: themeSettings.cardColor,
                contentBorderColor: themeSettings.primaryColor,
                contentBorderWidth: 1,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                children: <AccordionSection>[
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Make a post?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Homepage listed as 'Home' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the right hand side of thhe screen to the posts container",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Type in your post's caption.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Upload an image of your choosing.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Select which pets were involved in the post.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Once you have filled in all the necessary information, click the 'Post' button to submit your post.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Like a post?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Homepage listed as 'Home' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• For each post you will see a red paw print icon, click on this icon to like the post.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Comment on a post?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Homepage listed as 'Home' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• For each post you will see a comment icon, click on this icon.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Type in your comment and click the 'Reply' button in thhe bottom right hand corner to submit your comment.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Notifications", style: TextStyle(color: themeSettings.textColor.withOpacity(0.5), fontSize: 12)),
                ),
                Expanded(child: Divider()),
              ]),
              Accordion(
                headerBorderColor: themeSettings.primaryColor,
                headerBorderWidth: 1,
                headerBorderColorOpened: themeSettings.primaryColor,
                headerBackgroundColor: Colors.transparent,
                contentBackgroundColor: themeSettings.cardColor,
                contentBorderColor: themeSettings.primaryColor,
                contentBorderWidth: 1,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                children: <AccordionSection>[
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "View my notifications?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Notifications page listed as 'Notifications' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Once the notifications have loaded, click on the one you want to view.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Locate", style: TextStyle(color: themeSettings.textColor.withOpacity(0.5), fontSize: 12)),
                ),
                Expanded(child: Divider()),
              ]),
              Accordion(
                headerBorderColor: themeSettings.primaryColor,
                headerBorderWidth: 1,
                headerBorderColorOpened: themeSettings.primaryColor,
                headerBackgroundColor: Colors.transparent,
                contentBackgroundColor: themeSettings.cardColor,
                contentBorderColor: themeSettings.primaryColor,
                contentBorderWidth: 1,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                children: <AccordionSection>[
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "View vets in my area?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Locate page listed as 'Locate' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Enter the name and / or the distance of the vet you are looking for.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click the 'Apply Filters' button to view the vets in your area.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Once the list of vets is updated click on the vet you wish to visit.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click the red pin icon to view the vet's location on the map.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "View pet sitters in my area?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Locate page listed as 'Locate' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Enter the name and / or the distance of the pet sitter you are looking for.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click the 'Apply Filters' button to view the pet sitters in your area.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Once the list of pet sitters is updated click on the pet sitter you wish to contact.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Forums", style: TextStyle(color: themeSettings.textColor.withOpacity(0.5), fontSize: 12)),
                ),
                Expanded(child: Divider()),
              ]),
              Accordion(
                headerBorderColor: themeSettings.primaryColor,
                headerBorderWidth: 1,
                headerBorderColorOpened: themeSettings.primaryColor,
                headerBackgroundColor: Colors.transparent,
                contentBackgroundColor: themeSettings.cardColor,
                contentBorderColor: themeSettings.primaryColor,
                contentBorderWidth: 1,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                children: <AccordionSection>[
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Create a forum?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "View forums?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Forum page listed as 'Forums' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Enter the name of the forum you are looking for. Alternatively, you can view a list of all the forums as standard.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click on thhe forum you wish to view.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Once the forum has loaded, you can view the posts and comments and create your own comment.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Profile", style: TextStyle(color: themeSettings.textColor.withOpacity(0.5), fontSize: 12)),
                ),
                Expanded(child: Divider()),
              ]),
              Accordion(
                headerBorderColor: themeSettings.primaryColor,
                headerBorderWidth: 1,
                headerBorderColorOpened: themeSettings.primaryColor,
                headerBackgroundColor: Colors.transparent,
                contentBackgroundColor: themeSettings.cardColor,
                contentBorderColor: themeSettings.primaryColor,
                contentBorderWidth: 1,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                children: <AccordionSection>[
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "View my profile?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Profile page listed as 'Profile' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "See my pets?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Profile page listed as 'Profile' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• View your pets listed on the top right hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Add a new pet?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Profile page listed as 'Profile' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• At the top right hand side of the screen, click the 'Add Pet' button at the bottom of te list of pets.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Update my pets information?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Profile page listed as 'Profile' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click on the pet you wish to update.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Update the relevant information and click the 'Update' button to save the changes.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "See my posts?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Forum page listed as 'Forums' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• View your posts listed on the bottom right hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Settings", style: TextStyle(color: themeSettings.textColor.withOpacity(0.5), fontSize: 12)),
                ),
                Expanded(child: Divider()),
              ]),
              Accordion(
                headerBorderColor: themeSettings.primaryColor,
                headerBorderWidth: 1,
                headerBorderColorOpened: themeSettings.primaryColor,
                headerBackgroundColor: Colors.transparent,
                contentBackgroundColor: themeSettings.cardColor,
                contentBorderColor: themeSettings.primaryColor,
                contentBorderWidth: 1,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                children: <AccordionSection>[
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Edit my profile?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Settings page listed as 'Settings' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click on the Edit Profile tab at the top of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Update the relevant information and click the 'Save Changes' button to save the changes.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Edit theme settings?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Settings page listed as 'Settings' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click on the Edit Theme tab at the top of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Update the relevant information and click the 'Save Changes' button to save the changes.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                 AccordionSection(
                    isOpen: false,
                    rightIcon: Icon(Icons.arrow_drop_down, color: themeSettings.textColor),
                    header: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Edit navbar settings?",
                        style: TextStyle(color: themeSettings.textColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Click on the drawer icon on the top left hand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Navigate to the Settings page listed as 'Settings' on the lefthand side of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Click on the Edit Navbar tab at the top of the screen.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          Text(
                            "• Update the relevant information and click the 'Save Changes' button to save the changes.",
                            style: TextStyle(color: themeSettings.textColor, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          moreInfoButton(),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget moreInfoButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final Uri url = Uri.parse('https://docs.google.com/document/d/1TiRA697HTTGuLCOzq20es4q_fotXlDpTnVuov_7zNP0/edit?usp=sharing ');
          if (!await launchUrl(url)) {
            print('Could not launch $url');
          }
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
        ),
        child: Text("More information", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
