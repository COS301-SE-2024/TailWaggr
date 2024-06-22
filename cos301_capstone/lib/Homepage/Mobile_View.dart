// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class MobileHomepage extends StatefulWidget {
  const MobileHomepage({super.key});

  @override
  State<MobileHomepage> createState() => _MobileHomepageState();
}

class _MobileHomepageState extends State<MobileHomepage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(20),
      color: themeSettings.backgroundColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                for (int i = 0; i < 10; i++) ...[
                  Post(),
                  Divider(),
                ],
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: OpenContainer(
              closedBuilder: (BuildContext context, void Function() action) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add, color: Colors.white),
                );
              },
              closedColor: themeSettings.primaryColor,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              openBuilder: (BuildContext context, void Function() action) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: themeSettings.primaryColor,
                    iconTheme: IconThemeData(color: Colors.white),
                    title: Text(
                      "Upload Post",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  body: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: themeSettings.backgroundColor,
                    padding: EdgeInsets.all(20),
                    child: UploadPostContainer(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(profileDetails.profilePicture),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      profileDetails.name,
                      style: TextStyle(
                        color: themeSettings.textColor,
                      ),
                    ),
                    Text(
                      "Posted on ${DateTime.now().toString().split(" ")[0]}",
                      style: TextStyle(
                        color: themeSettings.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                profileDetails.pets[Random().nextInt(9)]["profilePicture"],
                width: MediaQuery.of(context).size.width,
                // height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              style: TextStyle(
                color: themeSettings.textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
            SizedBox(height: 20),
            if (profileDetails.pets.isNotEmpty) ...[
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
                    for (var pet in profileDetails.pets) ...[
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(pet["profilePicture"]),
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
            SizedBox(height: 20),
            Row(
              children: [
                Tooltip(
                  message: "Like",
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red.withOpacity(0.7),
                    ),
                  ),
                ),
                Text("0", style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                Spacer(),
                Tooltip(
                  message: "Comment",
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.comment,
                      color: Colors.blue.withOpacity(0.7),
                    ),
                  ),
                ),
                Text("0", style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                Spacer(),
                Tooltip(
                  message: "Views",
                  child: Icon(
                    Icons.bar_chart,
                    color: Colors.green.withOpacity(0.7),
                  ),
                ),
                Text("0", style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UploadPostContainer extends StatefulWidget {
  const UploadPostContainer({super.key});

  @override
  State<UploadPostContainer> createState() => _UploadPostContainerState();
}

class _UploadPostContainerState extends State<UploadPostContainer> {
  int petIncludeCounter = 0;
  List<bool> petAdded = [];
  List<Map<String, dynamic>> petList = [];
  TextEditingController postController = TextEditingController();
  bool selectingPet = false;
  List<bool> removePet = [];

  @override
  void initState() {
    super.initState();
    imagePicker.filesNotifier.addListener(() {
      setState(() {}); // Rebuild the widget when files are selected
    });

    for (var _ in profileDetails.pets) {
      petAdded.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: postController,
            decoration: InputDecoration(
              labelText: "What's on your mind",
            ),
            maxLines: null, // Allow unlimited lines
            keyboardType: TextInputType.multiline, // Enable multiline input
            style: TextStyle(color: themeSettings.textColor),
          ),
          SizedBox(height: 20),
          if (imagePicker.filesNotifier.value != null && imagePicker.filesNotifier.value!.isNotEmpty) ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    imagePicker.filesNotifier.value![0].bytes!,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    color: Colors.white.withOpacity(0.5),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                    onPressed: () => imagePicker.clearCachedFiles(),
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
              child: GestureDetector(
                onTap: () => imagePicker.pickFiles(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          color: themeSettings.textColor.withOpacity(0.7),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Add a photo",
                          style: TextStyle(color: themeSettings.textColor.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: 20),
          Text(
            "Include your pets",
            style: TextStyle(
              color: themeSettings.textColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(100),
                      color: themeSettings.textColor,
                      strokeWidth: 0.5,
                      dashPattern: [5, 5], // Modify the dash pattern to make the border more spread out
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectingPet = true;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: themeSettings.textColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                    if (selectingPet) ...[
                      Container(
                        padding: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width - 40,
                        constraints: BoxConstraints(maxHeight: 200), // Set the maximum width
                        decoration: BoxDecoration(
                          color: themeSettings.cardColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Select a pet",
                                    style: TextStyle(
                                      color: themeSettings.textColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectingPet = false;
                                      });
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              for (int i = 0; i < profileDetails.pets.length; i++) ...[
                                if (petAdded[i] == false)
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          petIncludeCounter++;
                                          selectingPet = false;
                                          removePet.add(false);
                                          petList.add(
                                            {'name': profileDetails.pets[i]['name'], 'profilePicture': profileDetails.pets[i]['profilePicture'], 'index': i},
                                          );
                                          petAdded[i] = true;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(profileDetails.pets[i]["profilePicture"]),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              profileDetails.pets[i]['name'],
                                              style: TextStyle(
                                                color: themeSettings.textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(width: 10),
                for (int i = 0; i < petIncludeCounter; i++) ...[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                removePet[i] = !removePet[i];
                              });
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(petList[i]["profilePicture"]!),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          petList[i]["name"]!,
                          style: TextStyle(color: themeSettings.textColor),
                        ),
                        SizedBox(height: 5),
                        if (removePet[i]) ...[
                          DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(100),
                            color: themeSettings.textColor,
                            strokeWidth: 0.5,
                            dashPattern: [5, 5], // Modify the dash pattern to make the border more spread out
                            child: IconButton(
                              iconSize: 15,
                              onPressed: () {
                                setState(() {
                                  petIncludeCounter--;
                                  petAdded[petList[i]["index"]] = false;
                                  removePet.removeAt(i);
                                  petList.removeAt(i);
                                });
                              },
                              icon: Icon(
                                Icons.remove,
                                color: themeSettings.textColor.withOpacity(0.7),
                              ),
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
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                print("---------------------------------------");
                print("Post Details: ");

                if (postController.text.isNotEmpty) {
                  print("Post text: ${postController.text}");
                } else {
                  print("Cannot post without a message");
                }

                if (imagePicker.filesNotifier.value != null && imagePicker.filesNotifier.value!.isNotEmpty) {
                  print("Image: ${imagePicker.filesNotifier.value![0].name}");
                } else {
                  print("No image selected");
                }

                if (petIncludeCounter > 0) {
                  print("Pets included: ");
                  for (int i = 0; i < petIncludeCounter; i++) {
                    print("Pet ${i + 1}: ${petList[i]['name']}");
                  }
                } else {
                  print("No pets included");
                }

                print("---------------------------------------");

                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
